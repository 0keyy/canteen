package com.mdd.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.Assert;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.github.yulichang.query.MPJQueryWrapper;
import com.mdd.admin.LikeAdminThreadLocal;
import com.mdd.admin.service.ISystemAuthDeptService;
import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.validate.system.SystemDeptCreateValidate;
import com.mdd.admin.validate.system.SystemDeptSearchValidate;
import com.mdd.admin.validate.system.SystemDeptUpdateValidate;
import com.mdd.admin.vo.system.SystemAuthDeptVo;
import com.mdd.common.config.GlobalConfig;
import com.mdd.common.core.PageResult;
import com.mdd.common.entity.system.SystemAuthDept;
import com.mdd.common.mapper.system.SystemAuthDeptMapper;
import com.mdd.common.util.QRCodeUtil;
import com.mdd.common.util.TimeUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.IOException;
import java.util.*;

/**
 * 桌号管理服务实现类
 */
@Service
class SystemAuthDeptServiceImpl implements ISystemAuthDeptService {

    @Resource
    SystemAuthDeptMapper systemAuthDeptMapper;


    /**
     * 所有桌号
     *
     * @author fzr
     * @return List<SystemAuthDeptVo>
     */
    @Override
    public List<SystemAuthDeptVo> all() {
        List<SystemAuthDept> systemAuthDeptList = systemAuthDeptMapper.selectList(new QueryWrapper<SystemAuthDept>()
                .eq("aid", LikeAdminThreadLocal.getAdminId())
                .eq("is_delete", 0)
                .orderByDesc((Arrays.asList("sort", "id"))));

        List<SystemAuthDeptVo> list = new ArrayList<>();
        for (SystemAuthDept systemAuthDept : systemAuthDeptList) {
            SystemAuthDeptVo vo = new SystemAuthDeptVo();
            BeanUtils.copyProperties(systemAuthDept, vo);

            vo.setUpdateTime(TimeUtils.timestampToDate(systemAuthDept.getUpdateTime()));
            vo.setCreateTime(TimeUtils.timestampToDate(systemAuthDept.getCreateTime()));
            list.add(vo);
        }

        return list;
    }

    /**
     * 部门列表
     *
     * @param searchValidate 搜索参数
     * @return JSONArray
     * @author fzr
     */
    @Override
    public PageResult<SystemAuthDeptVo> list(PageValidate pageValidate, SystemDeptSearchValidate searchValidate) {
        Integer pageNo   = pageValidate.getPageNo();
        Integer pageSize = pageValidate.getPageSize();
        Integer aid = LikeAdminThreadLocal.getAdminId();

        MPJQueryWrapper<SystemAuthDept> mpjQueryWrapper = new MPJQueryWrapper<SystemAuthDept>()
                .selectAll(SystemAuthDept.class)
                .select("post.name as area")
                .innerJoin("?_system_auth_post post ON post.id=t.area_id".replace("?_", GlobalConfig.tablePrefix))
                .eq("t.is_delete",0)
                .eq("t.aid",aid)
                .orderByDesc(Arrays.asList("t.sort","t.id"));

//        QueryWrapper<SystemAuthDept> queryWrapper = new QueryWrapper<>();
//        queryWrapper.eq("is_delete", 0).eq("aid",LikeAdminThreadLocal.getAdminId());
//        queryWrapper.orderByDesc(Arrays.asList("sort", "id"));
//        queryWrapper.select(SystemAuthDept.class, info ->
//                !info.getColumn().equals("is_delete") &&
//                !info.getColumn().equals("delete_time"));

        systemAuthDeptMapper.setSearch(mpjQueryWrapper, searchValidate, new String[]{
                "like:t.name:str",
                "=:areaId@area_id:int",
                "=:isStop@is_stop:int"
        });

        IPage<SystemAuthDeptVo> iPage = systemAuthDeptMapper.selectJoinPage(
                new Page<>(pageNo, pageSize),
                SystemAuthDeptVo.class,
                mpjQueryWrapper
        );

        for (SystemAuthDeptVo vo : iPage.getRecords()){
            vo.setCreateTime(TimeUtils.timestampToDate(vo.getCreateTime()));
            vo.setUpdateTime(TimeUtils.timestampToDate(vo.getUpdateTime()));
        }

//        List<SystemAuthDept> systemAuthDeptList = systemAuthDeptMapper.selectList(mpjQueryWrapper);
//
//        List<SystemAuthDeptVo> list = new LinkedList<>();
//        for (SystemAuthDept systemAuthDept : systemAuthDeptList) {
//            SystemAuthDeptVo vo = new SystemAuthDeptVo();
//            BeanUtils.copyProperties(systemAuthDept, vo);
//
//            vo.setCreateTime(TimeUtils.timestampToDate(systemAuthDept.getCreateTime()));
//            vo.setUpdateTime(TimeUtils.timestampToDate(systemAuthDept.getUpdateTime()));
//            list.add(vo);
//        }

        return PageResult.iPageHandle(iPage);
    }

    /**
     * 部门详情
     *
     * @author fzr
     * @param id 主键
     * @return SystemDeptVo
     */
    @Override
    public SystemAuthDeptVo detail(Integer id) {
        SystemAuthDept systemAuthDept = systemAuthDeptMapper.selectOne(
                new QueryWrapper<SystemAuthDept>()
                        .select(SystemAuthDept.class, info ->
                                !info.getColumn().equals("is_delete") &&
                                        !info.getColumn().equals("delete_time"))
                        .eq("id", id)
                        .eq("is_delete", 0)
                        .last("limit 1"));

        Assert.notNull(systemAuthDept, "不存在!");

        SystemAuthDeptVo vo  = new SystemAuthDeptVo();
        BeanUtils.copyProperties(systemAuthDept, vo);
        vo.setCreateTime(TimeUtils.timestampToDate(systemAuthDept.getCreateTime()));
        vo.setUpdateTime(TimeUtils.timestampToDate(systemAuthDept.getUpdateTime()));

        return vo;
    }

    /**
     * 部门新增
     *
     * @author fzr
     * @param createValidate 参数
     */
    @Override
    public void add(SystemDeptCreateValidate createValidate) {
        SystemAuthDept model = new SystemAuthDept();
        model.setAid(LikeAdminThreadLocal.getAdminId());
        model.setAreaId(createValidate.getAreaId());
        model.setName(createValidate.getName());
        model.setNum(createValidate.getNum());
        model.setSort(createValidate.getSort());
        model.setIsStop(createValidate.getIsStop());
        model.setCreateTime(System.currentTimeMillis() / 1000);
        model.setUpdateTime(System.currentTimeMillis() / 1000);
        systemAuthDeptMapper.insert(model);
    }

    /**
     * 部门编辑
     *
     * @author fzr
     * @param updateValidate 参数
     */
    @Override
    public void edit(SystemDeptUpdateValidate updateValidate) {
        SystemAuthDept model = systemAuthDeptMapper.selectOne(
                new QueryWrapper<SystemAuthDept>()
                        .select(SystemAuthDept.class, info ->
                           !info.getColumn().equals("is_delete") &&
                           !info.getColumn().equals("delete_time"))
                        .eq("id", updateValidate.getId())
                        .eq("is_delete", 0)
                        .last("limit 1"));

        Assert.notNull(model, "部门不存在");

        model.setName(updateValidate.getName());
        model.setNum(updateValidate.getNum());
        model.setSort(updateValidate.getSort());
        model.setIsStop(updateValidate.getIsStop());
        model.setUpdateTime(System.currentTimeMillis() / 1000);
        systemAuthDeptMapper.updateById(model);
    }

    /**
     * 部门删除
     *
     * @author fzr
     * @param id 主键
     */
    @Override
    public void del(Integer id) {
        SystemAuthDept model = systemAuthDeptMapper.selectOne(
                new QueryWrapper<SystemAuthDept>()
                        .select("id,area_id,name")
                        .eq("id", id)
                        .eq("is_delete", 0)
                        .last("limit 1"));

        Assert.notNull(model, "部门不存在");

        model.setIsDelete(1);
        model.setDeleteTime(System.currentTimeMillis() / 1000);
        systemAuthDeptMapper.updateById(model);
    }

    @Override
    public String createQR(Integer id) {
        Integer aid = LikeAdminThreadLocal.getAdminId();
        String imgUrl = "";
        try {
            imgUrl = QRCodeUtil.createQRCode("http://localhost:8080?id=" + aid + "&did=" + id, 200, 200);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return imgUrl;
    }

}