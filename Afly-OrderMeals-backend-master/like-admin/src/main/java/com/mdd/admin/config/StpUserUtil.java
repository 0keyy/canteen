package com.mdd.admin.config;

import cn.dev33.satoken.stp.SaLoginModel;
import cn.dev33.satoken.stp.StpLogic;

public class StpUserUtil {

    public static final String TYPE = "user";

    private static final StpLogic stpLogic = new StpLogic(TYPE);

    static {
        // 与独立 like-uniapp 服务保持一致，前端请求头使用 like-uniapp
        stpLogic.getConfig().setTokenName("like-uniapp");
    }

    private StpUserUtil() {}

    public static StpLogic getStpLogic() {
        return stpLogic;
    }

    public static void login(Object id) {
        stpLogic.login(id);
    }

    public static void login(Object id, SaLoginModel loginModel) {
        stpLogic.login(id, loginModel);
    }

    public static void logout() {
        stpLogic.logout();
    }

    public static void logout(Object loginId) {
        stpLogic.logout(loginId);
    }

    public static boolean isLogin() {
        return stpLogic.isLogin();
    }

    public static Object getLoginId() {
        return stpLogic.getLoginId();
    }

    public static int getLoginIdAsInt() {
        return stpLogic.getLoginIdAsInt();
    }

    public static String getTokenValue() {
        return stpLogic.getTokenValue();
    }

    public static void checkLogin() {
        stpLogic.checkLogin();
    }
}
