package com.mdd.common.mapper.system;

import com.mdd.common.core.basics.IBaseMapper;
import com.mdd.common.entity.system.SystemAuthDept;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

/**
 * 系统岗位Mapper
 */
@Mapper
public interface SystemAuthDeptMapper extends IBaseMapper<SystemAuthDept> {
    @Update("update la_system_auth_dept set status=#{status} where id=#{id}")
    void changeDeskStatus(@Param("id") int id, @Param("status") int status);
}
