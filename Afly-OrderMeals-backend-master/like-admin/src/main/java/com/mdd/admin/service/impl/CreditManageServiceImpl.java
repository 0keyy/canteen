package com.mdd.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.github.yulichang.query.MPJQueryWrapper;
import com.mdd.admin.service.ICreditManageService;
import com.mdd.admin.service.app.ICreditPayService;
import com.mdd.admin.service.ruoyi.RuoyiSysService;
import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.validate.credit.CreditConfigSaveValidate;
import com.mdd.admin.validate.credit.CreditLogSearchValidate;
import com.mdd.admin.validate.credit.CreditMonthlyStatsSearchValidate;
import com.mdd.admin.vo.credit.CreditConfigDetailVo;
import com.mdd.admin.vo.credit.CreditLogListVo;
import com.mdd.admin.vo.credit.CreditMonthlyStatsVo;
import com.mdd.common.config.GlobalConfig;
import com.mdd.common.core.PageResult;
import com.mdd.common.entity.ruoyi.RuoyiSysRole;
import com.mdd.common.entity.user.CreditConfig;
import com.mdd.common.entity.user.CreditLog;
import com.mdd.common.entity.user.CreditRoleConfig;
import com.mdd.common.entity.user.UserCompany;
import com.mdd.common.entity.user.UserCreditMonthly;
import com.mdd.common.mapper.user.CreditConfigMapper;
import com.mdd.common.mapper.user.CreditLogMapper;
import com.mdd.common.mapper.user.CreditRoleConfigMapper;
import com.mdd.common.mapper.user.UserCompanyMapper;
import com.mdd.common.mapper.user.UserCreditMonthlyMapper;
import com.mdd.common.util.CreditPayUtils;
import com.mdd.common.util.StringUtils;
import com.mdd.common.util.TimeUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

@Service
public class CreditManageServiceImpl implements ICreditManageService {

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
    private RuoyiSysService ruoyiSysService;
    @Resource
    private ICreditPayService creditPayService;

    @Override
    public CreditConfigDetailVo configDetail() {
        CreditConfig config = creditConfigMapper.selectById(1);
        List<RuoyiSysRole> roles = ruoyiSysService.selectAllRoles();
        List<CreditRoleConfig> savedConfigs = creditRoleConfigMapper.selectList(new QueryWrapper<>());
        Map<Long, CreditRoleConfig> configMap = CreditPayUtils.toRoleConfigMap(savedConfigs);

        CreditConfigDetailVo vo = new CreditConfigDetailVo();
        vo.setCreditEnable(config == null || config.getCreditEnable() == null ? 0 : config.getCreditEnable());

        List<CreditConfigDetailVo.RoleConfigVo> roleConfigs = new ArrayList<>();
        for (RuoyiSysRole role : roles) {
            CreditConfigDetailVo.RoleConfigVo item = new CreditConfigDetailVo.RoleConfigVo();
            item.setRoleId(role.getRoleId());
            item.setRoleName(role.getRoleName());
            item.setRoleKey(role.getRoleKey());
            CreditRoleConfig saved = configMap.get(role.getRoleId());
            if (saved != null) {
                item.setMonthlyLimit(saved.getMonthlyLimit());
                item.setIsEnable(saved.getIsEnable());
            } else {
                item.setMonthlyLimit(BigDecimal.ZERO);
                item.setIsEnable(0);
            }
            roleConfigs.add(item);
        }
        vo.setRoleConfigs(roleConfigs);
        return vo;
    }

    @Override
    @Transactional
    public void saveConfig(CreditConfigSaveValidate validate) {
        long now = TimeUtils.timestamp();
        CreditConfig config = creditConfigMapper.selectById(1);
        if (config == null) {
            config = new CreditConfig();
            config.setId(1);
            config.setCreditEnable(validate.getCreditEnable());
            config.setCreateTime(now);
            config.setUpdateTime(now);
            creditConfigMapper.insert(config);
        } else {
            config.setCreditEnable(validate.getCreditEnable());
            config.setUpdateTime(now);
            creditConfigMapper.updateById(config);
        }

        if (validate.getRoleConfigs() == null) {
            return;
        }

        for (CreditConfigSaveValidate.RoleConfigItem item : validate.getRoleConfigs()) {
            if (item.getRoleId() == null) {
                continue;
            }
            CreditRoleConfig existing = creditRoleConfigMapper.selectOne(new QueryWrapper<CreditRoleConfig>()
                    .eq("role_id", item.getRoleId())
                    .last("limit 1"));
            BigDecimal monthlyLimit = item.getMonthlyLimit() == null ? BigDecimal.ZERO : item.getMonthlyLimit();
            int isEnable = item.getIsEnable() == null ? 0 : item.getIsEnable();

            if (existing == null) {
                if (monthlyLimit.compareTo(BigDecimal.ZERO) <= 0 && isEnable == 0) {
                    continue;
                }
                CreditRoleConfig created = new CreditRoleConfig();
                created.setRoleId(item.getRoleId());
                created.setRoleName(item.getRoleName() == null ? "" : item.getRoleName());
                created.setMonthlyLimit(monthlyLimit);
                created.setIsEnable(isEnable);
                created.setCreateTime(now);
                created.setUpdateTime(now);
                creditRoleConfigMapper.insert(created);
            } else {
                existing.setRoleName(item.getRoleName() == null ? existing.getRoleName() : item.getRoleName());
                existing.setMonthlyLimit(monthlyLimit);
                existing.setIsEnable(isEnable);
                existing.setUpdateTime(now);
                creditRoleConfigMapper.updateById(existing);
            }
        }
    }

    @Override
    public PageResult<CreditLogListVo> logList(PageValidate pageValidate, CreditLogSearchValidate searchValidate) {
        MPJQueryWrapper<CreditLog> wrapper = new MPJQueryWrapper<CreditLog>()
                .selectAll(CreditLog.class)
                .select("u.mobile as mobile", "uc.nick_name as nickName", "u.nickname as userNickname",
                        "uc.dept_name as deptName", "o.`number` as orderNumber")
                .leftJoin("?_user u ON u.id=t.user_id AND u.is_delete=0".replace("?_", GlobalConfig.tablePrefix))
                .leftJoin("?_user_company uc ON uc.user_id=t.user_id".replace("?_", GlobalConfig.tablePrefix))
                .leftJoin("?_orders o ON o.id=t.order_id".replace("?_", GlobalConfig.tablePrefix))
                .orderByDesc("t.id");

        applyLogSearch(wrapper, searchValidate);

        IPage<CreditLog> iPage = creditLogMapper.selectJoinPage(
                new Page<>(pageValidate.getPageNo(), pageValidate.getPageSize()),
                CreditLog.class,
                wrapper);

        List<CreditLogListVo> list = new LinkedList<>();
        for (CreditLog item : iPage.getRecords()) {
            CreditLogListVo vo = new CreditLogListVo();
            BeanUtils.copyProperties(item, vo);
            vo.setNickname(resolveDisplayName(item.getNickName(), item.getUserNickname()));
            vo.setCreateTime(item.getCreateTime() != null && item.getCreateTime() > 0
                    ? TimeUtils.timestampToDate(item.getCreateTime()) : "-");
            list.add(vo);
        }
        return PageResult.iPageHandle(iPage.getTotal(), iPage.getCurrent(), iPage.getSize(), list);
    }

    @Override
    public PageResult<CreditMonthlyStatsVo> monthlyStats(PageValidate pageValidate,
                                                         CreditMonthlyStatsSearchValidate searchValidate) {
        String creditMonth = resolveCreditMonth(searchValidate);
        List<UserCompany> companies = loadFilteredCompanies(searchValidate);
        Map<Long, CreditRoleConfig> roleConfigMap = CreditPayUtils.toRoleConfigMap(
                creditRoleConfigMapper.selectList(new QueryWrapper<>()));

        Map<Integer, UserCreditMonthly> accountMap = loadMonthlyAccountMap(creditMonth, companies);

        Map<Integer, CreditMonthlyStatsVo> statsMap = new LinkedHashMap<>();
        for (UserCompany company : companies) {
            CreditMonthlyStatsVo vo = new CreditMonthlyStatsVo();
            vo.setUserId(company.getUserId());
            vo.setNickname(resolveDisplayName(company.getNickName(), company.getUserNickname()));
            vo.setDeptName(company.getDeptName());
            vo.setCreditMonth(creditMonth);
            vo.setOrderCount(0);
            vo.setRuoyiRoleName("-");

            UserCreditMonthly account = accountMap.get(company.getUserId());
            if (account != null) {
                vo.setMonthlyLimit(account.getMonthlyLimit());
                vo.setTotalAmount(account.getUsedAmount());
                vo.setRemainAmount(account.getRemainAmount());
                vo.setRuoyiRoleName(StringUtils.isNotEmpty(account.getRuoyiRoleName())
                        ? account.getRuoyiRoleName() : "-");
            } else {
                List<RuoyiSysRole> roles = ruoyiSysService.selectRolesByUserId(company.getRuoyiUserId());
                CreditRoleConfig bestConfig = CreditPayUtils.resolveBestConfig(roles, roleConfigMap);
                BigDecimal limit = bestConfig == null ? BigDecimal.ZERO : bestConfig.getMonthlyLimit();
                vo.setMonthlyLimit(limit);
                vo.setTotalAmount(BigDecimal.ZERO);
                vo.setRemainAmount(limit);
                if (bestConfig != null) {
                    vo.setRuoyiRoleName(bestConfig.getRoleName());
                }
            }
            statsMap.put(company.getUserId(), vo);
        }

        if (!statsMap.isEmpty()) {
            List<CreditLog> logs = creditLogMapper.selectList(new QueryWrapper<CreditLog>()
                    .eq("credit_month", creditMonth)
                    .in("user_id", statsMap.keySet()));
            for (CreditLog log : logs) {
                CreditMonthlyStatsVo vo = statsMap.get(log.getUserId());
                if (vo != null) {
                    vo.setOrderCount(vo.getOrderCount() + 1);
                }
            }
        }

        List<CreditMonthlyStatsVo> all = new ArrayList<>(statsMap.values());
        if (searchValidate != null && searchValidate.getUserId() != null) {
            all.removeIf(item -> !searchValidate.getUserId().equals(item.getUserId()));
        }

        all.sort(Comparator
                .comparing(CreditMonthlyStatsVo::getTotalAmount, Comparator.nullsFirst(BigDecimal::compareTo)).reversed()
                .thenComparing(CreditMonthlyStatsVo::getUserId, Comparator.nullsLast(Integer::compareTo)));

        long pageNo = pageValidate.getPageNo();
        long pageSize = pageValidate.getPageSize();
        int from = (int) Math.max(0, (pageNo - 1) * pageSize);
        int to = (int) Math.min(all.size(), from + pageSize);
        List<CreditMonthlyStatsVo> pageList = from >= all.size() ? new ArrayList<>() : all.subList(from, to);

        Map<Integer, String> mobileMap = loadMobileMap(pageList);
        for (CreditMonthlyStatsVo item : pageList) {
            item.setMobile(mobileMap.getOrDefault(item.getUserId(), ""));
        }

        return PageResult.iPageHandle((long) all.size(), pageNo, pageSize, pageList);
    }

    @Override
    public int syncCreditLogs() {
        return creditPayService.rebuildFromOrderPays();
    }

    private Map<Integer, UserCreditMonthly> loadMonthlyAccountMap(String creditMonth, List<UserCompany> companies) {
        Map<Integer, UserCreditMonthly> accountMap = new HashMap<>();
        if (companies.isEmpty()) {
            return accountMap;
        }
        List<Integer> userIds = new ArrayList<>();
        for (UserCompany company : companies) {
            userIds.add(company.getUserId());
        }
        List<UserCreditMonthly> accounts = userCreditMonthlyMapper.selectList(new QueryWrapper<UserCreditMonthly>()
                .eq("credit_month", creditMonth)
                .in("user_id", userIds));
        for (UserCreditMonthly account : accounts) {
            accountMap.put(account.getUserId(), account);
        }
        return accountMap;
    }

    private void applyLogSearch(MPJQueryWrapper<CreditLog> wrapper, CreditLogSearchValidate search) {
        if (search == null) {
            return;
        }
        if (StringUtils.isNotEmpty(search.getMobile())) {
            wrapper.like("u.mobile", search.getMobile());
        }
        creditLogMapper.setSearch(wrapper, search, new String[]{
                "=:userId@t.user_id:int",
                "like:creditMonth@t.credit_month:str",
                "between:createTime@t.create_time:long"
        });
    }

    private String resolveCreditMonth(CreditMonthlyStatsSearchValidate search) {
        if (search != null && StringUtils.isNotEmpty(search.getCreditMonth())) {
            return search.getCreditMonth();
        }
        return YearMonth.now().format(MONTH_FORMAT);
    }

    private List<UserCompany> loadFilteredCompanies(CreditMonthlyStatsSearchValidate search) {
        MPJQueryWrapper<UserCompany> wrapper = new MPJQueryWrapper<UserCompany>()
                .selectAll(UserCompany.class)
                .select("u.mobile as mobile", "u.nickname as userNickname")
                .leftJoin("?_user u ON u.id=t.user_id AND u.is_delete=0".replace("?_", GlobalConfig.tablePrefix))
                .gt("t.ruoyi_user_id", 0)
                .orderByDesc("t.auth_time");

        if (search != null) {
            if (search.getUserId() != null) {
                wrapper.eq("t.user_id", search.getUserId());
            }
            if (StringUtils.isNotEmpty(search.getNickName())) {
                wrapper.like("t.nick_name", search.getNickName());
            }
            if (StringUtils.isNotEmpty(search.getDeptName())) {
                wrapper.like("t.dept_name", search.getDeptName());
            }
            if (StringUtils.isNotEmpty(search.getMobile())) {
                wrapper.like("u.mobile", search.getMobile());
            }
        }

        return userCompanyMapper.selectJoinList(UserCompany.class, wrapper);
    }

    private Map<Integer, String> loadMobileMap(List<CreditMonthlyStatsVo> pageList) {
        Map<Integer, String> mobileMap = new HashMap<>();
        if (pageList.isEmpty()) {
            return mobileMap;
        }
        List<Integer> userIds = new ArrayList<>();
        for (CreditMonthlyStatsVo item : pageList) {
            userIds.add(item.getUserId());
        }
        List<UserCompany> companies = userCompanyMapper.selectJoinList(UserCompany.class,
                new MPJQueryWrapper<UserCompany>()
                        .select("t.user_id as userId", "u.mobile as mobile")
                        .leftJoin("?_user u ON u.id=t.user_id AND u.is_delete=0".replace("?_", GlobalConfig.tablePrefix))
                        .in("t.user_id", userIds));
        for (UserCompany company : companies) {
            mobileMap.put(company.getUserId(), company.getMobile());
        }
        return mobileMap;
    }

    private String resolveDisplayName(String nickName, String nickname) {
        if (StringUtils.isNotEmpty(nickName)) {
            return nickName;
        }
        return nickname == null ? "" : nickname;
    }
}
