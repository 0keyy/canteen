package com.mdd.admin;

import cn.dev33.satoken.stp.StpLogic;
import com.alibaba.fastjson2.JSON;
import com.mdd.admin.config.AppConfig;
import com.mdd.admin.config.StpUserUtil;
import com.mdd.common.core.AjaxResult;
import com.mdd.common.enums.HttpEnum;
import com.mdd.common.util.StringUtils;
import org.jetbrains.annotations.NotNull;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.List;

/**
 * 小程序端拦截器（迁移自 like-uniapp LikeUniappInterceptor）
 */
@Component
public class LikeAppInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(@NotNull HttpServletRequest request,
                             @NotNull HttpServletResponse response,
                             @NotNull Object handler) throws Exception {
        response.setContentType("application/json;charset=utf-8");
        if (!(handler instanceof HandlerMethod)) {
            return HandlerInterceptor.super.preHandle(request, response, handler);
        }

        String prefix = "/api/";
        String route = request.getRequestURI().replaceFirst(prefix, "");
        String auths = route.replace("/", ":");

        List<String> notLoginUri = Arrays.asList(AppConfig.notLoginUri);
        if (notLoginUri.contains(auths)) {
            return HandlerInterceptor.super.preHandle(request, response, handler);
        }

        StpLogic stpLogic = StpUserUtil.getStpLogic();
        String token = stpLogic.getTokenValue();
        if (StringUtils.isBlank(token)) {
            AjaxResult<Object> result = AjaxResult.failed(HttpEnum.TOKEN_EMPTY.getCode(), HttpEnum.TOKEN_EMPTY.getMsg());
            response.getWriter().print(JSON.toJSONString(result));
            return false;
        }

        Object id = stpLogic.getLoginIdDefaultNull();
        if (StringUtils.isNull(id)) {
            AjaxResult<Object> result = AjaxResult.failed(HttpEnum.TOKEN_INVALID.getCode(), HttpEnum.TOKEN_INVALID.getMsg());
            response.getWriter().print(JSON.toJSONString(result));
            return false;
        }

        AppThreadLocal.put("userId", id);
        return HandlerInterceptor.super.preHandle(request, response, handler);
    }

    @Override
    public void afterCompletion(@NotNull HttpServletRequest request,
                                @NotNull HttpServletResponse response,
                                @NotNull Object handler, Exception ex) {
        AppThreadLocal.remove();
    }
}
