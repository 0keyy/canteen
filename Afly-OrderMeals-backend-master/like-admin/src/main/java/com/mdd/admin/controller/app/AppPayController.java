package com.mdd.admin.controller.app;

import com.mdd.common.core.AjaxResult;
import com.mdd.admin.AppThreadLocal;
import com.mdd.admin.service.app.IAppPayService;
import com.mdd.admin.validate.app.pay.PayCreateValidate;
import com.mdd.admin.vo.app.pay.PayCreateVo;
import com.mdd.admin.vo.app.pay.PayMethodVo;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/api/front/pay")
public class AppPayController {

    @Resource
    private IAppPayService payService;

    @GetMapping("/methods")
    public AjaxResult<List<PayMethodVo>> methods(@RequestParam Integer orderId) {
        return AjaxResult.success(payService.listMethods(orderId, AppThreadLocal.getUserId()));
    }

    @PostMapping("/create")
    public AjaxResult<PayCreateVo> create(@Validated @RequestBody PayCreateValidate validate) {
        return AjaxResult.success(payService.create(validate, AppThreadLocal.getUserId()));
    }

    @PostMapping("/mock/success")
    public AjaxResult<Object> mockSuccess(@RequestParam String outTradeNo) {
        payService.mockSuccess(outTradeNo);
        return AjaxResult.success();
    }

    @PostMapping("/notify/wx")
    public String wxNotify(@RequestBody String body) {
        payService.wxNotify(body);
        return "success";
    }

    @PostMapping("/notify/ali")
    public String aliNotify(@RequestBody String body) {
        payService.aliNotify(body);
        return "success";
    }

    /** 聚合支付回调（预留） */
    @PostMapping("/notify/aggregate")
    public String aggregateNotify(@RequestBody String body) {
        // 待对接聚合支付平台后实现
        return "success";
    }

    @GetMapping("/status")
    public AjaxResult<Object> status(@RequestParam String outTradeNo) {
        return AjaxResult.success(payService.status(outTradeNo, AppThreadLocal.getUserId()));
    }
}
