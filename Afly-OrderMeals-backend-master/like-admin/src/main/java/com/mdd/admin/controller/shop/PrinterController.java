package com.mdd.admin.controller.shop;

import com.mdd.admin.service.IPrinterService;
import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.validate.shop.PrinterValidate;
import com.mdd.admin.vo.shop.PrinterVo;
import com.mdd.common.core.AjaxResult;
import com.mdd.common.core.PageResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("api/printer")
public class PrinterController {
    @Resource
    private IPrinterService printerService;

    @GetMapping("/list")
    public AjaxResult<PageResult<PrinterVo>> list(@Validated PageValidate pageValidate){
        PageResult<PrinterVo> list = printerService.list(pageValidate);
        return AjaxResult.success(list);
    }
    @PostMapping("/add")
    public AjaxResult<Object> add(@Validated @RequestBody PrinterValidate printerValidate){
        printerService.add(printerValidate);
        return AjaxResult.success();
    }
    @GetMapping("/detail")
    public AjaxResult<PrinterVo> detail(Integer id){
        PrinterVo vo = printerService.detail(id);
        return AjaxResult.success(vo);
    }

}
