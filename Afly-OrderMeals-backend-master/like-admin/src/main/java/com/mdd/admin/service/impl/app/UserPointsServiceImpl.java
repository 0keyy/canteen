package com.mdd.admin.service.impl.app;

import com.baomidou.dynamic.datasource.annotation.DS;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.mdd.common.config.DataSourceConstant;
import com.mdd.common.entity.ruoyi.RuoyiSysRole;
import com.mdd.common.entity.user.UserCompany;
import com.mdd.common.entity.user.UserPoints;
import com.mdd.common.entity.user.UserPointsLog;
import com.mdd.common.mapper.user.UserCompanyMapper;
import com.mdd.common.mapper.user.UserPointsLogMapper;
import com.mdd.common.mapper.user.UserPointsMapper;
import com.mdd.common.exception.BaseException;
import com.mdd.common.util.PointsPayUtils;
import com.mdd.common.util.RolePointsUtils;
import com.mdd.common.util.TimeUtils;
import com.mdd.admin.service.app.IUserPointsService;
import com.mdd.admin.service.ruoyi.RuoyiSysService;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
@DS(DataSourceConstant.MASTER)
public class UserPointsServiceImpl implements IUserPointsService {

    private static final DateTimeFormatter MONTH_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM");

    @Resource
    private UserPointsMapper userPointsMapper;
    @Resource
    private UserPointsLogMapper userPointsLogMapper;
    @Resource
    private UserCompanyMapper userCompanyMapper;
    @Resource
    private RuoyiSysService ruoyiSysService;

    @Override
    public Integer getBalance(Integer userId) {
        if (userId == null || userId <= 0) {
            return 0;
        }
        UserPoints account = userPointsMapper.selectOne(new QueryWrapper<UserPoints>()
                .eq("user_id", userId)
                .last("limit 1"));
        return account == null ? 0 : account.getPoints();
    }

    @Override
    public int grantMonthlyPoints(Integer userId, Long ruoyiUserId, int source) {
        if (userId == null || userId <= 0 || ruoyiUserId == null || ruoyiUserId <= 0) {
            return 0;
        }

        String grantMonth = YearMonth.now().format(MONTH_FORMAT);
        if (hasGranted(userId, grantMonth)) {
            return 0;
        }

        List<RuoyiSysRole> roles = ruoyiSysService.selectRolesByUserId(ruoyiUserId);
        int amount = RolePointsUtils.calcMonthlyPoints(roles);
        RuoyiSysRole highestRole = RolePointsUtils.getHighestRole(roles);
        return creditPoints(userId, amount, source, grantMonth, 0,
                highestRole == null ? null : highestRole.getRoleId(),
                highestRole == null ? "" : highestRole.getRoleName());
    }

    @Override
    public int grantManualPoints(Integer userId, Long ruoyiUserId, Integer customAmount) {
        if (userId == null || userId <= 0) {
            throw new BaseException(500, "用户ID无效");
        }
        if (ruoyiUserId == null || ruoyiUserId <= 0) {
            throw new BaseException(500, "用户未完成公司认证");
        }

        List<RuoyiSysRole> roles = ruoyiSysService.selectRolesByUserId(ruoyiUserId);
        RuoyiSysRole highestRole = RolePointsUtils.getHighestRole(roles);
        int amount = customAmount != null ? customAmount : RolePointsUtils.calcMonthlyPoints(roles);
        if (amount <= 0) {
            throw new BaseException(500, "未匹配到可发放积分");
        }
        // grant_month 列为 varchar(7)，仅存 yyyy-MM；手工发放用秒级时间戳作为 order_id 保证唯一
        String grantMonth = YearMonth.now().format(MONTH_FORMAT);
        int manualOrderId = (int) (System.currentTimeMillis() / 1000);
        return creditPoints(userId, amount, UserPointsLog.SOURCE_MANUAL, grantMonth, manualOrderId,
                highestRole == null ? null : highestRole.getRoleId(),
                highestRole == null ? "" : highestRole.getRoleName());
    }

    private int creditPoints(Integer userId, int amount, int source, String grantMonth, Integer orderId,
                             Long ruoyiRoleId, String ruoyiRoleName) {
        if (amount <= 0) {
            return 0;
        }
        long now = TimeUtils.timestamp();

        UserPointsLog log = new UserPointsLog();
        log.setUserId(userId);
        log.setChangeAmount(amount);
        log.setGrantMonth(grantMonth == null ? "" : grantMonth);
        log.setOrderId(orderId == null ? 0 : orderId);
        if (ruoyiRoleId != null) {
            log.setRuoyiRoleId(ruoyiRoleId);
        }
        log.setRuoyiRoleName(ruoyiRoleName == null ? "" : ruoyiRoleName);
        log.setSource(source);
        log.setCreateTime(now);

        try {
            userPointsLogMapper.insert(log);
        } catch (DuplicateKeyException e) {
            return 0;
        }

        UserPoints account = userPointsMapper.selectOne(new QueryWrapper<UserPoints>()
                .eq("user_id", userId)
                .last("limit 1"));

        int balanceAfter;
        if (account == null) {
            account = new UserPoints();
            account.setUserId(userId);
            account.setPoints(amount);
            account.setCreateTime(now);
            account.setUpdateTime(now);
            userPointsMapper.insert(account);
            balanceAfter = amount;
        } else {
            balanceAfter = account.getPoints() + amount;
            account.setPoints(balanceAfter);
            account.setUpdateTime(now);
            userPointsMapper.updateById(account);
        }

        log.setBalanceAfter(balanceAfter);
        userPointsLogMapper.updateById(log);
        return amount;
    }

    @Override
    public void grantMonthlyForAllVerifiedUsers() {
        List<UserCompany> companies = userCompanyMapper.selectList(new QueryWrapper<UserCompany>()
                .gt("ruoyi_user_id", 0));
        for (UserCompany company : companies) {
            grantMonthlyPoints(company.getUserId(), company.getRuoyiUserId(), UserPointsLog.SOURCE_MONTHLY);
        }
    }

    @Override
    @Transactional
    public void deductForOrder(Integer userId, Integer orderId, String outTradeNo, BigDecimal payAmount) {
        if (userId == null || userId <= 0) {
            throw new BaseException(500, "用户未登录");
        }
        if (orderId == null || orderId <= 0) {
            throw new BaseException(500, "订单ID无效");
        }
        if (hasDeductedForOrder(userId, orderId)) {
            return;
        }
        int required = PointsPayUtils.toPoints(payAmount);
        if (required <= 0) {
            throw new BaseException(500, "支付金额无效");
        }

        UserPoints account = userPointsMapper.selectOne(new QueryWrapper<UserPoints>()
                .eq("user_id", userId)
                .last("limit 1"));
        if (account == null || account.getPoints() < required) {
            throw new BaseException(500, "余额不足");
        }

        long now = TimeUtils.timestamp();
        int balanceAfter = account.getPoints() - required;
        account.setPoints(balanceAfter);
        account.setUpdateTime(now);
        userPointsMapper.updateById(account);

        UserPointsLog log = new UserPointsLog();
        log.setUserId(userId);
        log.setChangeAmount(-required);
        log.setBalanceAfter(balanceAfter);
        log.setGrantMonth("");
        log.setOrderId(orderId);
        log.setSource(UserPointsLog.SOURCE_ORDER_PAY);
        log.setCreateTime(now);
        userPointsLogMapper.insert(log);
    }

    private boolean hasDeductedForOrder(Integer userId, Integer orderId) {
        return userPointsLogMapper.selectCount(new QueryWrapper<UserPointsLog>()
                .eq("user_id", userId)
                .eq("order_id", orderId)
                .eq("source", UserPointsLog.SOURCE_ORDER_PAY)) > 0;
    }

    private boolean hasGranted(Integer userId, String grantMonth) {
        return userPointsLogMapper.selectCount(new QueryWrapper<UserPointsLog>()
                .eq("user_id", userId)
                .eq("grant_month", grantMonth)
                .eq("order_id", 0)) > 0;
    }
}
