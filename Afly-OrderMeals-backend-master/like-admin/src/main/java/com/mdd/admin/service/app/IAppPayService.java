package com.mdd.admin.service.app;

import com.mdd.admin.validate.app.pay.PayCreateValidate;
import com.mdd.admin.vo.app.pay.PayCreateVo;

public interface IAppPayService {

    PayCreateVo create(PayCreateValidate validate, Integer userId);

    void mockSuccess(String outTradeNo);

    void wxNotify(String body);

    void aliNotify(String body);

    Integer status(String outTradeNo, Integer userId);
}
