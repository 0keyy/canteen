package com.mdd.admin.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.github.yulichang.query.MPJQueryWrapper;
import com.mdd.admin.LikeAdminThreadLocal;
import com.mdd.admin.service.ICouponRecordService;
import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.validate.coupon.UserCouponRecordSearchValidate;
import com.mdd.admin.vo.coupon.UserCouponRecordListVo;
import com.mdd.common.config.GlobalConfig;
import com.mdd.common.core.PageResult;
import com.mdd.common.entity.coupon.UserCoupon;
import com.mdd.common.mapper.coupon.UserCouponMapper;
import com.mdd.common.util.StringUtils;
import com.mdd.common.util.TimeUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class CouponRecordServiceImpl implements ICouponRecordService {

    @Resource
    UserCouponMapper userCouponMapper;

    @Override
    public PageResult<UserCouponRecordListVo> list(PageValidate pageValidate, UserCouponRecordSearchValidate searchValidate) {
        Integer pageNo = pageValidate.getPageNo();
        Integer pageSize = pageValidate.getPageSize();
        Integer aid = LikeAdminThreadLocal.getAdminId();

        MPJQueryWrapper<UserCoupon> wrapper = new MPJQueryWrapper<UserCoupon>()
                .selectAll(UserCoupon.class)
                .select("ct.name as templateName")
                .select("ct.type as type")
                .select("ct.discount_amount as discountAmount")
                .select("ct.min_amount as minAmount")
                .select("u.nickname as userNickname")
                .select("u.mobile as userMobile")
                .select("u.real_name as userRealName")
                .select("uc.user_name as userCompanyName")
                .select("o.number as orderNumber")
                .select("sa.nickname as verifyAdminName")
                .innerJoin("?_coupon_template ct ON ct.id=t.template_id".replace("?_", GlobalConfig.tablePrefix))
                .innerJoin("?_user u ON u.id=t.user_id".replace("?_", GlobalConfig.tablePrefix))
                .leftJoin("?_user_company uc ON uc.user_id=t.user_id".replace("?_", GlobalConfig.tablePrefix))
                .leftJoin("?_orders o ON o.id=t.order_id".replace("?_", GlobalConfig.tablePrefix))
                .leftJoin("?_system_auth_admin sa ON sa.id=t.verify_admin_id".replace("?_", GlobalConfig.tablePrefix))
                .eq("t.is_delete", 0)
                .eq("ct.aid", aid)
                .orderByDesc("t.id");

        // 动态筛选
        userCouponMapper.setSearch(wrapper, searchValidate, new String[]{
                "=:status@t.status:int",
                "=:type@ct.type:int",
                "between:claimTime@t.claim_time:long",
        });

        // 组合搜索：认证员工姓名 / 用户昵称 / 手机号 / 券名称
        if (StringUtils.isNotEmpty(searchValidate.getUserInfo())) {
            String keyword = searchValidate.getUserInfo();
            wrapper.and(w -> w
                    .like("uc.user_name", keyword)
                    .or()
                    .like("u.nickname", keyword)
                    .or()
                    .like("u.mobile", keyword)
                    .or()
                    .like("ct.name", keyword));
        }

        IPage<UserCouponRecordListVo> iPage = userCouponMapper.selectJoinPage(
                new Page<>(pageNo, pageSize),
                UserCouponRecordListVo.class,
                wrapper);

        // 格式化时间戳
        for (UserCouponRecordListVo vo : iPage.getRecords()) {
            vo.setClaimTimeFormatted(formatTime(vo.getClaimTime()));
            vo.setUseTimeFormatted(formatTime(vo.getUseTime()));
            vo.setVerifyTimeFormatted(formatTime(vo.getVerifyTime()));
        }

        return PageResult.iPageHandle(iPage);
    }

    /**
     * 时间戳转日期字符串，0或null显示"-"
     */
    private String formatTime(Long time) {
        if (time == null || time == 0) {
            return "-";
        }
        return TimeUtils.timestampToDate(time);
    }
}
