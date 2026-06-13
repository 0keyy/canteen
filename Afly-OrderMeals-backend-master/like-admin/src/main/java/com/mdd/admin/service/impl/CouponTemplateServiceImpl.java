package com.mdd.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mdd.admin.LikeAdminThreadLocal;
import com.mdd.admin.service.ICouponTemplateService;
import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.validate.coupon.CouponTemplateCreateValidate;
import com.mdd.admin.validate.coupon.CouponTemplateSearchValidate;
import com.mdd.admin.validate.coupon.CouponTemplateUpdateValidate;
import com.mdd.admin.vo.coupon.CouponTemplateDetailVo;
import com.mdd.admin.vo.coupon.CouponTemplateListVo;
import com.mdd.common.core.PageResult;
import com.mdd.common.entity.coupon.CouponTemplate;
import com.mdd.common.mapper.coupon.CouponTemplateMapper;
import com.mdd.common.mapper.coupon.UserCouponMapper;
import com.mdd.common.util.TimeUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
public class CouponTemplateServiceImpl implements ICouponTemplateService {

    @Resource
    CouponTemplateMapper couponTemplateMapper;

    @Resource
    UserCouponMapper userCouponMapper;

    @Override
    public PageResult<CouponTemplateListVo> list(PageValidate pageValidate, CouponTemplateSearchValidate searchValidate) {
        Integer pageNo = pageValidate.getPageNo();
        Integer pageSize = pageValidate.getPageSize();
        Integer aid = LikeAdminThreadLocal.getAdminId();

        QueryWrapper<CouponTemplate> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("is_delete", 0)
                .eq("aid", aid)
                .orderByDesc(Arrays.asList("sort", "id"));

        couponTemplateMapper.setSearch(queryWrapper, searchValidate, new String[]{
                "like:name:str",
                "=:type:int",
                "=:isShow@is_show:int"
        });

        IPage<CouponTemplate> iPage = couponTemplateMapper.selectPage(new Page<>(pageNo, pageSize), queryWrapper);

        List<CouponTemplateListVo> list = new ArrayList<>();
        for (CouponTemplate template : iPage.getRecords()) {
            CouponTemplateListVo vo = new CouponTemplateListVo();
            BeanUtils.copyProperties(template, vo);
            vo.setCreateTime(TimeUtils.timestampToDate(template.getCreateTime()));
            vo.setUpdateTime(TimeUtils.timestampToDate(template.getUpdateTime()));
            vo.setUseStartTime(template.getUseStartTime() != null && template.getUseStartTime() > 0
                    ? TimeUtils.timestampToDate(template.getUseStartTime()) : "");
            vo.setUseEndTime(template.getUseEndTime() != null && template.getUseEndTime() > 0
                    ? TimeUtils.timestampToDate(template.getUseEndTime()) : "");
            vo.setClaimStartTime(template.getClaimStartTime() != null && template.getClaimStartTime() > 0
                    ? TimeUtils.timestampToDate(template.getClaimStartTime()) : "");
            vo.setClaimEndTime(template.getClaimEndTime() != null && template.getClaimEndTime() > 0
                    ? TimeUtils.timestampToDate(template.getClaimEndTime()) : "");
            list.add(vo);
        }

        return PageResult.iPageHandle(iPage.getTotal(), iPage.getCurrent(), iPage.getSize(), list);
    }

    @Override
    public CouponTemplateDetailVo detail(Integer id) {
        CouponTemplate model = couponTemplateMapper.selectOne(
                new QueryWrapper<CouponTemplate>()
                        .select(CouponTemplate.class, info ->
                                !info.getColumn().equals("is_delete") &&
                                        !info.getColumn().equals("delete_time"))
                        .eq("id", id)
                        .eq("is_delete", 0));

        Assert.notNull(model, "券模板不存在");

        CouponTemplateDetailVo vo = new CouponTemplateDetailVo();
        BeanUtils.copyProperties(model, vo);
        vo.setCreateTime(TimeUtils.timestampToDate(model.getCreateTime()));
        vo.setUpdateTime(TimeUtils.timestampToDate(model.getUpdateTime()));

        return vo;
    }

    @Override
    public void add(CouponTemplateCreateValidate createValidate) {
        CouponTemplate model = new CouponTemplate();
        model.setAid(LikeAdminThreadLocal.getAdminId());
        model.setName(createValidate.getName());
        model.setType(createValidate.getType());
        model.setDiscountAmount(createValidate.getDiscountAmount());
        model.setMinAmount(createValidate.getMinAmount() != null ? createValidate.getMinAmount() : java.math.BigDecimal.ZERO);
        model.setNightStartTime(createValidate.getNightStartTime() != null ? createValidate.getNightStartTime() : "");
        model.setNightEndTime(createValidate.getNightEndTime() != null ? createValidate.getNightEndTime() : "");
        model.setValidDays(createValidate.getValidDays() != null ? createValidate.getValidDays() : 0);
        model.setUseStartTime(createValidate.getUseStartTime() != null ? createValidate.getUseStartTime() : 0L);
        model.setUseEndTime(createValidate.getUseEndTime() != null ? createValidate.getUseEndTime() : 0L);
        model.setClaimStartTime(createValidate.getClaimStartTime() != null ? createValidate.getClaimStartTime() : 0L);
        model.setClaimEndTime(createValidate.getClaimEndTime() != null ? createValidate.getClaimEndTime() : 0L);
        model.setTotalStock(createValidate.getTotalStock() != null ? createValidate.getTotalStock() : 0);
        model.setSort(createValidate.getSort() != null ? createValidate.getSort() : 0);
        model.setIsShow(createValidate.getIsShow());
        model.setCreateTime(TimeUtils.timestamp());
        model.setUpdateTime(TimeUtils.timestamp());
        couponTemplateMapper.insert(model);
    }

    @Override
    public void edit(CouponTemplateUpdateValidate updateValidate) {
        CouponTemplate model = couponTemplateMapper.selectOne(
                new QueryWrapper<CouponTemplate>()
                        .select(CouponTemplate.class, info ->
                                !info.getColumn().equals("is_delete") &&
                                        !info.getColumn().equals("delete_time"))
                        .eq("id", updateValidate.getId())
                        .eq("is_delete", 0));

        Assert.notNull(model, "券模板不存在");

        model.setName(updateValidate.getName());
        model.setType(updateValidate.getType());
        model.setDiscountAmount(updateValidate.getDiscountAmount());
        model.setMinAmount(updateValidate.getMinAmount() != null ? updateValidate.getMinAmount() : java.math.BigDecimal.ZERO);
        model.setNightStartTime(updateValidate.getNightStartTime() != null ? updateValidate.getNightStartTime() : "");
        model.setNightEndTime(updateValidate.getNightEndTime() != null ? updateValidate.getNightEndTime() : "");
        model.setValidDays(updateValidate.getValidDays() != null ? updateValidate.getValidDays() : 0);
        model.setUseStartTime(updateValidate.getUseStartTime() != null ? updateValidate.getUseStartTime() : 0L);
        model.setUseEndTime(updateValidate.getUseEndTime() != null ? updateValidate.getUseEndTime() : 0L);
        model.setClaimStartTime(updateValidate.getClaimStartTime() != null ? updateValidate.getClaimStartTime() : 0L);
        model.setClaimEndTime(updateValidate.getClaimEndTime() != null ? updateValidate.getClaimEndTime() : 0L);
        model.setTotalStock(updateValidate.getTotalStock() != null ? updateValidate.getTotalStock() : 0);
        model.setSort(updateValidate.getSort() != null ? updateValidate.getSort() : 0);
        model.setIsShow(updateValidate.getIsShow());
        model.setUpdateTime(TimeUtils.timestamp());
        couponTemplateMapper.updateById(model);
    }

    @Override
    public void del(Integer id) {
        CouponTemplate model = couponTemplateMapper.selectOne(
                new QueryWrapper<CouponTemplate>()
                        .select("id,is_show")
                        .eq("id", id)
                        .eq("is_delete", 0));

        Assert.notNull(model, "券模板不存在");

        model.setIsDelete(1);
        model.setDeleteTime(TimeUtils.timestamp());
        couponTemplateMapper.updateById(model);
    }

    @Override
    public void change(Integer id) {
        CouponTemplate model = couponTemplateMapper.selectOne(
                new QueryWrapper<CouponTemplate>()
                        .select("id,is_show")
                        .eq("id", id)
                        .eq("is_delete", 0));

        Assert.notNull(model, "券模板不存在");

        model.setIsShow(model.getIsShow() == 0 ? 1 : 0);
        model.setUpdateTime(TimeUtils.timestamp());
        couponTemplateMapper.updateById(model);
    }
}
