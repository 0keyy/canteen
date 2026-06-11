package com.mdd.admin.service.ruoyi;

import com.baomidou.dynamic.datasource.annotation.DS;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.mdd.common.config.DataSourceConstant;
import com.mdd.common.entity.ruoyi.RuoyiSysDept;
import com.mdd.common.entity.ruoyi.RuoyiSysRole;
import com.mdd.common.entity.ruoyi.RuoyiSysUser;
import com.mdd.common.entity.ruoyi.RuoyiSysUserRole;
import com.mdd.common.mapper.ruoyi.RuoyiSysDeptMapper;
import com.mdd.common.mapper.ruoyi.RuoyiSysRoleMapper;
import com.mdd.common.mapper.ruoyi.RuoyiSysUserMapper;
import com.mdd.common.mapper.ruoyi.RuoyiSysUserRoleMapper;
import com.mdd.admin.vo.app.company.CompanyDeptVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
@DS(DataSourceConstant.RUOYI)
public class RuoyiSysService {

    @Resource
    private RuoyiSysDeptMapper ruoyiSysDeptMapper;
    @Resource
    private RuoyiSysUserMapper ruoyiSysUserMapper;
    @Resource
    private RuoyiSysUserRoleMapper ruoyiSysUserRoleMapper;
    @Resource
    private RuoyiSysRoleMapper ruoyiSysRoleMapper;

    public List<CompanyDeptVo> selectDeptList() {
        List<RuoyiSysDept> depts = ruoyiSysDeptMapper.selectList(new QueryWrapper<RuoyiSysDept>()
                .eq("status", "0")
                .eq("del_flag", "0")
                .orderByAsc("parent_id", "order_num"));
        List<CompanyDeptVo> list = new ArrayList<>();
        for (RuoyiSysDept dept : depts) {
            CompanyDeptVo vo = new CompanyDeptVo();
            vo.setDeptId(dept.getDeptId());
            vo.setParentId(dept.getParentId());
            vo.setDeptName(dept.getDeptName());
            list.add(vo);
        }
        return list;
    }

    public RuoyiSysDept selectDeptById(Long deptId) {
        return ruoyiSysDeptMapper.selectOne(new QueryWrapper<RuoyiSysDept>()
                .eq("dept_id", deptId)
                .eq("del_flag", "0")
                .last("limit 1"));
    }

    public RuoyiSysUser selectUserByUserNameAndDeptId(String userName, Long deptId) {
        return ruoyiSysUserMapper.selectOne(new QueryWrapper<RuoyiSysUser>()
                .eq("user_name", userName)
                .eq("dept_id", deptId)
                .eq("del_flag", "0")
                .last("limit 1"));
    }

    public List<RuoyiSysRole> selectRolesByUserId(Long userId) {
        if (userId == null || userId <= 0) {
            return Collections.emptyList();
        }
        List<RuoyiSysUserRole> userRoles = ruoyiSysUserRoleMapper.selectList(new QueryWrapper<RuoyiSysUserRole>()
                .eq("user_id", userId));
        if (userRoles.isEmpty()) {
            return Collections.emptyList();
        }
        List<Long> roleIds = userRoles.stream()
                .map(RuoyiSysUserRole::getRoleId)
                .collect(Collectors.toList());
        return ruoyiSysRoleMapper.selectList(new QueryWrapper<RuoyiSysRole>()
                .in("role_id", roleIds)
                .eq("status", "0")
                .eq("del_flag", "0"));
    }
}
