package com.mdd.admin.service;

import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.validate.company.UserCompanySearchValidate;
import com.mdd.admin.validate.company.UserPointsLogSearchValidate;
import com.mdd.admin.vo.company.PointsGrantBatchVo;
import com.mdd.admin.vo.company.PointsGrantResultVo;
import com.mdd.admin.vo.company.UserCompanyListVo;
import com.mdd.admin.vo.company.UserPointsLogListVo;
import com.mdd.common.core.PageResult;

public interface ICompanyManageService {

    PageResult<UserCompanyListVo> authList(PageValidate pageValidate, UserCompanySearchValidate searchValidate);

    PageResult<UserPointsLogListVo> pointsLogList(PageValidate pageValidate, UserPointsLogSearchValidate searchValidate);

    PointsGrantResultVo grantPoints(Integer userId, Integer amount);

    PointsGrantBatchVo grantPointsAll(Integer amount);
}
