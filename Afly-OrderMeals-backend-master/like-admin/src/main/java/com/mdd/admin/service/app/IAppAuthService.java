package com.mdd.admin.service.app;

import com.mdd.admin.validate.app.auth.*;
import com.mdd.admin.vo.app.auth.LoginVo;
import com.mdd.admin.vo.app.auth.UserProfileVo;

public interface IAppAuthService {

    LoginVo wxLogin(WxLoginValidate validate);

    LoginVo wxPhone(WxPhoneValidate validate);

    LoginVo aliLogin(AliLoginValidate validate);

    LoginVo aliPhone(AliLoginValidate validate);

    void smsSend(SmsSendValidate validate);

    LoginVo smsLogin(SmsLoginValidate validate);

    LoginVo mockPhoneLogin(MockPhoneLoginValidate validate);

    UserProfileVo profile(Integer userId);

    void logout(Integer userId);
}
