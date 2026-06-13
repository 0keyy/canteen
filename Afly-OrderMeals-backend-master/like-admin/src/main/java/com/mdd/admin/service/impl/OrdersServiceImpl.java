package com.mdd.admin.service.impl;

import com.alibaba.fastjson2.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.github.yulichang.query.MPJQueryWrapper;
import com.mdd.admin.LikeAdminThreadLocal;
import com.mdd.admin.service.IOrdersServcice;
import com.mdd.admin.util.AdminNotifyUtils;
import com.mdd.admin.validate.order.OrdersSearchValidate;
import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.vo.orders.OrdersCurrentVo;
import com.mdd.admin.vo.orders.OrdersDishListVo;
import com.mdd.admin.vo.orders.OrdersListVo;
import com.mdd.common.config.GlobalConfig;
import com.mdd.common.constant.PayChannelConstant;
import com.mdd.common.core.PageResult;
import com.mdd.common.entity.orders.OrderPay;
import com.mdd.common.entity.orders.Orders;
import com.mdd.common.entity.orders.OrdersDish;
import com.mdd.common.exception.BaseException;
import com.mdd.common.mapper.orders.OrderPayMapper;
import com.mdd.common.mapper.orders.OrdersDishMapper;
import com.mdd.common.mapper.orders.OrdersMapper;
import com.mdd.common.util.StringUtils;
import com.mdd.common.util.TimeUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

@Service
public class OrdersServiceImpl implements IOrdersServcice {

    private static final String CHANNEL_MINIAPP = "miniapp";
    private static final String CHANNEL_CASHIER = "cashier";

    @Resource
    OrdersMapper ordersMapper;
    @Resource
    OrdersDishMapper ordersDishMapper;
    @Resource
    OrderPayMapper orderPayMapper;

    @Override
    public PageResult<OrdersListVo> list(PageValidate pageValidate, OrdersSearchValidate searchValidate) {
        Integer pageNo = pageValidate.getPageNo();
        Integer pageSize = pageValidate.getPageSize();
        Integer aid = LikeAdminThreadLocal.getAdminId();

        MPJQueryWrapper<Orders> mpjQueryWrapper = new MPJQueryWrapper<Orders>()
                .selectAll(Orders.class)
                .select("ad.name as deskName")
                .leftJoin("?_system_auth_dept ad ON ad.id=t.desk_id".replace("?_", GlobalConfig.tablePrefix))
                .eq("t.aid", aid)
                .orderByDesc("t.id");

        applyChannelFilter(mpjQueryWrapper, searchValidate.getChannel());
        applyCalledFilter(mpjQueryWrapper, searchValidate.getCalled());

        ordersMapper.setSearch(mpjQueryWrapper, searchValidate, new String[]{
                "=:type@t.type:int",
                "=:diningMode@t.dining_mode:int",
                "=:source@t.source:int",
                "=:status@t.status:int",
                "=:payStatus@t.pay_status:int",
                "like:contactMobile@t.contact_mobile:str",
                "between:checkoutTime@t.checkout_time:long",
                "between:createTime@t.create_time:long",
        });

        IPage<Orders> iPage = ordersMapper.selectJoinPage(
                new Page<>(pageNo, pageSize),
                Orders.class,
                mpjQueryWrapper);

        List<OrdersListVo> list = new LinkedList<>();
        for (Orders item : iPage.getRecords()) {
            OrdersListVo vo = new OrdersListVo();
            BeanUtils.copyProperties(item, vo);
            vo.setDeskName(item.getDeskName());
            String payType = resolvePayType(item);
            vo.setPayType(payType);
            vo.setPayTypeText(PayChannelConstant.displayName(payType));
            vo.setCreateTime(TimeUtils.timestampToDate(item.getCreateTime()));
            vo.setSubmitTime(formatTime(item.getSubmitTime()));
            vo.setPayTime(formatTime(item.getPayTime()));
            vo.setCalledTime(formatTime(item.getCalledTime()));
            vo.setCheckoutTime(item.getCheckoutTime() != null && item.getCheckoutTime() > 0
                    ? TimeUtils.timestampToDate(item.getCheckoutTime()) : "-");
            list.add(vo);
        }

        return PageResult.iPageHandle(iPage.getTotal(), iPage.getCurrent(), iPage.getSize(), list);
    }

    @Override
    public List<OrdersDishListVo> dish(Integer id) {
        MPJQueryWrapper<OrdersDish> mpjQueryWrapper = new MPJQueryWrapper<OrdersDish>()
                .select("t.amount as amount")
                .select("t.quantity as number")
                .select("ar.title as name")
                .innerJoin("?_article ar ON t.dish_id=ar.id".replace("?_", GlobalConfig.tablePrefix))
                .eq("t.order_id", id);
        return ordersDishMapper.selectJoinList(OrdersDishListVo.class, mpjQueryWrapper);
    }

    @Override
    public List<OrdersCurrentVo> current() {
        QueryWrapper<Orders> ordersQueryWrapper = new QueryWrapper<Orders>()
                .eq("aid", LikeAdminThreadLocal.getAdminId())
                .eq("user_id", 0)
                .ne("status", 2);
        List<Orders> orders = ordersMapper.selectList(ordersQueryWrapper);
        List<OrdersCurrentVo> ordersCurrentVos = new ArrayList<>();
        for (Orders item : orders) {
            OrdersCurrentVo ordersCurrentVo = new OrdersCurrentVo();
            BeanUtils.copyProperties(item, ordersCurrentVo);
            ordersCurrentVo.setNumber(item.getId());
            ordersCurrentVos.add(ordersCurrentVo);
        }
        return ordersCurrentVos;
    }

    @Override
    @Transactional
    public void callNumber(Integer orderId) {
        Orders orders = getMiniappOrder(orderId);
        if (orders.getPayStatus() == null || orders.getPayStatus() != 1) {
            throw new BaseException(500, "仅已支付订单可叫号");
        }
        if (orders.getStatus() == null || orders.getStatus() != 1) {
            throw new BaseException(500, "仅制作中订单可叫号");
        }
        long now = TimeUtils.timestamp();
        Orders update = new Orders();
        update.setId(orders.getId());
        update.setCalledTime(now);
        ordersMapper.updateById(update);

        JSONObject payload = new JSONObject();
        payload.put("action", "order_call");
        payload.put("orderId", orders.getId());
        payload.put("pickupCode", orders.getPickupCode());
        payload.put("calledTime", now);
        AdminNotifyUtils.notifySeller(orders.getAid().toString(), payload);
    }

    @Override
    @Transactional
    public void complete(Integer orderId) {
        Orders orders = getMiniappOrder(orderId);
        if (orders.getStatus() != null && orders.getStatus() == 2) {
            return;
        }
        if (orders.getPayStatus() == null || orders.getPayStatus() != 1) {
            throw new BaseException(500, "仅已支付订单可完成");
        }
        if (orders.getStatus() == null || (orders.getStatus() != 1 && orders.getStatus() != 4)) {
            throw new BaseException(500, "当前订单状态不可完成");
        }
        long now = TimeUtils.timestamp();
        Orders update = new Orders();
        update.setId(orders.getId());
        update.setStatus(2);
        update.setCheckoutTime(now);
        ordersMapper.updateById(update);
    }

    private Orders getMiniappOrder(Integer orderId) {
        Integer aid = LikeAdminThreadLocal.getAdminId();
        Orders orders = ordersMapper.selectOne(new QueryWrapper<Orders>()
                .eq("id", orderId)
                .eq("aid", aid)
                .gt("user_id", 0)
                .last("limit 1"));
        if (orders == null) {
            throw new BaseException(500, "小程序订单不存在");
        }
        return orders;
    }

    private void applyChannelFilter(MPJQueryWrapper<Orders> wrapper, String channel) {
        if (CHANNEL_MINIAPP.equals(channel)) {
            wrapper.gt("t.user_id", 0);
        } else if (CHANNEL_CASHIER.equals(channel)) {
            wrapper.eq("t.user_id", 0);
        }
    }

    private void applyCalledFilter(MPJQueryWrapper<Orders> wrapper, Integer called) {
        if (called == null) {
            return;
        }
        if (called == 1) {
            wrapper.gt("t.called_time", 0);
        } else {
            wrapper.eq("t.called_time", 0);
        }
    }

    private String formatTime(Long timestamp) {
        return timestamp != null && timestamp > 0 ? TimeUtils.timestampToDate(timestamp) : "-";
    }

    private String resolvePayType(Orders orders) {
        if (orders == null) {
            return "";
        }
        if (StringUtils.isNotEmpty(orders.getPayType())) {
            return orders.getPayType();
        }
        OrderPay orderPay = orderPayMapper.selectOne(new QueryWrapper<OrderPay>()
                .eq("order_id", orders.getId())
                .eq("pay_status", 1)
                .orderByDesc("id")
                .last("limit 1"));
        return orderPay == null || orderPay.getPayChannel() == null ? "" : orderPay.getPayChannel();
    }
}
