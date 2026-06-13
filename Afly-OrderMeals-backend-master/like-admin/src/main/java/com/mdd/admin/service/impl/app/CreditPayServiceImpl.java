package com.mdd.admin.service.impl.app;

import com.baomidou.dynamic.datasource.annotation.DS;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.mdd.common.config.DataSourceConstant;
import com.mdd.common.constant.PayChannelConstant;
import com.mdd.common.entity.orders.OrderPay;
import com.mdd.common.entity.ruoyi.RuoyiSysRole;
import com.mdd.common.entity.user.CreditConfig;
import com.mdd.common.entity.user.CreditLog;
import com.mdd.common.entity.user.CreditRoleConfig;
import com.mdd.common.entity.user.UserCompany;
import com.mdd.common.entity.user.UserCreditMonthly;
import com.mdd.common.exception.BaseException;
import com.mdd.common.mapper.orders.OrderPayMapper;
import com.mdd.common.mapper.user.CreditConfigMapper;
import com.mdd.common.mapper.user.CreditLogMapper;
import com.mdd.common.mapper.user.CreditRoleConfigMapper;
import com.mdd.common.mapper.user.UserCompanyMapper;
import com.mdd.common.mapper.user.UserCreditMonthlyMapper;
import com.mdd.common.util.CreditPayUtils;
import com.mdd.common.util.TimeUtils;
import com.mdd.admin.service.app.ICreditPayService;
import com.mdd.admin.service.ruoyi.RuoyiSysService;
import com.mdd.admin.vo.app.pay.CreditPayInfoVo;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.YearMonth;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@DS(DataSourceConstant.MASTER)
public class CreditPayServiceImpl implements ICreditPayService {

    private static final DateTimeFormatter MONTH_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM");

    @Resource
    private CreditConfigMapper creditConfigMapper;
    @Resource
    private CreditRoleConfigMapper creditRoleConfigMapper;
    @Resource
    private CreditLogMapper creditLogMapper;
    @Resource
    private UserCreditMonthlyMapper userCreditMonthlyMapper;
    @Resource
    private UserCompanyMapper userCompanyMapper;
    @Resource
    private OrderPayMapper orderPayMapper;
    @Resource
    private RuoyiSysService ruoyiSysService;

    @Override
    public CreditPayInfoVo getPayInfo(Integer userId, BigDecimal payAmount) {
        CreditPayInfoVo vo = new CreditPayInfoVo();
        vo.setEnabled(false);
        vo.setCreditLimit(BigDecimal.ZERO);
        vo.setCreditUsed(BigDecimal.ZERO);
        vo.setCreditRemain(BigDecimal.ZERO);

        if (!isCreditEnabled()) {
            vo.setDisabledReason("挂账支付未开启");
            return vo;
        }
        if (userId == null || userId <= 0) {
            vo.setDisabledReason("请先登录");
            return vo;
        }

        RoleCreditContext roleContext = resolveRoleCreditContext(userId);
        if (roleContext == null) {
            vo.setDisabledReason("请先完成公司认证");
            return vo;
        }
        if (roleContext.bestConfig == null) {
            vo.setDisabledReason("当前职级未配置挂账额度");
            return vo;
        }

        String creditMonth = YearMonth.now().format(MONTH_FORMAT);
        UserCreditMonthly account = getMonthlyAccount(userId, creditMonth);
        BigDecimal limit = resolveMonthlyLimit(account, roleContext.bestConfig.getMonthlyLimit());
        BigDecimal used = account == null ? BigDecimal.ZERO : safeAmount(account.getUsedAmount());
        BigDecimal remain = limit.subtract(used);
        if (remain.compareTo(BigDecimal.ZERO) < 0) {
            remain = BigDecimal.ZERO;
        }

        vo.setCreditLimit(limit);
        vo.setCreditUsed(used);
        vo.setCreditRemain(remain);
        vo.setRoleId(roleContext.bestConfig.getRoleId());
        vo.setRoleName(roleContext.bestConfig.getRoleName());

        BigDecimal required = payAmount == null ? BigDecimal.ZERO : payAmount;
        if (required.compareTo(BigDecimal.ZERO) > 0 && remain.compareTo(required) < 0) {
            vo.setDisabledReason("本月挂账额度不足，剩余 " + remain.stripTrailingZeros().toPlainString() + " 元");
            return vo;
        }

        vo.setEnabled(true);
        return vo;
    }

    @Override
    public void deductForOrder(Integer userId, Integer orderId, String outTradeNo, BigDecimal payAmount) {
        CreditPayInfoVo info = getPayInfo(userId, payAmount);
        applyDeduction(userId, orderId, outTradeNo, payAmount, info);
    }

    @Override
    public void applyDeduction(Integer userId, Integer orderId, String outTradeNo, BigDecimal payAmount,
                             CreditPayInfoVo creditInfo) {
        if (creditInfo == null || !Boolean.TRUE.equals(creditInfo.getEnabled())) {
            String reason = creditInfo == null ? "挂账支付不可用" : creditInfo.getDisabledReason();
            throw new BaseException(500, reason == null ? "挂账支付不可用" : reason);
        }
        int inserted = applyCreditDeduction(userId, orderId, outTradeNo, payAmount, TimeUtils.timestamp(),
                creditInfo.getRoleId(), creditInfo.getRoleName(), creditInfo.getCreditLimit(), true);
        if (inserted <= 0) {
            throw new BaseException(500, "订单已挂账，请勿重复支付");
        }
    }

    @Override
    public int recordCreditLogIfAbsent(Integer userId, Integer orderId, String outTradeNo,
                                       BigDecimal payAmount, Long payTime) {
        if (userId == null || userId <= 0 || orderId == null || orderId <= 0) {
            return 0;
        }
        CreditLog existing = creditLogMapper.selectOne(new QueryWrapper<CreditLog>()
                .eq("user_id", userId)
                .eq("order_id", orderId)
                .last("limit 1"));
        if (existing != null) {
            return 0;
        }

        RoleCreditContext roleContext = resolveRoleCreditContext(userId);
        if (roleContext == null || roleContext.bestConfig == null) {
            return 0;
        }

        long eventTime = payTime == null || payTime <= 0 ? TimeUtils.timestamp() : payTime;
        return applyCreditDeduction(userId, orderId, outTradeNo, payAmount, eventTime,
                roleContext.bestConfig.getRoleId(), roleContext.bestConfig.getRoleName(),
                roleContext.bestConfig.getMonthlyLimit(), false);
    }

    @Override
    public int rebuildFromOrderPays() {
        List<OrderPay> orderPays = orderPayMapper.selectList(new QueryWrapper<OrderPay>()
                .eq("pay_channel", PayChannelConstant.CREDIT)
                .eq("pay_status", 1)
                .orderByAsc("id"));
        if (orderPays.isEmpty()) {
            return 0;
        }

        creditLogMapper.delete(new QueryWrapper<>());
        userCreditMonthlyMapper.delete(new QueryWrapper<>());

        int synced = 0;
        for (OrderPay orderPay : orderPays) {
            long payTime = orderPay.getPayTime() != null && orderPay.getPayTime() > 0
                    ? orderPay.getPayTime()
                    : (orderPay.getCreateTime() == null ? TimeUtils.timestamp() : orderPay.getCreateTime());
            RoleCreditContext roleContext = resolveRoleCreditContext(orderPay.getUserId());
            if (roleContext == null || roleContext.bestConfig == null) {
                continue;
            }
            synced += applyCreditDeduction(orderPay.getUserId(), orderPay.getOrderId(), orderPay.getOutTradeNo(),
                    orderPay.getPayAmount(), payTime, roleContext.bestConfig.getRoleId(),
                    roleContext.bestConfig.getRoleName(), roleContext.bestConfig.getMonthlyLimit(), false);
        }
        return synced;
    }

    private int applyCreditDeduction(Integer userId, Integer orderId, String outTradeNo, BigDecimal payAmount,
                                     long eventTime, Long roleId, String roleName, BigDecimal configuredLimit,
                                     boolean validateLimit) {
        BigDecimal deductAmount = payAmount == null ? BigDecimal.ZERO : payAmount;
        if (deductAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return 0;
        }

        CreditLog existing = creditLogMapper.selectOne(new QueryWrapper<CreditLog>()
                .eq("user_id", userId)
                .eq("order_id", orderId)
                .last("limit 1"));
        if (existing != null) {
            return 0;
        }

        String creditMonth = formatCreditMonth(eventTime);
        UserCreditMonthly account = getOrCreateMonthlyAccount(userId, creditMonth, roleId, roleName, configuredLimit);
        BigDecimal usedBefore = safeAmount(account.getUsedAmount());
        BigDecimal usedAfter = usedBefore.add(deductAmount);
        if (validateLimit && usedAfter.compareTo(account.getMonthlyLimit()) > 0) {
            throw new BaseException(500, "本月挂账额度不足");
        }

        long now = TimeUtils.timestamp();
        account.setUsedAmount(usedAfter);
        account.setUpdateTime(now);
        userCreditMonthlyMapper.updateById(account);

        BigDecimal remainAfter = account.getMonthlyLimit().subtract(usedAfter);
        if (remainAfter.compareTo(BigDecimal.ZERO) < 0) {
            remainAfter = BigDecimal.ZERO;
        }

        CreditLog log = new CreditLog();
        log.setUserId(userId);
        log.setOrderId(orderId);
        log.setOutTradeNo(outTradeNo == null ? "" : outTradeNo);
        log.setAmount(deductAmount);
        log.setChangeAmount(deductAmount.negate());
        log.setMonthlyLimit(account.getMonthlyLimit());
        log.setUsedAfter(usedAfter);
        log.setRemainAfter(remainAfter);
        log.setCreditMonth(creditMonth);
        log.setRuoyiRoleId(roleId == null ? 0L : roleId);
        log.setRuoyiRoleName(roleName == null ? "" : roleName);
        log.setCreateTime(eventTime);

        try {
            return creditLogMapper.insert(log) > 0 ? 1 : 0;
        } catch (DuplicateKeyException e) {
            return 0;
        }
    }

    private UserCreditMonthly getOrCreateMonthlyAccount(Integer userId, String creditMonth, Long roleId,
                                                        String roleName, BigDecimal configuredLimit) {
        UserCreditMonthly account = getMonthlyAccount(userId, creditMonth);
        long now = TimeUtils.timestamp();
        if (account == null) {
            account = new UserCreditMonthly();
            account.setUserId(userId);
            account.setCreditMonth(creditMonth);
            account.setMonthlyLimit(configuredLimit == null ? BigDecimal.ZERO : configuredLimit);
            account.setUsedAmount(BigDecimal.ZERO);
            account.setRuoyiRoleId(roleId == null ? 0L : roleId);
            account.setRuoyiRoleName(roleName == null ? "" : roleName);
            account.setCreateTime(now);
            account.setUpdateTime(now);
            try {
                userCreditMonthlyMapper.insert(account);
            } catch (DuplicateKeyException e) {
                account = getMonthlyAccount(userId, creditMonth);
                if (account == null) {
                    throw new BaseException(500, "挂账账户创建失败");
                }
            }
        } else {
            refreshMonthlyAccount(account, roleId, roleName, configuredLimit, now);
        }
        return account;
    }

    private void refreshMonthlyAccount(UserCreditMonthly account, Long roleId, String roleName,
                                       BigDecimal configuredLimit, long now) {
        BigDecimal limit = resolveMonthlyLimit(account, configuredLimit);
        account.setMonthlyLimit(limit);
        if (roleId != null && roleId > 0) {
            account.setRuoyiRoleId(roleId);
        }
        if (roleName != null && !roleName.isEmpty()) {
            account.setRuoyiRoleName(roleName);
        }
        account.setUpdateTime(now);
        userCreditMonthlyMapper.updateById(account);
    }

    private UserCreditMonthly getMonthlyAccount(Integer userId, String creditMonth) {
        return userCreditMonthlyMapper.selectOne(new QueryWrapper<UserCreditMonthly>()
                .eq("user_id", userId)
                .eq("credit_month", creditMonth)
                .last("limit 1"));
    }

    private BigDecimal resolveMonthlyLimit(UserCreditMonthly account, BigDecimal configuredLimit) {
        BigDecimal current = account == null || account.getMonthlyLimit() == null
                ? BigDecimal.ZERO : account.getMonthlyLimit();
        BigDecimal configured = configuredLimit == null ? BigDecimal.ZERO : configuredLimit;
        return current.max(configured);
    }

    private RoleCreditContext resolveRoleCreditContext(Integer userId) {
        UserCompany company = userCompanyMapper.selectOne(new QueryWrapper<UserCompany>()
                .eq("user_id", userId)
                .last("limit 1"));
        if (company == null || company.getRuoyiUserId() == null || company.getRuoyiUserId() <= 0) {
            return null;
        }
        List<RuoyiSysRole> roles = ruoyiSysService.selectRolesByUserId(company.getRuoyiUserId());
        List<CreditRoleConfig> roleConfigs = creditRoleConfigMapper.selectList(new QueryWrapper<>());
        CreditRoleConfig bestConfig = CreditPayUtils.resolveBestConfig(roles,
                CreditPayUtils.toRoleConfigMap(roleConfigs));
        RoleCreditContext context = new RoleCreditContext();
        context.bestConfig = bestConfig;
        return context;
    }

    private String formatCreditMonth(long timestamp) {
        return Instant.ofEpochSecond(timestamp)
                .atZone(ZoneId.systemDefault())
                .toLocalDate()
                .format(MONTH_FORMAT);
    }

    private BigDecimal safeAmount(BigDecimal amount) {
        return amount == null ? BigDecimal.ZERO : amount;
    }

    private boolean isCreditEnabled() {
        CreditConfig config = creditConfigMapper.selectById(1);
        return config != null && config.getCreditEnable() != null && config.getCreditEnable() == 1;
    }

    private static class RoleCreditContext {
        private CreditRoleConfig bestConfig;
    }
}
