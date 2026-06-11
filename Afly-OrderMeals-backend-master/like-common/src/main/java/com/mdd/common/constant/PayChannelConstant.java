package com.mdd.common.constant;

/**
 * 支付渠道常量
 */
public final class PayChannelConstant {

    /** 余额支付（积分账户） */
    public static final String BALANCE = "balance";

    /** 微信支付 */
    public static final String WXPAY = "wxpay";

    /** 支付宝 */
    public static final String ALIPAY = "alipay";

    /** 第三方聚合支付（预留） */
    public static final String AGGREGATE = "aggregate";

    private PayChannelConstant() {
    }

    public static boolean isBalance(String channel) {
        return BALANCE.equals(channel);
    }

    public static boolean isThirdParty(String channel) {
        return WXPAY.equals(channel) || ALIPAY.equals(channel) || AGGREGATE.equals(channel);
    }
}
