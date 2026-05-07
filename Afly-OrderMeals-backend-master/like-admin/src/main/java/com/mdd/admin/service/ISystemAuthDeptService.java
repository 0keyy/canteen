package com.mdd.admin.service;

import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.validate.system.SystemDeptCreateValidate;
import com.mdd.admin.validate.system.SystemDeptSearchValidate;
import com.mdd.admin.validate.system.SystemDeptUpdateValidate;
import com.mdd.admin.vo.system.SystemAuthDeptVo;
import com.mdd.common.core.PageResult;

import java.util.List;

/**
 * 系统部门服务接口类
 */
public interface ISystemAuthDeptService {

    /**
     * 部门所有
     *
     * @return List<SystemDeptVo>
     * @author fzr
     */
    List<SystemAuthDeptVo> all();

    /**
     * 部门列表
     *
     * @param searchValidate 搜索参数
     * @return JSONArray
     * @author fzr
     */
    PageResult<SystemAuthDeptVo> list(PageValidate pageValidate, SystemDeptSearchValidate searchValidate);

    /**
     * 部门详情
     *
     * @param id 主键
     * @return SysMenu
     * @author fzr
     */
    SystemAuthDeptVo detail(Integer id);

    /**
     * 部门新增
     *
     * @param createValidate 参数
     * @author fzr
     */
    void add(SystemDeptCreateValidate createValidate);

    /**
     * 部门编辑
     *
     * @param updateValidate 参数
     * @author fzr
     */
    void edit(SystemDeptUpdateValidate updateValidate);

    /**
     * 部门删除
     *
     * @param id 主键
     * @author fzr
     */
    void del(Integer id);

    /**
     * 生成二维码
     */
    String createQR(Integer id);

}
