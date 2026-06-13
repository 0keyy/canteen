package com.mdd.admin.service;

import java.util.Map;

public interface ICouponVerifyService {

    Map<String, Object> verify(String verifyCode);
}
