package com.mdd.admin.controller.system;

import com.mdd.admin.service.ISystemAuthDeptService;
import com.mdd.admin.validate.commons.IdValidate;
import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.validate.system.SystemDeptCreateValidate;
import com.mdd.admin.validate.system.SystemDeptSearchValidate;
import com.mdd.admin.validate.system.SystemDeptUpdateValidate;
import com.mdd.admin.vo.system.SystemAuthDeptVo;
import com.mdd.common.core.AjaxResult;
import com.mdd.common.core.PageResult;
import com.mdd.common.validator.annotation.IDMust;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * 桌号管理
 */
@RestController
@RequestMapping("api/system/dept")
public class SystemAuthDeptController {

    @Resource
    ISystemAuthDeptService iSystemAuthDeptService;

    /**
     * 所有
     *
     * @return AjaxResult<List < SystemAuthDeptVo>>
     * @author fzr
     */
    @GetMapping("/all")
    public AjaxResult<List<SystemAuthDeptVo>> all() {
        List<SystemAuthDeptVo> list = iSystemAuthDeptService.all();
        return AjaxResult.success(list);
    }

    /**
     * 列表
     *
     * @param searchValidate 搜索参数
     * @return AjaxResult<JSONArray>
     * @author fzr
     */
    @GetMapping("/list")
    public AjaxResult<PageResult<SystemAuthDeptVo>> list(@Validated PageValidate pageValidate, @Validated SystemDeptSearchValidate searchValidate) {
        PageResult<SystemAuthDeptVo> list = iSystemAuthDeptService.list(pageValidate, searchValidate);
        return AjaxResult.success(list);
    }

    /**
     * 详情
     *
     * @param id 主键
     * @return AjaxResult<SystemAuthDeptVo>
     * @author fzr
     */
    @GetMapping("/detail")
    public AjaxResult<SystemAuthDeptVo> detail(@Validated @IDMust() @RequestParam("id") Integer id) {
        SystemAuthDeptVo vo = iSystemAuthDeptService.detail(id);
        return AjaxResult.success(vo);
    }

    /**
     * 新增
     *
     * @param createValidate 参数
     * @return AjaxResult<Object>
     * @author fzr
     */
    @PostMapping("/add")
    public AjaxResult<Object> add(@Validated @RequestBody SystemDeptCreateValidate createValidate) {
        iSystemAuthDeptService.add(createValidate);
        return AjaxResult.success();
    }

    /**
     * 编辑
     *
     * @param updateValidate 参数
     * @return AjaxResult<Object>
     * @author fzr
     */
    @PostMapping("/edit")
    public AjaxResult<Object> edit(@Validated @RequestBody SystemDeptUpdateValidate updateValidate) {
        iSystemAuthDeptService.edit(updateValidate);
        return AjaxResult.success();
    }

    /**
     * 删除
     *
     * @param idValidate 参数
     * @return AjaxResult<Object>
     * @author fzr
     */
    @PostMapping("/del")
    public AjaxResult<Object> del(@Validated @RequestBody IdValidate idValidate) {
        iSystemAuthDeptService.del(idValidate.getId());
        return AjaxResult.success();
    }

    /**
     * 创建桌号二维码
     * @param id
     * @return
     */
    @GetMapping("/createQR")
    public AjaxResult<Object> createQR(Integer id){
        String result = iSystemAuthDeptService.createQR(id);
        return AjaxResult.success("成功",result);
    }

}
