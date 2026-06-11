package com.mdd.admin.service.app;

import com.mdd.admin.validate.app.pay.PayCreateValidate;
import com.mdd.admin.vo.app.pay.PayCreateVo;
import com.mdd.admin.vo.app.pay.PayMethodVo;

import java.util.List;

public interface IAppPayService {

    List<PayMethodVo> listMethods(Integer orderId, Integer userId);

    PayCreateVo create(PayCreateValidate validate, Integer userId);

    void mockSuccess(String outTradeNo);

    void wxNotify(String body);

    void aliNotify(String body);

    Integer status(String outTradeNo, Integer userId);
}
