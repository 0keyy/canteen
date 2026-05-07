package com.mdd.admin.service;

import com.mdd.admin.validate.shop.ShopConfigValidate;
import com.mdd.admin.vo.shop.ShopConfigVo;

public interface IShopConfigService {
    /**
     * 获取店铺配置信息
     */
    ShopConfigVo config();
    /**
     * 保存店铺配置
     */
    void save(ShopConfigValidate shopConfigValidate);
    /**
     * 改变店铺状态
     */
    void change(Integer id,Integer status);
}
