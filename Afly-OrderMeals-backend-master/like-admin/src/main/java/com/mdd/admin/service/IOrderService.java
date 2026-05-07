package com.mdd.admin.service;

import com.mdd.admin.validate.order.DishAddValidate;
import com.mdd.admin.validate.order.OrderSubmitValidate;
import com.mdd.admin.validate.order.OrdersCreateValidate;
import com.mdd.admin.vo.order.OrderDeskVo;
import com.mdd.admin.vo.order.OrderDishCateVo;
import com.mdd.admin.vo.order.OrderDishVo;

import java.util.List;

public interface IOrderService {

    List<OrderDeskVo> list();

    List<OrderDishCateVo> dishCate();

    List<OrderDishVo> dishList();

    /**
     * 创建订单
     * @param ordersCreateValidate
     */
    Integer ordersCreate(OrdersCreateValidate ordersCreateValidate);
    /**
     * 菜品加购
     *
     * @return
     */
    Integer dishAdd(DishAddValidate dishAddValidate);
    /**
     * 菜品+1
     *
     * @param id
     */
    void dishInc(Integer id);

    /**
     * 菜品-1
     *
     * @param id
     */
    void dishDec(Integer id);

    /**
     * 菜品删除
     *
     * @param id
     */
    void dishDel(Integer id);

    /**
     * 菜品清空
     * @param id
     */
    void toEmpty(Integer id);

    /**
     * 出单
     * @param orderSubmitValidate
     */
    void submit(OrderSubmitValidate orderSubmitValidate);

    /**
     * 结账
     */
    void checkout(Integer oid);

}
