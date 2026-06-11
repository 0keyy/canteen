package com.mdd.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.github.yulichang.query.MPJQueryWrapper;
import com.mdd.admin.service.ICompanyManageService;
import com.mdd.admin.service.app.IUserPointsService;
import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.validate.company.UserCompanySearchValidate;
import com.mdd.admin.validate.company.UserPointsLogSearchValidate;
import com.mdd.admin.vo.company.PointsGrantBatchVo;
import com.mdd.admin.vo.company.PointsGrantResultVo;
import com.mdd.admin.vo.company.UserCompanyListVo;
import com.mdd.admin.vo.company.UserPointsLogListVo;
import com.mdd.common.config.GlobalConfig;
import com.mdd.common.core.PageResult;
import com.mdd.common.entity.user.UserCompany;
import com.mdd.common.entity.user.UserPointsLog;
import com.mdd.common.exception.OperateException;
import com.mdd.common.mapper.user.UserCompanyMapper;
import com.mdd.common.mapper.user.UserPointsLogMapper;
import com.mdd.common.util.StringUtils;
import com.mdd.common.util.TimeUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.LinkedList;
import java.util.List;

@Service
public class CompanyManageServiceImpl implements ICompanyManageService {

    @Resource
    private UserCompanyMapper userCompanyMapper;
    @Resource
    private UserPointsLogMapper userPointsLogMapper;
    @Resource
    private IUserPointsService userPointsService;

    @Override
    public PageResult<UserCompanyListVo> authList(PageValidate pageValidate, UserCompanySearchValidate searchValidate) {
        MPJQueryWrapper<UserCompany> wrapper = new MPJQueryWrapper<UserCompany>()
                .selectAll(UserCompany.class)
                .select("u.mobile as mobile", "u.nickname as nickname", "IFNULL(up.points, 0) as balance")
                .leftJoin("?_user u ON u.id=t.user_id AND u.is_delete=0".replace("?_", GlobalConfig.tablePrefix))
                .leftJoin("?_user_points up ON up.user_id=t.user_id".replace("?_", GlobalConfig.tablePrefix))
                .orderByDesc("t.auth_time");

        applyAuthSearch(wrapper, searchValidate);

        IPage<UserCompany> iPage = userCompanyMapper.selectJoinPage(
                new Page<>(pageValidate.getPageNo(), pageValidate.getPageSize()),
                UserCompany.class,
                wrapper);

        List<UserCompanyListVo> list = new LinkedList<>();
        for (UserCompany item : iPage.getRecords()) {
            UserCompanyListVo vo = new UserCompanyListVo();
            BeanUtils.copyProperties(item, vo);
            vo.setBalance(item.getBalance() == null ? 0 : item.getBalance());
            vo.setAuthTime(item.getAuthTime() != null && item.getAuthTime() > 0
                    ? TimeUtils.timestampToDate(item.getAuthTime()) : "-");
            list.add(vo);
        }
        return PageResult.iPageHandle(iPage.getTotal(), iPage.getCurrent(), iPage.getSize(), list);
    }

    @Override
    public PageResult<UserPointsLogListVo> pointsLogList(PageValidate pageValidate, UserPointsLogSearchValidate searchValidate) {
        MPJQueryWrapper<UserPointsLog> wrapper = new MPJQueryWrapper<UserPointsLog>()
                .selectAll(UserPointsLog.class)
                .select("u.mobile as mobile", "u.nickname as nickname")
                .leftJoin("?_user u ON u.id=t.user_id AND u.is_delete=0".replace("?_", GlobalConfig.tablePrefix))
                .orderByDesc("t.id");

        applyPointsLogSearch(wrapper, searchValidate);

        IPage<UserPointsLog> iPage = userPointsLogMapper.selectJoinPage(
                new Page<>(pageValidate.getPageNo(), pageValidate.getPageSize()),
                UserPointsLog.class,
                wrapper);

        List<UserPointsLogListVo> list = new LinkedList<>();
        for (UserPointsLog item : iPage.getRecords()) {
            UserPointsLogListVo vo = new UserPointsLogListVo();
            BeanUtils.copyProperties(item, vo);
            vo.setSourceText(resolveSourceText(item.getSource()));
            vo.setCreateTime(item.getCreateTime() != null && item.getCreateTime() > 0
                    ? TimeUtils.timestampToDate(item.getCreateTime()) : "-");
            list.add(vo);
        }
        return PageResult.iPageHandle(iPage.getTotal(), iPage.getCurrent(), iPage.getSize(), list);
    }

    @Override
    public PointsGrantResultVo grantPoints(Integer userId) {
        UserCompany company = userCompanyMapper.selectOne(new QueryWrapper<UserCompany>()
                .eq("user_id", userId)
                .last("limit 1"));
        if (company == null) {
            throw new OperateException("用户未完成公司认证");
        }
        int amount = userPointsService.grantManualPoints(company.getUserId(), company.getRuoyiUserId());
        if (amount <= 0) {
            throw new OperateException("积分发放失败，请稍后重试");
        }

        PointsGrantResultVo vo = new PointsGrantResultVo();
        vo.setUserId(company.getUserId());
        vo.setNickName(company.getNickName());
        vo.setDeptName(company.getDeptName());
        vo.setAmount(amount);
        vo.setBalanceAfter(userPointsService.getBalance(company.getUserId()));
        return vo;
    }

    @Override
    public PointsGrantBatchVo grantPointsAll() {
        List<UserCompany> companies = userCompanyMapper.selectList(new QueryWrapper<UserCompany>()
                .gt("ruoyi_user_id", 0));
        int successCount = 0;
        int totalAmount = 0;
        for (UserCompany company : companies) {
            try {
                int amount = userPointsService.grantManualPoints(company.getUserId(), company.getRuoyiUserId());
                if (amount > 0) {
                    successCount++;
                    totalAmount += amount;
                }
            } catch (Exception ignored) {
                // 单个用户失败不影响批量发放
            }
        }
        PointsGrantBatchVo vo = new PointsGrantBatchVo();
        vo.setTotalUsers(companies.size());
        vo.setSuccessCount(successCount);
        vo.setTotalAmount(totalAmount);
        return vo;
    }

    private void applyAuthSearch(MPJQueryWrapper<UserCompany> wrapper, UserCompanySearchValidate search) {
        if (search == null) {
            return;
        }
        if (StringUtils.isNotEmpty(search.getDeptName())) {
            wrapper.like("t.dept_name", search.getDeptName());
        }
        if (StringUtils.isNotEmpty(search.getUserName())) {
            wrapper.like("t.user_name", search.getUserName());
        }
        if (StringUtils.isNotEmpty(search.getNickName())) {
            wrapper.like("t.nick_name", search.getNickName());
        }
        if (StringUtils.isNotEmpty(search.getMobile())) {
            wrapper.like("u.mobile", search.getMobile());
        }
        userCompanyMapper.setSearch(wrapper, search, new String[]{
                "between:authTime@t.auth_time:long"
        });
    }

    private void applyPointsLogSearch(MPJQueryWrapper<UserPointsLog> wrapper, UserPointsLogSearchValidate search) {
        if (search == null) {
            return;
        }
        if (StringUtils.isNotEmpty(search.getMobile())) {
            wrapper.like("u.mobile", search.getMobile());
        }
        userPointsLogMapper.setSearch(wrapper, search, new String[]{
                "=:userId@t.user_id:int",
                "=:source@t.source:int",
                "like:grantMonth@t.grant_month:str",
                "between:createTime@t.create_time:long"
        });
    }

    private String resolveSourceText(Integer source) {
        if (source == null) {
            return "-";
        }
        if (source == UserPointsLog.SOURCE_FIRST_AUTH) {
            return "首次认证";
        }
        if (source == UserPointsLog.SOURCE_MONTHLY) {
            return "月度发放";
        }
        if (source == UserPointsLog.SOURCE_ORDER_PAY) {
            return "订单扣减";
        }
        if (source == UserPointsLog.SOURCE_MANUAL) {
            return "手工发放";
        }
        return "未知";
    }
}
