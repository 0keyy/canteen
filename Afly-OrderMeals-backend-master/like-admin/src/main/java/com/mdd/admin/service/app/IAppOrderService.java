package com.mdd.admin.service.app;

import com.mdd.admin.validate.app.order.CartCreateValidate;
import com.mdd.admin.validate.app.order.DishAddValidate;
import com.mdd.admin.validate.app.order.OrderSubmitValidate;
import com.mdd.admin.vo.app.order.*;

import java.util.List;
import java.util.Map;

public interface IAppOrderService {

    ShopVo shop(Integer aid);

    List<GoodsVo> menu(Integer aid);

    Integer cartCreate(CartCreateValidate validate, Integer userId);

    Map<String, Object> cartHas(Integer userId, Integer aid);

    Integer dishAdd(DishAddValidate validate);

    void dishInc(Integer id);

    void dishDec(Integer id);

    void dishDel(Integer id);

    void toEmpty(Integer orderId, Integer userId);

    OrderDetailVo submit(OrderSubmitValidate validate, Integer userId);

    List<OrderListVo> list(Integer userId);

    OrderDetailVo detail(Integer orderId, Integer userId);

    void cancel(Integer orderId, Integer userId, String reason);
}
