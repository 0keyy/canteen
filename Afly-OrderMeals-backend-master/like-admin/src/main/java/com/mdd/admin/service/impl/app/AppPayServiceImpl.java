package com.mdd.admin.service.impl.app;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.mdd.common.entity.orders.OrderPay;
import com.mdd.common.entity.orders.Orders;
import com.mdd.common.exception.BaseException;
import com.mdd.common.mapper.orders.OrderPayMapper;
import com.mdd.common.mapper.orders.OrdersMapper;
import com.mdd.common.util.TimeUtils;
import com.mdd.admin.service.app.IAppPayService;
import com.mdd.admin.validate.app.pay.PayCreateValidate;
import com.mdd.admin.vo.app.pay.PayCreateVo;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.UUID;

@Service
public class AppPayServiceImpl implements IAppPayService {

    @Resource
    private OrdersMapper ordersMapper;
    @Resource
    private OrderPayMapper orderPayMapper;
    @Resource
    private AppOrderServiceImpl orderService;

    @Override
    @Transactional
    public PayCreateVo create(PayCreateValidate validate, Integer userId) {
        Orders orders = ordersMapper.selectById(validate.getOrderId());
        if (orders == null || !orders.getUserId().equals(userId)) {
            throw new BaseException(500, "订单不存在");
        }
        if (orders.getPayStatus() != null && orders.getPayStatus() == 1) {
            throw new BaseException(500, "订单已支付");
        }

        String outTradeNo = "PAY" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 6);
        String payChannel = validate.getPayChannel() == null ? "wxpay" : validate.getPayChannel();
        String payScene = validate.getPayScene() == null ? "mp" : validate.getPayScene();

        OrderPay orderPay = new OrderPay();
        orderPay.setOrderId(orders.getId());
        orderPay.setOrderNumber(orders.getNumber());
        orderPay.setUserId(userId);
        orderPay.setAid(orders.getAid());
        orderPay.setPayChannel(payChannel);
        orderPay.setPayScene(payScene);
        orderPay.setOutTradeNo(outTradeNo);
        orderPay.setPayAmount(orders.getPayAmount());
        orderPay.setPayStatus(0);
        orderPay.setCreateTime(TimeUtils.timestamp());
        orderPayMapper.insert(orderPay);

        Orders update = new Orders();
        update.setId(orders.getId());
        update.setPayType(payChannel);
        ordersMapper.updateById(update);

        PayCreateVo vo = new PayCreateVo();
        vo.setOrderId(orders.getId());
        vo.setOutTradeNo(outTradeNo);
        vo.setPayAmount(orders.getPayAmount());
        vo.setPayChannel(payChannel);
        vo.setPayScene(payScene);
        vo.setMockPay(true);
        vo.setTimeStamp(String.valueOf(TimeUtils.timestamp()));
        vo.setNonceStr(UUID.randomUUID().toString().replace("-", ""));
        vo.setPackageValue("prepay_id=mock_" + outTradeNo);
        vo.setSignType("RSA");
        vo.setPaySign("mock_sign");
        vo.setTradeNo("mock_trade_" + outTradeNo);
        return vo;
    }

    @Override
    @Transactional
    public void mockSuccess(String outTradeNo) {
        completePay(outTradeNo, "mock_tx_" + outTradeNo, "mock");
    }

    @Override
    @Transactional
    public void wxNotify(String body) {
        completePay(extractOutTradeNo(body), "wx_tx_" + System.currentTimeMillis(), body);
    }

    @Override
    @Transactional
    public void aliNotify(String body) {
        completePay(extractOutTradeNo(body), "ali_tx_" + System.currentTimeMillis(), body);
    }

    @Override
    public Integer status(String outTradeNo, Integer userId) {
        OrderPay orderPay = orderPayMapper.selectOne(new QueryWrapper<OrderPay>()
                .eq("out_trade_no", outTradeNo)
                .eq("user_id", userId));
        return orderPay == null ? -1 : orderPay.getPayStatus();
    }

    private void completePay(String outTradeNo, String transactionId, String notifyData) {
        OrderPay orderPay = orderPayMapper.selectOne(new QueryWrapper<OrderPay>().eq("out_trade_no", outTradeNo));
        if (orderPay == null) {
            throw new BaseException(500, "支付单不存在");
        }
        if (orderPay.getPayStatus() == 1) {
            return;
        }
        long now = TimeUtils.timestamp();
        orderPay.setPayStatus(1);
        orderPay.setTransactionId(transactionId);
        orderPay.setNotifyData(notifyData);
        orderPay.setPayTime(now);
        orderPayMapper.updateById(orderPay);

        Orders orders = ordersMapper.selectById(orderPay.getOrderId());
        orders.setPayType(orderPay.getPayChannel());
        orders.setPayAmount(orderPay.getPayAmount());
        orderService.markPaid(orders);
    }

    private String extractOutTradeNo(String body) {
        if (body == null || !body.contains("outTradeNo")) {
            throw new BaseException(500, "无效支付回调");
        }
        int index = body.indexOf("outTradeNo");
        String sub = body.substring(index);
        int start = sub.indexOf(":") + 1;
        int end = sub.indexOf(",");
        if (end < 0) {
            end = sub.indexOf("}");
        }
        return sub.substring(start, end).replace("\"", "").trim();
    }
}
