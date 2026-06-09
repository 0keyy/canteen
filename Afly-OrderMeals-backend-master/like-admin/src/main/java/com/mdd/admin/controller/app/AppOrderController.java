package com.mdd.admin.controller.app;

import com.mdd.common.core.AjaxResult;
import com.mdd.admin.AppThreadLocal;
import com.mdd.admin.service.app.IAppOrderService;
import com.mdd.admin.validate.app.order.CartCreateValidate;
import com.mdd.admin.validate.app.order.DishAddValidate;
import com.mdd.admin.validate.app.order.OrderSubmitValidate;
import com.mdd.admin.vo.app.order.*;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/front/order")
public class AppOrderController {

    @Resource
    private IAppOrderService orderService;

    @GetMapping("/shop")
    public AjaxResult<ShopVo> shop(@RequestParam Integer aid) {
        return AjaxResult.success(orderService.shop(aid));
    }

    @GetMapping("/menu")
    public AjaxResult<List<GoodsVo>> menu(@RequestParam Integer aid) {
        return AjaxResult.success(orderService.menu(aid));
    }

    @PostMapping("/cart/create")
    public AjaxResult<Object> cartCreate(@Validated @RequestBody CartCreateValidate validate) {
        Integer orderId = orderService.cartCreate(validate, AppThreadLocal.getUserId());
        return AjaxResult.success(orderId);
    }

    @GetMapping("/cart/has")
    public AjaxResult<Map<String, Object>> cartHas(@RequestParam Integer aid) {
        return AjaxResult.success(orderService.cartHas(AppThreadLocal.getUserId(), aid));
    }

    @PostMapping("/cart/dishAdd")
    public AjaxResult<Object> dishAdd(@Validated @RequestBody DishAddValidate validate) {
        return AjaxResult.success(orderService.dishAdd(validate));
    }

    @PostMapping("/cart/dishInc")
    public AjaxResult<Object> dishInc(@RequestParam Integer id) {
        orderService.dishInc(id);
        return AjaxResult.success();
    }

    @PostMapping("/cart/dishDec")
    public AjaxResult<Object> dishDec(@RequestParam Integer id) {
        orderService.dishDec(id);
        return AjaxResult.success();
    }

    @PostMapping("/cart/dishDel")
    public AjaxResult<Object> dishDel(@RequestParam Integer id) {
        orderService.dishDel(id);
        return AjaxResult.success();
    }

    @PostMapping("/cart/toEmpty")
    public AjaxResult<Object> toEmpty(@RequestParam Integer orderId) {
        orderService.toEmpty(orderId, AppThreadLocal.getUserId());
        return AjaxResult.success();
    }

    @PostMapping("/submit")
    public AjaxResult<OrderDetailVo> submit(@Validated @RequestBody OrderSubmitValidate validate) {
        return AjaxResult.success(orderService.submit(validate, AppThreadLocal.getUserId()));
    }

    @GetMapping("/list")
    public AjaxResult<List<OrderListVo>> list() {
        return AjaxResult.success(orderService.list(AppThreadLocal.getUserId()));
    }

    @GetMapping("/detail")
    public AjaxResult<OrderDetailVo> detail(@RequestParam Integer orderId) {
        return AjaxResult.success(orderService.detail(orderId, AppThreadLocal.getUserId()));
    }

    @PostMapping("/cancel")
    public AjaxResult<Object> cancel(@RequestParam Integer orderId, @RequestParam(required = false) String reason) {
        orderService.cancel(orderId, AppThreadLocal.getUserId(), reason);
        return AjaxResult.success();
    }
}
