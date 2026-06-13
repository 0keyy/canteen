package com.mdd.admin.service;

import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.validate.credit.CreditConfigSaveValidate;
import com.mdd.admin.validate.credit.CreditLogSearchValidate;
import com.mdd.admin.validate.credit.CreditMonthlyStatsSearchValidate;
import com.mdd.admin.vo.credit.CreditConfigDetailVo;
import com.mdd.admin.vo.credit.CreditLogListVo;
import com.mdd.admin.vo.credit.CreditMonthlyStatsVo;
import com.mdd.common.core.PageResult;

public interface ICreditManageService {

    CreditConfigDetailVo configDetail();

    void saveConfig(CreditConfigSaveValidate validate);

    PageResult<CreditLogListVo> logList(PageValidate pageValidate, CreditLogSearchValidate searchValidate);

    PageResult<CreditMonthlyStatsVo> monthlyStats(PageValidate pageValidate, CreditMonthlyStatsSearchValidate searchValidate);

    int syncCreditLogs();
}
