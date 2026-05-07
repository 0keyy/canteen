package com.mdd.admin.controller.shop;

import com.mdd.admin.service.IShopConfigService;
import com.mdd.admin.validate.shop.ShopConfigValidate;
import com.mdd.admin.vo.shop.ShopConfigVo;
import com.mdd.common.core.AjaxResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("api/shop")
public class ShopConfigController {
    @Resource
    private IShopConfigService shopConfigService;

    @GetMapping("/config")
    public AjaxResult<ShopConfigVo> config(){
        return AjaxResult.success(shopConfigService.config());
    }
    @PostMapping("/save")
    public AjaxResult<Object> save(@Validated @RequestBody ShopConfigValidate shopConfigValidate){
        shopConfigService.save(shopConfigValidate);
        return AjaxResult.success();
    }
    @GetMapping("/change")
    public AjaxResult<Object> change(Integer id,Integer status){
        shopConfigService.change(id,status);
        return AjaxResult.success();
    }
}
