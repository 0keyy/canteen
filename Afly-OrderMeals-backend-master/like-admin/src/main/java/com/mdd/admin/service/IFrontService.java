package com.mdd.admin.service;

import com.mdd.admin.validate.front.FrontOrdersCreateValidate;
import com.mdd.admin.validate.order.OrderSubmitValidate;
import com.mdd.admin.vo.front.DeskVo;
import com.mdd.admin.vo.front.GoodsVo;
import com.mdd.admin.vo.shop.ShopConfigVo;

import java.util.List;

public interface IFrontService {
    List<GoodsVo> goods(Integer aid);
    /**
     * 获取商户信息
     */
    ShopConfigVo seller(Integer id);
    /**
     * 获取桌号信息
     */
    DeskVo desk(Integer did);
    /**
     * 前-下单
     */
    Integer create(FrontOrdersCreateValidate ordersCreateValidate);
    /**
     * 是否已有订单
     */
    Object has(Integer did);

    void submit(OrderSubmitValidate orderSubmitValidate);
}
