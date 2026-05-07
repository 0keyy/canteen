package com.mdd.admin.service.impl;

import com.alibaba.fastjson2.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.github.yulichang.query.MPJQueryWrapper;
import com.mdd.admin.service.IFrontService;
import com.mdd.admin.socket.BackSocket;
import com.mdd.admin.validate.front.FrontOrdersCreateValidate;
import com.mdd.admin.validate.order.OrderSubmitValidate;
import com.mdd.admin.vo.front.DeskVo;
import com.mdd.admin.vo.front.FoodsVo;
import com.mdd.admin.vo.front.GoodsVo;
import com.mdd.admin.vo.shop.ShopConfigVo;
import com.mdd.common.entity.article.Article;
import com.mdd.common.entity.article.ArticleCategory;
import com.mdd.common.entity.orders.Orders;
import com.mdd.common.entity.orders.OrdersDish;
import com.mdd.common.entity.shop.ShopConfig;
import com.mdd.common.entity.system.SystemAuthDept;
import com.mdd.common.enums.HttpEnum;
import com.mdd.common.exception.BaseException;
import com.mdd.common.mapper.article.ArticleCategoryMapper;
import com.mdd.common.mapper.article.ArticleMapper;
import com.mdd.common.mapper.orders.OrdersDishMapper;
import com.mdd.common.mapper.orders.OrdersMapper;
import com.mdd.common.mapper.shop.ShopConfigMapper;
import com.mdd.common.mapper.system.SystemAuthDeptMapper;
import com.mdd.common.util.TimeUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

@Service
public class FrontServiceImpl implements IFrontService {

    @Resource
    private ArticleMapper articleMapper;
    @Resource
    private ArticleCategoryMapper articleCategoryMapper;
    @Resource
    private ShopConfigMapper shopConfigMapper;
    @Resource
    private SystemAuthDeptMapper deskMapper;
    @Resource
    private OrdersMapper ordersMapper;
    @Resource
    private OrdersDishMapper ordersDishMapper;

    @Override
    public List<GoodsVo> goods(Integer aid) {
        List<GoodsVo> goodsVos = new ArrayList<>();
        List<ArticleCategory> categories = articleCategoryMapper.selectList(new QueryWrapper<ArticleCategory>().eq("aid", aid));
        for (ArticleCategory articleCategory : categories) {
            List<FoodsVo> foodsVos = articleMapper.selectJoinList(FoodsVo.class, new MPJQueryWrapper<Article>()
                    .select("t.id as id, t.title as title, t.intro as intro, t.summary as price, t.image as image")
                    .eq("t.aid", aid)
                    .eq("t.cid", articleCategory.getId()));
            GoodsVo goodsVo = new GoodsVo();
            goodsVo.setName(articleCategory.getName());
            goodsVo.setFoods(foodsVos);
            goodsVos.add(goodsVo);
        }
        return goodsVos;
    }

    @Override
    public ShopConfigVo seller(Integer id) {
        ShopConfig shopConfig = shopConfigMapper.selectOne(new QueryWrapper<ShopConfig>().eq("aid", id));
        if (shopConfig.getStatus() == 0) throw new BaseException(500,"当前商家已暂停营业");
        ShopConfigVo shopConfigVo = new ShopConfigVo();
        BeanUtils.copyProperties(shopConfig,shopConfigVo);
        return shopConfigVo;
    }

    @Override
    public DeskVo desk(Integer did) {
        SystemAuthDept desk = deskMapper.selectOne(new QueryWrapper<SystemAuthDept>().eq("id", did));
        if (desk.getIsStop() == 1){
            throw new BaseException(HttpEnum.FRONT_DESK_ERROR.getCode(),HttpEnum.FRONT_DESK_ERROR.getMsg());
        }
        DeskVo deskVo = new DeskVo();
        BeanUtils.copyProperties(desk,deskVo);
        return deskVo;
    }

    @Override
    public Integer create(FrontOrdersCreateValidate ordersCreateValidate) {
        Orders one = ordersMapper.selectOne(new QueryWrapper<Orders>().eq("desk_id", ordersCreateValidate.getDeskId()).eq("status", 0));
        if (one != null) return one.getId();
        Orders orders = new Orders();
        orders.setUserNum(ordersCreateValidate.getUserNum());//就餐人数
        orders.setNumber(UUID.randomUUID().toString());
        orders.setDeskId(ordersCreateValidate.getDeskId());//桌号id
        orders.setType(ordersCreateValidate.getType());
        orders.setStatus(0);//待下单状态
        orders.setAid(ordersCreateValidate.getAid());
        orders.setCreateTime(TimeUtils.timestamp());
        ordersMapper.insert(orders);
        BackSocket.sendToSeller(orders.getAid().toString(),JSONObject.toJSONString(orders));
        return orders.getId();
    }

    @Override
    public Object has(Integer did) {
        Orders orders = ordersMapper.selectOne(new QueryWrapper<Orders>().eq("desk_id", did).eq("status", 0));
        if (orders == null){
            return null;
        }
        List<OrdersDish> ordersDishes = ordersDishMapper.selectList(new QueryWrapper<OrdersDish>().eq("order_id", orders.getId()));
        List<Map<String,Integer>> list = new ArrayList<>();
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("oid",orders.getId());
        for (OrdersDish ordersDish : ordersDishes){
            Map<String,Integer> map = new HashMap<>();
            map.put("id",ordersDish.getId());
            map.put("dishId",ordersDish.getDishId());
            map.put("count",ordersDish.getQuantity());
            list.add(map);
        }
        jsonObject.put("dish",list);
        return jsonObject;
    }
    @Override
    public void submit(OrderSubmitValidate orderSubmitValidate) {
        Orders orders = new Orders();
        orders.setId(orderSubmitValidate.getNumber());
        orders.setStatus(1);//待结帐就餐中
        orders.setRemark(orderSubmitValidate.getRemark());
        orders.setAmount(ordersDishMapper.compute(orderSubmitValidate.getNumber()).toString());
        ordersMapper.updateById(orders);
        Orders o = ordersMapper.selectById(orders);
        BackSocket.sendToSeller(o.getAid().toString(),JSONObject.toJSONString(o));
    }
}
