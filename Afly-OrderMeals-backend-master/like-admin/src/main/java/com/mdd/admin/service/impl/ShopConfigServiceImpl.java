package com.mdd.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Assert;
import com.mdd.admin.LikeAdminThreadLocal;
import com.mdd.admin.service.IShopConfigService;
import com.mdd.admin.validate.shop.ShopConfigValidate;
import com.mdd.admin.vo.shop.ShopConfigVo;
import com.mdd.common.entity.shop.ShopConfig;
import com.mdd.common.mapper.shop.ShopConfigMapper;
import com.mdd.common.util.TimeUtils;
import com.mdd.common.util.UrlUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
@Service
public class ShopConfigServiceImpl implements IShopConfigService {
    @Resource
    private ShopConfigMapper shopConfigMapper;

    @Override
    public ShopConfigVo config() {
        Integer aid = LikeAdminThreadLocal.getAdminId();

        ShopConfig shopConfig = shopConfigMapper.selectOne(new QueryWrapper<ShopConfig>().eq("aid", aid));
        ShopConfigVo shopConfigVo = new ShopConfigVo();
        if (shopConfig == null){
            ShopConfig one = new ShopConfig();
            one.setAid(aid);
            one.setCreateTime(TimeUtils.timestamp());
            shopConfigMapper.insert(one);
            shopConfigVo.setId(one.getId());
            shopConfigVo.setImage(UrlUtils.toAbsoluteUrl("/api/static/default_avatar.png"));
            return shopConfigVo;
        }
        BeanUtils.copyProperties(shopConfig,shopConfigVo);
        return shopConfigVo;
    }

    @Override
    public void save(ShopConfigValidate shopConfigValidate) {
        ShopConfig shopConfig = new ShopConfig();
        shopConfig.setAid(LikeAdminThreadLocal.getAdminId());
        BeanUtils.copyProperties(shopConfigValidate,shopConfig);
        shopConfig.setUpdateTime(TimeUtils.timestamp());
        shopConfigMapper.updateById(shopConfig);
    }

    @Override
    public void change(Integer id, Integer status) {
        Assert.notNull(id,"缺少id参数");
        Assert.notNull(status,"缺少status参数");
        ShopConfig shopConfig = new ShopConfig();
        shopConfig.setId(id);
        shopConfig.setStatus(status);
        shopConfigMapper.updateById(shopConfig);
    }

}
