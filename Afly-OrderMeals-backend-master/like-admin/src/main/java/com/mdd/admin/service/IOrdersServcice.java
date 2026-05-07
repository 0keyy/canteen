package com.mdd.admin.service;

import com.mdd.admin.validate.order.OrdersSearchValidate;
import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.vo.orders.OrdersCurrentVo;
import com.mdd.admin.vo.orders.OrdersDishListVo;
import com.mdd.admin.vo.orders.OrdersListVo;
import com.mdd.common.core.PageResult;

import java.util.List;

public interface IOrdersServcice {
    /**
     * 订单列表
     * @param pageValidate
     * @param searchValidate
     * @return
     */
    PageResult<OrdersListVo> list(PageValidate pageValidate, OrdersSearchValidate searchValidate);

    /**
     * 获得订单中所有菜品
     */
    List<OrdersDishListVo> dish(Integer id);

    /**
     * 获得当前商户正在进行的订单
     * @return
     */
    List<OrdersCurrentVo> current();
}
