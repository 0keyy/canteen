package com.mdd.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Assert;
import com.github.yulichang.query.MPJQueryWrapper;
import com.mdd.admin.LikeAdminThreadLocal;
import com.mdd.admin.service.IOrderService;
import com.mdd.admin.validate.order.DishAddValidate;
import com.mdd.admin.validate.order.OrderSubmitValidate;
import com.mdd.admin.validate.order.OrdersCreateValidate;
import com.mdd.admin.vo.order.OrderDeskVo;
import com.mdd.admin.vo.order.OrderDishCateVo;
import com.mdd.admin.vo.order.OrderDishVo;
import com.mdd.common.config.GlobalConfig;
import com.mdd.common.entity.article.Article;
import com.mdd.common.entity.article.ArticleCategory;
import com.mdd.common.entity.orders.Orders;
import com.mdd.common.entity.orders.OrdersDish;
import com.mdd.common.entity.system.SystemAuthDept;
import com.mdd.common.mapper.article.ArticleCategoryMapper;
import com.mdd.common.mapper.article.ArticleMapper;
import com.mdd.common.mapper.orders.OrdersDishMapper;
import com.mdd.common.mapper.orders.OrdersMapper;
import com.mdd.common.mapper.system.SystemAuthDeptMapper;
import com.mdd.common.util.TimeUtils;
import com.mdd.common.util.UrlUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@Service

public class OrderServiceImpl implements IOrderService {

    @Resource
    private SystemAuthDeptMapper systemAuthDeptMapper;
    @Resource
    private ArticleCategoryMapper articleCategoryMapper;
    @Resource
    private ArticleMapper articleMapper;
    @Resource
    private OrdersMapper ordersMapper;
    @Resource
    private OrdersDishMapper ordersDishMapper;

    @Override
    public List<OrderDeskVo> list() {
        Integer aid = LikeAdminThreadLocal.getAdminId();

        MPJQueryWrapper<SystemAuthDept> mpjQueryWrapper = new MPJQueryWrapper<SystemAuthDept>()
                .selectAll(SystemAuthDept.class)
                .select("post.name as area")
                .innerJoin("?_system_auth_post post ON post.id=t.area_id".replace("?_", GlobalConfig.tablePrefix))
                .eq("t.is_delete", 0)
                .eq("t.is_stop",0)
                .eq("t.aid", aid)
                .orderByDesc(Arrays.asList("t.sort", "t.id"));

        List<OrderDeskVo> orderDeskVos = systemAuthDeptMapper.selectJoinList(OrderDeskVo.class, mpjQueryWrapper);
        for (OrderDeskVo orderDeskVo : orderDeskVos) {
            orderDeskVo.setCreateTime(TimeUtils.timestampToDate(orderDeskVo.getCreateTime()));
            orderDeskVo.setUpdateTime(TimeUtils.timestampToDate(orderDeskVo.getUpdateTime()));
        }
        return orderDeskVos;
    }

    @Override
    public List<OrderDishCateVo> dishCate() {
        Integer aid = LikeAdminThreadLocal.getAdminId();
        QueryWrapper<ArticleCategory> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("aid",aid);
        queryWrapper.eq("is_delete",0);
        queryWrapper.eq("is_show",1);
        List<ArticleCategory> articleCategories = articleCategoryMapper.selectList(queryWrapper);
        List<OrderDishCateVo> orderDishCateVos = new ArrayList<>();
        for (ArticleCategory articleCategory : articleCategories){
            OrderDishCateVo orderDishCateVo = new OrderDishCateVo();
            orderDishCateVo.setName(articleCategory.getName());
            orderDishCateVo.setSort(articleCategory.getSort());
            orderDishCateVo.setId(articleCategory.getId());
            orderDishCateVos.add(orderDishCateVo);
        }
        return orderDishCateVos;

    }

    @Override
    public List<OrderDishVo> dishList() {
        Integer aid = LikeAdminThreadLocal.getAdminId();

        MPJQueryWrapper<Article> mpjQueryWrapper = new MPJQueryWrapper<Article>()
                .selectAll(Article.class)
                .select("ac.name as category")
                .innerJoin("?_article_category ac ON ac.id=t.cid".replace("?_", GlobalConfig.tablePrefix))
                .eq("t.is_delete", 0)
                .eq("t.aid",aid)
                .eq("t.is_show",1)
                .orderByDesc(Arrays.asList("t.sort", "t.id"));

        List<OrderDishVo> orderDishVos = articleMapper.selectJoinList(OrderDishVo.class, mpjQueryWrapper);
        for (OrderDishVo orderDishVo : orderDishVos){
            orderDishVo.setImage(UrlUtils.toAbsoluteUrl(orderDishVo.getImage()));
            orderDishVo.setCreateTime(TimeUtils.timestampToDate(orderDishVo.getCreateTime()));
            orderDishVo.setUpdateTime(TimeUtils.timestampToDate(orderDishVo.getUpdateTime()));
        }
        return orderDishVos;

    }

    /**
     * 创建订单
     * @param ordersCreateValidate
     */
    @Override
    public Integer ordersCreate(OrdersCreateValidate ordersCreateValidate) {
        Orders orders = new Orders();
        orders.setUserNum(ordersCreateValidate.getUserNum());//就餐人数
        orders.setNumber(UUID.randomUUID().toString());
        orders.setDeskId(ordersCreateValidate.getDeskId());//桌号id
        orders.setType(ordersCreateValidate.getType());
        orders.setStatus(0);//待下单状态
        orders.setAid(LikeAdminThreadLocal.getAdminId());
        orders.setCreateTime(TimeUtils.timestamp());
        ordersMapper.insert(orders);
        return orders.getId();
    }

    @Override
    public Integer dishAdd(DishAddValidate dishAddValidate) {
        OrdersDish ordersDish = new OrdersDish();
        ordersDish.setDishId(dishAddValidate.getDishId());
        ordersDish.setOrderId(dishAddValidate.getOrderId());
        ordersDish.setQuantity(1);
        ordersDish.setCreateTime(TimeUtils.timestamp());
        Article one = articleMapper.selectOne(new QueryWrapper<Article>().eq("id", dishAddValidate.getDishId()));
        ordersDish.setAmount(new BigDecimal(one.getSummary()));
        ordersDishMapper.insert(ordersDish);
        return ordersDish.getId();
    }

    @Override
    public void dishInc(Integer id) {
        ordersDishMapper.dishInc(id);
    }

    @Override
    public void dishDec(Integer id) {
        ordersDishMapper.dishDec(id);
    }

    @Override
    public void dishDel(Integer id) {
        ordersDishMapper.dishDel(id);
    }

    @Override
    public void toEmpty(Integer id) {
        ordersDishMapper.delete(new QueryWrapper<OrdersDish>().eq("order_id",id));
    }

    @Override
    public void submit(OrderSubmitValidate orderSubmitValidate) {
        Orders orders = new Orders();
        orders.setId(orderSubmitValidate.getNumber());
        orders.setStatus(1);//待结帐就餐中
        orders.setRemark(orderSubmitValidate.getRemark());
        orders.setAmount(ordersDishMapper.compute(orderSubmitValidate.getNumber()).toString());
        ordersMapper.updateById(orders);
    }

    @Override
    public void checkout(Integer did) {
        Assert.notNull(did,"结账失败失败，缺少id值");
        ordersMapper.updateOrdersStatus(did,TimeUtils.timestamp());
    }


}
