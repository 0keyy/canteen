package com.mdd.common.util;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * 积分/余额与订单金额换算（1 积分 = 1 元，小数金额向上取整）
 */
public final class PointsPayUtils {

    private PointsPayUtils() {
    }

    public static int toPoints(BigDecimal yuan) {
        if (yuan == null || yuan.compareTo(BigDecimal.ZERO) <= 0) {
            return 0;
        }
        return yuan.setScale(0, RoundingMode.CEILING).intValue();
    }

    public static boolean isBalanceEnough(Integer balance, BigDecimal payAmount) {
        int required = toPoints(payAmount);
        return balance != null && balance >= required;
    }
}
