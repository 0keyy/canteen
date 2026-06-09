package com.mdd.admin.controller.app;

import com.mdd.common.core.AjaxResult;
import com.mdd.admin.AppThreadLocal;
import com.mdd.admin.service.app.IAppAuthService;
import com.mdd.admin.validate.app.auth.*;
import com.mdd.admin.vo.app.auth.LoginVo;
import com.mdd.admin.vo.app.auth.UserProfileVo;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/api/front/auth")
public class AppAuthController {

    @Resource
    private IAppAuthService authService;

    @PostMapping("/wx/login")
    public AjaxResult<LoginVo> wxLogin(@Validated @RequestBody WxLoginValidate validate) {
        return AjaxResult.success(authService.wxLogin(validate));
    }

    @PostMapping("/wx/phone")
    public AjaxResult<LoginVo> wxPhone(@Validated @RequestBody WxPhoneValidate validate) {
        return AjaxResult.success(authService.wxPhone(validate));
    }

    @PostMapping("/ali/login")
    public AjaxResult<LoginVo> aliLogin(@Validated @RequestBody AliLoginValidate validate) {
        return AjaxResult.success(authService.aliLogin(validate));
    }

    @PostMapping("/ali/phone")
    public AjaxResult<LoginVo> aliPhone(@Validated @RequestBody AliLoginValidate validate) {
        return AjaxResult.success(authService.aliPhone(validate));
    }

    @PostMapping("/app/sms/send")
    public AjaxResult<Object> smsSend(@Validated @RequestBody SmsSendValidate validate) {
        authService.smsSend(validate);
        return AjaxResult.success("验证码已发送");
    }

    @PostMapping("/app/sms/login")
    public AjaxResult<LoginVo> smsLogin(@Validated @RequestBody SmsLoginValidate validate) {
        return AjaxResult.success(authService.smsLogin(validate));
    }

    @PostMapping("/mock/phone")
    public AjaxResult<LoginVo> mockPhoneLogin(@RequestBody MockPhoneLoginValidate validate) {
        return AjaxResult.success(authService.mockPhoneLogin(validate));
    }

    @GetMapping("/profile")
    public AjaxResult<UserProfileVo> profile() {
        return AjaxResult.success(authService.profile(AppThreadLocal.getUserId()));
    }

    @PostMapping("/logout")
    public AjaxResult<Object> logout() {
        authService.logout(AppThreadLocal.getUserId());
        return AjaxResult.success();
    }
}
