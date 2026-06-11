package com.mdd.admin.service.app;

/**
 * 用户积分服务
 */
public interface IUserPointsService {

    /**
     * 获取用户积分余额
     */
    Integer getBalance(Integer userId);

    /**
     * 按若依角色发放当月积分（同一用户同一月份仅发放一次）
     *
     * @return 实际发放积分数，0 表示本月已发放或无角色
     */
    int grantMonthlyPoints(Integer userId, Long ruoyiUserId, int source);

    /**
     * 为所有已认证用户发放当月积分（定时任务）
     */
    void grantMonthlyForAllVerifiedUsers();

    /**
     * 订单余额支付扣减积分
     *
     * @param orderId    订单ID
     * @param outTradeNo 支付流水号
     * @param payAmount  支付金额（元）
     */
    void deductForOrder(Integer userId, Integer orderId, String outTradeNo, java.math.BigDecimal payAmount);

    /**
     * 后台手工发放积分（总监及以上500，其他200）
     *
     * @return 实际发放积分数
     */
    int grantManualPoints(Integer userId, Long ruoyiUserId);
}
