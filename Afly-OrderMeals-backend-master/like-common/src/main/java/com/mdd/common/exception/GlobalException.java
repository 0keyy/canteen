package com.mdd.common.exception;

import com.baomidou.mybatisplus.core.exceptions.MybatisPlusException;
import com.mdd.common.config.GlobalConfig;
import com.mdd.common.core.AjaxResult;
import com.mdd.common.enums.HttpEnum;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.NoHandlerFoundException;

import java.util.Objects;

/**
 * 全局异常处理
 */
@Slf4j
@ControllerAdvice
public class GlobalException {

    /**
     * 处理所有不可知异常
     */
    @ResponseStatus(HttpStatus.OK)
    @ExceptionHandler(Exception.class)
    @ResponseBody
    public AjaxResult<Object> handleException(Exception e) {
        if (GlobalConfig.debug) {
            e.printStackTrace();
            System.out.println(e.getMessage());
        }
        log.error("系统异常", e);
        String msg = GlobalConfig.debug ? e.getMessage() : HttpEnum.SYSTEM_ERROR.getMsg();
        return AjaxResult.failed(HttpEnum.SYSTEM_ERROR.getCode(), msg);
    }

    /**
     * 拦截404异常
     */
    @ResponseStatus(HttpStatus.OK)
    @ExceptionHandler(NoHandlerFoundException.class)
    @ResponseBody
    public AjaxResult<Object> handleNoHandlerFoundException(NoHandlerFoundException e){
        return AjaxResult.failed(HttpEnum.REQUEST_404_ERROR.getCode(), e.getMessage());
    }

    /**
     * 拦截数据库唯一键冲突
     */
    @ResponseStatus(HttpStatus.OK)
    @ExceptionHandler(DuplicateKeyException.class)
    @ResponseBody
    public AjaxResult<Object> handleDuplicateKeyException(DuplicateKeyException e) {
        String raw = e.getMessage() == null ? "" : e.getMessage();
        if (raw.contains("uk_ruoyi_user_id")) {
            return AjaxResult.failed(HttpEnum.FAILED.getCode(), "该若依账号已被其他用户认证，请更换账号");
        }
        if (raw.contains("uk_user_id")) {
            return AjaxResult.failed(HttpEnum.FAILED.getCode(), "您已完成公司认证，无需重复认证");
        }
        if (raw.contains("uk_user_template")) {
            return AjaxResult.failed(HttpEnum.FAILED.getCode(), "您已领取过该券");
        }
        return AjaxResult.failed(HttpEnum.FAILED.getCode(), "数据已存在，请勿重复操作");
    }

    /**
     * 拦截自定义抛出异常
     */
    @ResponseStatus(HttpStatus.OK)
    @ExceptionHandler(BaseException.class)
    @ResponseBody
    public AjaxResult<Object> handleException(BaseException e) {
        int code = e.getCode();
        String msg = e.getMsg();
        return AjaxResult.failed(code, msg);
    }

    /**
     * 拦截表单参数校验FROM
     */
    @ResponseStatus(HttpStatus.OK)
    @ExceptionHandler(BindException.class)
    @ResponseBody
    public AjaxResult<Object> handleBindException(BindException e) {
        BindingResult bindingResult = e.getBindingResult();
        Integer code = HttpEnum.PARAMS_VALID_ERROR.getCode();
        String msg   = Objects.requireNonNull(bindingResult.getFieldError()).getDefaultMessage();
        return AjaxResult.failed(code, msg);
    }

    /**
     * 拦截路径参数校验PATH
     */
    @ResponseStatus(HttpStatus.OK)
    @ExceptionHandler(MissingServletRequestParameterException.class)
    @ResponseBody
    public AjaxResult<Object> handlePathException(MissingServletRequestParameterException e) {
        Integer code = HttpEnum.PARAMS_VALID_ERROR.getCode();
        String msg   = Objects.requireNonNull(e.getMessage());
        return AjaxResult.failed(code, msg);
    }

    /**
     * 拦截JSON参数校验
     */
    @ResponseStatus(HttpStatus.OK)
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseBody
    public AjaxResult<Object> handleMethodArgumentNotValidException(MethodArgumentNotValidException e) {
        BindingResult bindingResult = e.getBindingResult();
        Integer code = HttpEnum.PARAMS_VALID_ERROR.getCode();
        String msg   = Objects.requireNonNull(bindingResult.getFieldError()).getDefaultMessage();
        return AjaxResult.failed(code, msg);
    }

    /**
     * 拦截参数类型不正确
     */
    @ResponseStatus(HttpStatus.OK)
    @ExceptionHandler(HttpMessageNotReadableException.class)
    @ResponseBody
    public AjaxResult<Object> handleHttpMessageNotReadableException(HttpMessageNotReadableException e) {
        Integer code = HttpEnum.PARAMS_TYPE_ERROR.getCode();
        String msg   = Objects.requireNonNull(e.getMessage());
        return AjaxResult.failed(code, msg.split(";")[0]);
    }

    /**
     * 拦截请求方法
     */
    @ResponseStatus(HttpStatus.OK)
    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    @ResponseBody
    public AjaxResult<Object> handleRequestMethodException(HttpRequestMethodNotSupportedException e) {
        Integer code = HttpEnum.REQUEST_METHOD_ERROR.getCode();
        String msg   = Objects.requireNonNull(e.getMessage());
        return AjaxResult.failed(code, msg);
    }

    /**
     * 拦截断言异常
     */
    @ResponseStatus(HttpStatus.OK)
    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseBody
    public AjaxResult<Object> handleIllegalArgumentException(IllegalArgumentException e) {
        Integer code = HttpEnum.ASSERT_ARGUMENT_ERROR.getCode();
        String msg   = Objects.requireNonNull(e.getMessage());
        return AjaxResult.failed(code, msg);
    }

    /**
     * 拦截MybatisPlus异常
     */
    @ResponseStatus(HttpStatus.OK)
    @ExceptionHandler(MybatisPlusException.class)
    @ResponseBody
    public AjaxResult<Object> handleMybatisPlusException(MybatisPlusException e) {
        Integer code = HttpEnum.ASSERT_MYBATIS_ERROR.getCode();
        String msg   = Objects.requireNonNull(e.getMessage());
        return AjaxResult.failed(code, msg);
    }

}
