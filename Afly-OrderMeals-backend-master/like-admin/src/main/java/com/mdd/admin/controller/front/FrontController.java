package com.mdd.admin.controller.front;

import com.mdd.admin.service.IFrontService;
import com.mdd.admin.service.IOrderService;
import com.mdd.admin.validate.front.FrontOrdersCreateValidate;
import com.mdd.admin.validate.order.DishAddValidate;
import com.mdd.admin.validate.order.OrderSubmitValidate;
import com.mdd.admin.validate.order.OrdersCreateValidate;
import com.mdd.admin.vo.front.DeskVo;
import com.mdd.admin.vo.front.GoodsVo;
import com.mdd.admin.vo.shop.ShopConfigVo;
import com.mdd.common.core.AjaxResult;
import com.mdd.common.enums.HttpEnum;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/api/fr")
public class FrontController {

    @Resource
    private IFrontService frontService;
    @Resource
    private IOrderService iOrderService;

    @GetMapping("/goods")
    public AjaxResult<List<GoodsVo>> goods(Integer aid){
        List<GoodsVo> goods = frontService.goods(aid);
        return AjaxResult.success(goods);
    }

    @GetMapping("/seller")
    public AjaxResult<ShopConfigVo> seller(Integer id){
        ShopConfigVo seller = frontService.seller(id);
        return AjaxResult.success(seller);
    }

    @GetMapping("/desk")
    public AjaxResult<DeskVo> desk(Integer did){
        DeskVo desk = frontService.desk(did);
        return AjaxResult.success(desk);
    }

    @PostMapping("/create")
    public AjaxResult<Object> create(@RequestBody FrontOrdersCreateValidate ordersCreateValidate){
        Integer oid = frontService.create(ordersCreateValidate);
        return AjaxResult.success("成功",oid);
    }

    /**
     * 是否已有订单
     */
    @GetMapping("/has")
    public AjaxResult<Object> has(Integer did) {
        Object o = frontService.has(did);
        return AjaxResult.success(o);
    }

    /**
     * 添加菜品
     */
    @GetMapping("/dishAdd")
    public AjaxResult<Integer> dishAdd(DishAddValidate dishAddValidate) {
        Integer id = iOrderService.dishAdd(dishAddValidate);
        return AjaxResult.success(HttpEnum.SUCCESS.getCode(), HttpEnum.SUCCESS.getMsg(), id);
    }

    /**
     * 菜品删除
     */
    @GetMapping("/dishDel")
    public AjaxResult<Object> dishDel(Integer id) {
        iOrderService.dishDel(id);
        return AjaxResult.success();
    }

    /**
     * 菜品+1
     */
    @GetMapping("/dishInc")
    public AjaxResult<Object> dishInc(Integer id) {
        iOrderService.dishInc(id);
        return AjaxResult.success("");
    }

    /**
     * 菜品-1
     */
    @GetMapping("/dishDec")
    public AjaxResult<Object> dishDec(Integer id) {
        iOrderService.dishDec(id);
        return AjaxResult.success();
    }

    /**
     * 菜品清空
     */
    @GetMapping("/toEmpty")
    public AjaxResult<Object> toEmpty(Integer id) {
        iOrderService.toEmpty(id);
        return AjaxResult.success();
    }

    /**
     * 下单
     * @param orderSubmitValidate
     * @return
     */
    @PostMapping("/submit")
    public AjaxResult<Object> submit(@RequestBody OrderSubmitValidate orderSubmitValidate) {
        frontService.submit(orderSubmitValidate);
        return AjaxResult.success();
    }
}
