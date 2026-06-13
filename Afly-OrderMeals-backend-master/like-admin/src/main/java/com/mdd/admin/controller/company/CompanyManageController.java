package com.mdd.admin.controller.company;

import com.mdd.admin.service.ICompanyManageService;
import com.mdd.admin.service.ICreditManageService;
import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.validate.company.PointsGrantBatchValidate;
import com.mdd.admin.validate.company.PointsGrantValidate;
import com.mdd.admin.validate.company.UserCompanySearchValidate;
import com.mdd.admin.validate.company.UserPointsLogSearchValidate;
import com.mdd.admin.validate.credit.CreditConfigSaveValidate;
import com.mdd.admin.validate.credit.CreditLogSearchValidate;
import com.mdd.admin.validate.credit.CreditMonthlyStatsSearchValidate;
import com.mdd.admin.vo.company.PointsGrantBatchVo;
import com.mdd.admin.vo.company.PointsGrantResultVo;
import com.mdd.admin.vo.company.UserCompanyListVo;
import com.mdd.admin.vo.company.UserPointsLogListVo;
import com.mdd.admin.vo.credit.CreditConfigDetailVo;
import com.mdd.admin.vo.credit.CreditLogListVo;
import com.mdd.admin.vo.credit.CreditMonthlyStatsVo;
import com.mdd.common.core.AjaxResult;
import com.mdd.common.core.PageResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

@RestController
@RequestMapping("/api/company")
public class CompanyManageController {

    @Resource
    private ICompanyManageService companyManageService;
    @Resource
    private ICreditManageService creditManageService;

    @GetMapping("/auth/list")
    public AjaxResult<PageResult<UserCompanyListVo>> authList(@Validated PageValidate pageValidate,
                                                              @Validated UserCompanySearchValidate searchValidate) {
        return AjaxResult.success(companyManageService.authList(pageValidate, searchValidate));
    }

    @GetMapping("/points/log/list")
    public AjaxResult<PageResult<UserPointsLogListVo>> pointsLogList(@Validated PageValidate pageValidate,
                                                                    @Validated UserPointsLogSearchValidate searchValidate) {
        return AjaxResult.success(companyManageService.pointsLogList(pageValidate, searchValidate));
    }

    @PostMapping("/points/grant")
    public AjaxResult<PointsGrantResultVo> grantPoints(@Validated @RequestBody PointsGrantValidate validate) {
        return AjaxResult.success(companyManageService.grantPoints(validate.getUserId(), validate.getAmount()));
    }

    @PostMapping("/points/grant/all")
    public AjaxResult<PointsGrantBatchVo> grantPointsAll(@Validated @RequestBody(required = false) PointsGrantBatchValidate validate) {
        Integer amount = validate == null ? null : validate.getAmount();
        return AjaxResult.success(companyManageService.grantPointsAll(amount));
    }

    @GetMapping("/credit/config/detail")
    public AjaxResult<CreditConfigDetailVo> creditConfigDetail() {
        return AjaxResult.success(creditManageService.configDetail());
    }

    @PostMapping("/credit/config/save")
    public AjaxResult<Object> creditConfigSave(@Validated @RequestBody CreditConfigSaveValidate validate) {
        creditManageService.saveConfig(validate);
        return AjaxResult.success();
    }

    @GetMapping("/credit/log/list")
    public AjaxResult<PageResult<CreditLogListVo>> creditLogList(@Validated PageValidate pageValidate,
                                                                 @Validated CreditLogSearchValidate searchValidate) {
        return AjaxResult.success(creditManageService.logList(pageValidate, searchValidate));
    }

    @GetMapping("/credit/stats/monthly")
    public AjaxResult<PageResult<CreditMonthlyStatsVo>> creditMonthlyStats(@Validated PageValidate pageValidate,
                                                                           @Validated CreditMonthlyStatsSearchValidate searchValidate) {
        return AjaxResult.success(creditManageService.monthlyStats(pageValidate, searchValidate));
    }

    @PostMapping("/credit/log/sync")
    public AjaxResult<Object> creditLogSync() {
        return AjaxResult.success(creditManageService.syncCreditLogs());
    }
}
