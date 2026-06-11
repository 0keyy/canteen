package com.mdd.admin.service.app;

import com.mdd.admin.validate.app.company.CompanyAuthValidate;
import com.mdd.admin.vo.app.company.CompanyAuthVo;
import com.mdd.admin.vo.app.company.CompanyDeptVo;

import java.util.List;

public interface IAppCompanyAuthService {

    List<CompanyDeptVo> deptList();

    CompanyAuthVo status(Integer userId);

    CompanyAuthVo authenticate(Integer userId, CompanyAuthValidate validate);
}
