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

    /** 挂账支付 */
    public static final String CREDIT = "credit";

    private PayChannelConstant() {
    }

    public static boolean isBalance(String channel) {
        return BALANCE.equals(channel);
    }

    public static boolean isCredit(String channel) {
        return CREDIT.equals(channel);
    }

    public static boolean isThirdParty(String channel) {
        return WXPAY.equals(channel) || ALIPAY.equals(channel) || AGGREGATE.equals(channel);
    }

    public static String displayName(String channel) {
        if (channel == null || channel.isEmpty()) {
            return "-";
        }
        if (BALANCE.equals(channel)) {
            return "余额";
        }
        if (CREDIT.equals(channel)) {
            return "挂账";
        }
        if (WXPAY.equals(channel)) {
            return "微信";
        }
        if (ALIPAY.equals(channel)) {
            return "支付宝";
        }
        if (AGGREGATE.equals(channel)) {
            return "在线支付";
        }
        return channel;
    }
}
