package com.mdd.admin.service.app;

import com.mdd.admin.vo.app.pay.PayCreateVo;
import com.mdd.common.entity.orders.OrderPay;
import com.mdd.common.entity.orders.Orders;

/**
 * 第三方聚合支付服务（预留接口，待对接支付平台后实现）
 */
public interface IAggregatePayService {

    /**
     * 创建聚合支付预下单
     */
    PayCreateVo createPrepay(Orders orders, OrderPay orderPay);

    /**
     * 处理聚合支付异步回调
     */
    void handleNotify(String body);
}
