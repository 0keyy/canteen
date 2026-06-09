package com.mdd.admin.config;

public class AppConfig {

    public static final String[] notLoginUri = new String[]{
            "front:auth:wx:login",
            "front:auth:wx:phone",
            "front:auth:ali:login",
            "front:auth:ali:phone",
            "front:auth:app:sms:send",
            "front:auth:app:sms:login",
            "front:auth:mock:phone",
            "front:pay:notify:wx",
            "front:pay:notify:ali",
            "front:decorate:tabbar",
            "front:decorate:page",
    };
}
