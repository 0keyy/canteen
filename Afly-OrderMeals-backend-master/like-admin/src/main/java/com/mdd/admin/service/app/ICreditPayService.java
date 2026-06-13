package com.mdd.admin.service.app;

import com.mdd.admin.vo.app.pay.CreditPayInfoVo;

import java.math.BigDecimal;

public interface ICreditPayService {

    /**
     * 查询用户挂账支付可用信息
     */
    CreditPayInfoVo getPayInfo(Integer userId, BigDecimal payAmount);

    /**
     * 挂账支付扣减（校验额度并写入挂账明细）
     */
    void deductForOrder(Integer userId, Integer orderId, String outTradeNo, BigDecimal payAmount);

    /**
     * 应用挂账扣减（仅写 like_admin，调用前需先 getPayInfo 校验；不可在含 ruoyi 查询的事务内调用）
     */
    void applyDeduction(Integer userId, Integer orderId, String outTradeNo, BigDecimal payAmount,
                        CreditPayInfoVo creditInfo);

    /**
     * 补写挂账明细（已支付订单兜底，幂等）
     */
    int recordCreditLogIfAbsent(Integer userId, Integer orderId, String outTradeNo,
                                BigDecimal payAmount, Long payTime);

    /**
     * 根据挂账支付单重建月账户与扣减明细快照
     */
    int rebuildFromOrderPays();
}
