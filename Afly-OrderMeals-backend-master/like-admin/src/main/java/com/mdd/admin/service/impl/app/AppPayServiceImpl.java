package com.mdd.admin.service.impl.app;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.mdd.common.constant.PayChannelConstant;
import com.mdd.common.entity.orders.OrderPay;
import com.mdd.common.entity.orders.Orders;
import com.mdd.common.entity.shop.ShopConfig;
import com.mdd.common.exception.BaseException;
import com.mdd.common.mapper.orders.OrderPayMapper;
import com.mdd.common.mapper.orders.OrdersDishMapper;
import com.mdd.common.mapper.orders.OrdersMapper;
import com.mdd.common.mapper.shop.ShopConfigMapper;
import com.mdd.admin.enums.app.DiningModeEnum;
import com.mdd.common.util.PointsPayUtils;
import com.mdd.common.util.TimeUtils;
import com.mdd.admin.service.app.IAggregatePayService;
import com.mdd.admin.service.app.IAppPayService;
import com.mdd.admin.service.app.ICreditPayService;
import com.mdd.admin.service.app.IUserPointsService;
import com.mdd.admin.vo.app.pay.CreditPayInfoVo;
import com.mdd.admin.validate.app.pay.PayCreateValidate;
import com.mdd.admin.vo.app.pay.PayCreateVo;
import com.mdd.admin.vo.app.pay.PayMethodVo;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class AppPayServiceImpl implements IAppPayService {

    @Resource
    private OrdersMapper ordersMapper;
    @Resource
    private OrdersDishMapper ordersDishMapper;
    @Resource
    private ShopConfigMapper shopConfigMapper;
    @Resource
    private OrderPayMapper orderPayMapper;
    @Resource
    private AppOrderServiceImpl orderService;
    @Resource
    private IUserPointsService userPointsService;
    @Resource
    private ICreditPayService creditPayService;
    @Resource
    private IAggregatePayService aggregatePayService;
    @Resource
    private AppPayServiceImpl self;

    @Override
    public List<PayMethodVo> listMethods(Integer orderId, Integer userId) {
        Orders orders = getPayableOrder(orderId, userId);
        BigDecimal payAmount = resolvePayAmount(orders);
        int requiredBalance = PointsPayUtils.toPoints(payAmount);
        int balance = userPointsService.getBalance(userId);

        List<PayMethodVo> methods = new ArrayList<>();

        PayMethodVo balanceMethod = new PayMethodVo();
        balanceMethod.setChannel(PayChannelConstant.BALANCE);
        balanceMethod.setName("余额支付");
        balanceMethod.setDesc("可用余额 " + balance);
        balanceMethod.setBalance(balance);
        balanceMethod.setRequiredBalance(requiredBalance);
        boolean balanceEnough = PointsPayUtils.isBalanceEnough(balance, payAmount);
        balanceMethod.setEnabled(balanceEnough);
        if (!balanceEnough) {
            balanceMethod.setDisabledReason("余额不足，还需 " + (requiredBalance - balance));
        }
        methods.add(balanceMethod);

        CreditPayInfoVo creditInfo = creditPayService.getPayInfo(userId, payAmount);
        PayMethodVo creditMethod = new PayMethodVo();
        creditMethod.setChannel(PayChannelConstant.CREDIT);
        creditMethod.setName("挂账支付");
        creditMethod.setDesc("本月额度 " + formatAmount(creditInfo.getCreditLimit())
                + "，已用 " + formatAmount(creditInfo.getCreditUsed())
                + "，剩余 " + formatAmount(creditInfo.getCreditRemain()));
        creditMethod.setCreditLimit(creditInfo.getCreditLimit());
        creditMethod.setCreditUsed(creditInfo.getCreditUsed());
        creditMethod.setCreditRemain(creditInfo.getCreditRemain());
        creditMethod.setEnabled(Boolean.TRUE.equals(creditInfo.getEnabled()));
        if (!Boolean.TRUE.equals(creditInfo.getEnabled())) {
            creditMethod.setDisabledReason(creditInfo.getDisabledReason());
        }
        methods.add(creditMethod);

        PayMethodVo aggregateMethod = new PayMethodVo();
        aggregateMethod.setChannel(PayChannelConstant.AGGREGATE);
        aggregateMethod.setName("在线支付");
        aggregateMethod.setDesc("微信/支付宝等（聚合支付）");
        aggregateMethod.setEnabled(false);
        aggregateMethod.setDisabledReason("暂未开通");
        methods.add(aggregateMethod);

        PayMethodVo wxMethod = new PayMethodVo();
        wxMethod.setChannel(PayChannelConstant.WXPAY);
        wxMethod.setName("微信支付");
        wxMethod.setDesc("直连微信支付");
        wxMethod.setEnabled(false);
        wxMethod.setDisabledReason("暂未开通");
        methods.add(wxMethod);

        return methods;
    }

    @Override
    public PayCreateVo create(PayCreateValidate validate, Integer userId) {
        Orders orders = getPayableOrder(validate.getOrderId(), userId);
        String payChannel = validate.getPayChannel() == null ? PayChannelConstant.BALANCE : validate.getPayChannel();
        String payScene = validate.getPayScene() == null ? "mp" : validate.getPayScene();
        BigDecimal payAmount = resolvePayAmount(orders);

        // 挂账需先查 ruoyi 库角色（sys_user_role / sys_role），不可放在 @Transactional 内
        CreditPayInfoVo creditPrepare = null;
        if (PayChannelConstant.CREDIT.equals(payChannel)) {
            creditPrepare = creditPayService.getPayInfo(userId, payAmount);
            if (!Boolean.TRUE.equals(creditPrepare.getEnabled())) {
                String reason = creditPrepare.getDisabledReason();
                throw new BaseException(500, reason == null ? "挂账支付不可用" : reason);
            }
        }

        return self.executeCreateInTransaction(orders, userId, payChannel, payScene, payAmount, creditPrepare);
    }

    @Transactional
    public PayCreateVo executeCreateInTransaction(Orders orders, Integer userId, String payChannel,
                                                String payScene, BigDecimal payAmount,
                                                CreditPayInfoVo creditPrepare) {
        String outTradeNo = "PAY" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 6);
        OrderPay orderPay = buildOrderPay(orders, userId, payChannel, payScene, outTradeNo, payAmount);
        orderPayMapper.insert(orderPay);

        Orders update = new Orders();
        update.setId(orders.getId());
        update.setPayType(payChannel);
        ordersMapper.updateById(update);

        if (PayChannelConstant.BALANCE.equals(payChannel)) {
            return createBalancePay(orders, orderPay, userId);
        }
        if (PayChannelConstant.CREDIT.equals(payChannel)) {
            return createCreditPay(orders, orderPay, userId, creditPrepare);
        }
        if (PayChannelConstant.AGGREGATE.equals(payChannel)) {
            return aggregatePayService.createPrepay(orders, orderPay);
        }
        if (PayChannelConstant.WXPAY.equals(payChannel) || PayChannelConstant.ALIPAY.equals(payChannel)) {
            return createThirdPartyPay(orders, orderPay);
        }
        throw new BaseException(500, "不支持的支付方式");
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

    private PayCreateVo createCreditPay(Orders orders, OrderPay orderPay, Integer userId,
                                        CreditPayInfoVo creditPrepare) {
        if (orderPay.getPayAmount() != null && orderPay.getPayAmount().compareTo(BigDecimal.ZERO) > 0) {
            creditPayService.applyDeduction(userId, orders.getId(), orderPay.getOutTradeNo(),
                    orderPay.getPayAmount(), creditPrepare);
        }
        completePay(orderPay.getOutTradeNo(), "credit_" + orderPay.getOutTradeNo(), "credit");

        PayCreateVo vo = buildBasePayVo(orders, orderPay);
        vo.setCompleted(true);
        vo.setMockPay(false);
        return vo;
    }

    private PayCreateVo createBalancePay(Orders orders, OrderPay orderPay, Integer userId) {
        if (orderPay.getPayAmount() != null && orderPay.getPayAmount().compareTo(BigDecimal.ZERO) > 0) {
            userPointsService.deductForOrder(userId, orders.getId(), orderPay.getOutTradeNo(), orderPay.getPayAmount());
        }
        completePay(orderPay.getOutTradeNo(), "balance_" + orderPay.getOutTradeNo(), "balance");

        PayCreateVo vo = buildBasePayVo(orders, orderPay);
        vo.setCompleted(true);
        vo.setMockPay(false);
        return vo;
    }

    private PayCreateVo createThirdPartyPay(Orders orders, OrderPay orderPay) {
        PayCreateVo vo = buildBasePayVo(orders, orderPay);
        vo.setCompleted(false);
        vo.setMockPay(true);
        vo.setTimeStamp(String.valueOf(TimeUtils.timestamp()));
        vo.setNonceStr(UUID.randomUUID().toString().replace("-", ""));
        vo.setPackageValue("prepay_id=mock_" + orderPay.getOutTradeNo());
        vo.setSignType("RSA");
        vo.setPaySign("mock_sign");
        vo.setTradeNo("mock_trade_" + orderPay.getOutTradeNo());
        return vo;
    }

    private PayCreateVo buildBasePayVo(Orders orders, OrderPay orderPay) {
        PayCreateVo vo = new PayCreateVo();
        vo.setOrderId(orders.getId());
        vo.setOutTradeNo(orderPay.getOutTradeNo());
        vo.setPayAmount(orderPay.getPayAmount());
        vo.setPayChannel(orderPay.getPayChannel());
        vo.setPayScene(orderPay.getPayScene());
        return vo;
    }

    private OrderPay buildOrderPay(Orders orders, Integer userId, String payChannel,
                                   String payScene, String outTradeNo, BigDecimal payAmount) {
        OrderPay orderPay = new OrderPay();
        orderPay.setOrderId(orders.getId());
        orderPay.setOrderNumber(orders.getNumber());
        orderPay.setUserId(userId);
        orderPay.setAid(orders.getAid());
        orderPay.setPayChannel(payChannel);
        orderPay.setPayScene(payScene);
        orderPay.setOutTradeNo(outTradeNo);
        orderPay.setPayAmount(payAmount);
        orderPay.setPayStatus(0);
        orderPay.setCreateTime(TimeUtils.timestamp());
        return orderPay;
    }

    private Orders getPayableOrder(Integer orderId, Integer userId) {
        Orders orders = ordersMapper.selectById(orderId);
        if (orders == null || !orders.getUserId().equals(userId)) {
            throw new BaseException(500, "订单不存在");
        }
        if (orders.getPayStatus() != null && orders.getPayStatus() == 1) {
            throw new BaseException(500, "订单已支付");
        }
        return orders;
    }

    private BigDecimal resolvePayAmount(Orders orders) {
        if (orders.getPayAmount() != null && orders.getPayAmount().compareTo(BigDecimal.ZERO) > 0) {
            return orders.getPayAmount();
        }
        if (orders.getAmount() != null && !orders.getAmount().isEmpty()) {
            return new BigDecimal(orders.getAmount());
        }
        BigDecimal dishAmount = ordersDishMapper.compute(orders.getId());
        if (dishAmount == null || dishAmount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BaseException(500, "订单金额无效");
        }
        BigDecimal deliveryFee = BigDecimal.ZERO;
        if (orders.getDiningMode() != null && orders.getDiningMode() == DiningModeEnum.DELIVERY) {
            ShopConfig shopConfig = shopConfigMapper.selectOne(new QueryWrapper<ShopConfig>().eq("aid", orders.getAid()));
            if (shopConfig != null && shopConfig.getDeliveryFee() != null) {
                deliveryFee = shopConfig.getDeliveryFee();
            }
        }
        return dishAmount.add(deliveryFee);
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

    private String formatAmount(BigDecimal amount) {
        if (amount == null) {
            return "0";
        }
        return amount.stripTrailingZeros().toPlainString();
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
