package com.mdd.admin.controller.app;

import com.mdd.admin.AppThreadLocal;
import com.mdd.admin.service.app.IAppCompanyAuthService;
import com.mdd.admin.validate.app.company.CompanyAuthValidate;
import com.mdd.admin.vo.app.company.CompanyAuthVo;
import com.mdd.admin.vo.app.company.CompanyDeptVo;
import com.mdd.common.core.AjaxResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/api/front/company")
public class AppCompanyAuthController {

    @Resource
    private IAppCompanyAuthService companyAuthService;

    @GetMapping("/dept/list")
    public AjaxResult<List<CompanyDeptVo>> deptList() {
        return AjaxResult.success(companyAuthService.deptList());
    }

    @GetMapping("/status")
    public AjaxResult<CompanyAuthVo> status() {
        return AjaxResult.success(companyAuthService.status(AppThreadLocal.getUserId()));
    }

    @PostMapping("/auth")
    public AjaxResult<CompanyAuthVo> auth(@Validated @RequestBody CompanyAuthValidate validate) {
        return AjaxResult.success(companyAuthService.authenticate(AppThreadLocal.getUserId(), validate));
    }
}
