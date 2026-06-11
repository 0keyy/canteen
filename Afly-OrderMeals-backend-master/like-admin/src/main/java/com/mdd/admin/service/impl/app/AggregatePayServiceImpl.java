package com.mdd.admin.service.impl.app;

import com.mdd.common.entity.orders.OrderPay;
import com.mdd.common.entity.orders.Orders;
import com.mdd.common.exception.BaseException;
import com.mdd.admin.service.app.IAggregatePayService;
import com.mdd.admin.vo.app.pay.PayCreateVo;
import org.springframework.stereotype.Service;

/**
 * 聚合支付占位实现，待对接第三方支付平台后替换
 */
@Service
public class AggregatePayServiceImpl implements IAggregatePayService {

    @Override
    public PayCreateVo createPrepay(Orders orders, OrderPay orderPay) {
        throw new BaseException(500, "聚合支付暂未开通，请使用余额支付");
    }

    @Override
    public void handleNotify(String body) {
        throw new BaseException(500, "聚合支付回调暂未接入");
    }
}
