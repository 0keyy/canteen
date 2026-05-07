package com.mdd.admin.controller.orders;

import com.mdd.admin.service.IOrdersServcice;
import com.mdd.admin.validate.order.OrdersSearchValidate;
import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.vo.orders.OrdersCurrentVo;
import com.mdd.admin.vo.orders.OrdersDishListVo;
import com.mdd.admin.vo.orders.OrdersListVo;
import com.mdd.common.core.AjaxResult;
import com.mdd.common.core.PageResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/api/orders")
public class OrdersController {
    @Resource
    private IOrdersServcice ordersServcice;

    /**
     * 订单列表
     *
     * @param pageValidate 分页参数
     * @param searchValidate 搜索参数
     * @return AjaxResult<Object>
     */
    @GetMapping("/list")
    public AjaxResult<PageResult<OrdersListVo>> list(@Validated PageValidate pageValidate, @Validated OrdersSearchValidate searchValidate){
        PageResult<OrdersListVo> voPageResult = ordersServcice.list(pageValidate, searchValidate);
        return AjaxResult.success(voPageResult);
    }

    /**
     * 获得当前商户正在进行的订单
     * @return
     */
    @GetMapping("/current")
    public AjaxResult<List<OrdersCurrentVo>> current(){
        List<OrdersCurrentVo> vos = ordersServcice.current();
        return AjaxResult.success(vos);
    }
    /**
     * 获得订单中菜品
     * @return
     */
    @GetMapping("/dish")
    public AjaxResult<List<OrdersDishListVo>> dish(@RequestParam Integer id){
        List<OrdersDishListVo> dishList = ordersServcice.dish(id);
        return AjaxResult.success(dishList);
    }
}
