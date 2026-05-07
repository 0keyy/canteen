package com.mdd.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.github.yulichang.query.MPJQueryWrapper;
import com.mdd.admin.LikeAdminThreadLocal;
import com.mdd.admin.service.IOrdersServcice;
import com.mdd.admin.validate.order.OrdersSearchValidate;
import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.vo.orders.OrdersCurrentVo;
import com.mdd.admin.vo.orders.OrdersDishListVo;
import com.mdd.admin.vo.orders.OrdersListVo;
import com.mdd.common.config.GlobalConfig;
import com.mdd.common.core.PageResult;
import com.mdd.common.entity.orders.Orders;
import com.mdd.common.entity.orders.OrdersDish;
import com.mdd.common.mapper.orders.OrdersDishMapper;
import com.mdd.common.mapper.orders.OrdersMapper;
import com.mdd.common.util.TimeUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

@Service
public class OrdersServiceImpl implements IOrdersServcice {
    @Resource
    OrdersMapper ordersMapper;
    @Resource
    OrdersDishMapper ordersDishMapper;


    @Override
    public PageResult<OrdersListVo> list(PageValidate pageValidate, OrdersSearchValidate searchValidate) {
        Integer pageNo   = pageValidate.getPageNo();
        Integer pageSize = pageValidate.getPageSize();
        Integer aid      = LikeAdminThreadLocal.getAdminId();

        MPJQueryWrapper<Orders> mpjQueryWrapper = new MPJQueryWrapper<Orders>()
                .selectAll(Orders.class)
                .select("ad.name as deskName")
                .innerJoin("?_system_auth_dept ad ON ad.id=t.desk_id".replace("?_", GlobalConfig.tablePrefix))
                .eq("t.aid",aid)
                .orderByDesc("t.id");

        ordersMapper.setSearch(mpjQueryWrapper, searchValidate, new String[]{
                "=:type@t.type:int",
                "=:status@t.status:int",
                "between:checkoutTime@t.checkout_time:long",
                "between:createTime@t.create_time:long",
        });

        IPage<OrdersListVo> iPage = ordersMapper.selectJoinPage(
                new Page<>(pageNo, pageSize),
                OrdersListVo.class,
                mpjQueryWrapper);


        List<OrdersListVo> list = new LinkedList<>();
        for(OrdersListVo item : iPage.getRecords()) {
            OrdersListVo vo = new OrdersListVo();
            BeanUtils.copyProperties(item, vo);
            vo.setCreateTime(TimeUtils.timestampToDate(item.getCreateTime()));
            vo.setCheckoutTime(!item.getCheckoutTime().equals("0") ?TimeUtils.timestampToDate(item.getCreateTime()):"-");
            list.add(vo);
        }

        return PageResult.iPageHandle(iPage.getTotal(), iPage.getCurrent(), iPage.getSize(), list);
    }

    @Override
    public List<OrdersDishListVo> dish(Integer id) {
        MPJQueryWrapper<OrdersDish> mpjQueryWrapper = new MPJQueryWrapper<OrdersDish>()
                .selectAll(OrdersDish.class)
                .select("ar.title as name")
                .innerJoin("?_article ar ON t.dish_id=ar.id".replace("?_",GlobalConfig.tablePrefix))
                .eq("t.id",id);
        List<OrdersDishListVo> ordersDishListVos = ordersDishMapper.selectJoinList(OrdersDishListVo.class, mpjQueryWrapper);

        return ordersDishListVos;
    }

    @Override
    public List<OrdersCurrentVo> current() {
        QueryWrapper<Orders> ordersQueryWrapper = new QueryWrapper<Orders>()
                .eq("aid", LikeAdminThreadLocal.getAdminId())
                .ne("status", 2);
        List<Orders> orders = ordersMapper.selectList(ordersQueryWrapper);
        List<OrdersCurrentVo> ordersCurrentVos = new ArrayList<>();
        for (Orders item : orders){
            OrdersCurrentVo ordersCurrentVo = new OrdersCurrentVo();
            BeanUtils.copyProperties(item,ordersCurrentVo);
            ordersCurrentVo.setNumber(item.getId());
            ordersCurrentVos.add(ordersCurrentVo);
        }
        return ordersCurrentVos;
    }


}
