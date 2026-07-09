package com.mdd.admin.controller.app;

import com.mdd.common.core.AjaxResult;
import com.mdd.admin.AppThreadLocal;
import com.mdd.admin.service.app.IAppAddressService;
import com.mdd.admin.validate.app.address.AddressValidate;
import com.mdd.admin.vo.app.address.AddressVo;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/api/front/address")
public class AppAddressController {

    @Resource
    private IAppAddressService addressService;

    /**
     * 地址列表
     */
    @GetMapping("/list")
    public AjaxResult<List<AddressVo>> list() {
        return AjaxResult.success(addressService.list(AppThreadLocal.getUserId()));
    }

    /**
     * 地址详情
     * @param id
     * @return
     */
    @GetMapping("/detail")
    public AjaxResult<AddressVo> detail(@RequestParam Integer id) {
        return AjaxResult.success(addressService.detail(id, AppThreadLocal.getUserId()));
    }

    /**
     * 地址保存
     * @param validate
     * @return
     */
    @PostMapping("/save")
    public AjaxResult<Object> save(@Validated @RequestBody AddressValidate validate) {
        addressService.save(validate, AppThreadLocal.getUserId());
        return AjaxResult.success();
    }

    /**
     * 地址删除
     * @param id
     * @return
     */
    @PostMapping("/delete")
    public AjaxResult<Object> delete(@RequestParam Integer id) {
        addressService.delete(id, AppThreadLocal.getUserId());
        return AjaxResult.success();
    }

    /**
     * 设置默认地址
     * @param id
     * @return
     */
    @PostMapping("/setDefault")
    public AjaxResult<Object> setDefault(@RequestParam Integer id) {
        addressService.setDefault(id, AppThreadLocal.getUserId());
        return AjaxResult.success();
    }
}
