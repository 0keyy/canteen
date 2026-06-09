package com.mdd.admin.controller.app;

import com.mdd.admin.service.IDecoratePageService;
import com.mdd.admin.service.IDecorateTabbarService;
import com.mdd.admin.vo.decorate.DecoratePageVo;
import com.mdd.admin.vo.decorate.DecorateTabbarVo;
import com.mdd.common.core.AjaxResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

@RestController
@RequestMapping("/api/front/decorate")
public class AppDecorateController {

    @Resource
    private IDecorateTabbarService decorateTabbarService;
    @Resource
    private IDecoratePageService decoratePageService;

    @GetMapping("/tabbar")
    public AjaxResult<DecorateTabbarVo> tabbar() {
        return AjaxResult.success(decorateTabbarService.detail());
    }

    @GetMapping("/page")
    public AjaxResult<DecoratePageVo> page(@RequestParam(defaultValue = "1") Integer id) {
        return AjaxResult.success(decoratePageService.detailForApp(id));
    }
}
