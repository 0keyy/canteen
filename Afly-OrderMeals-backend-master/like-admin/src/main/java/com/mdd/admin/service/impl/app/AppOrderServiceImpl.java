package com.mdd.admin.service.impl.app;

import com.alibaba.fastjson2.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.github.yulichang.query.MPJQueryWrapper;
import com.mdd.common.config.GlobalConfig;
import com.mdd.common.entity.article.Article;
import com.mdd.common.entity.article.ArticleCategory;
import com.mdd.common.entity.orders.Orders;
import com.mdd.common.entity.orders.OrdersDish;
import com.mdd.common.entity.shop.ShopConfig;
import com.mdd.common.entity.system.SystemAuthDept;
import com.mdd.common.entity.user.User;
import com.mdd.common.entity.coupon.UserCoupon;
import com.mdd.common.entity.user.UserAddress;
import com.mdd.common.enums.HttpEnum;
import com.mdd.common.exception.BaseException;
import com.mdd.common.mapper.article.ArticleCategoryMapper;
import com.mdd.common.mapper.article.ArticleMapper;
import com.mdd.common.mapper.orders.OrdersDishMapper;
import com.mdd.common.mapper.orders.OrdersMapper;
import com.mdd.common.mapper.shop.ShopConfigMapper;
import com.mdd.common.mapper.system.SystemAuthDeptMapper;
import com.mdd.common.mapper.user.UserAddressMapper;
import com.mdd.common.mapper.user.UserMapper;
import com.mdd.common.mapper.coupon.UserCouponMapper;
import com.mdd.common.util.TimeUtils;
import com.mdd.common.util.UrlUtils;
import com.mdd.admin.enums.app.DiningModeEnum;
import com.mdd.admin.service.app.IAppOrderService;
import com.mdd.admin.service.app.IAppCouponService;
import com.mdd.admin.util.AdminNotifyUtils;
import com.mdd.admin.validate.app.order.CartCreateValidate;
import com.mdd.admin.validate.app.order.DishAddValidate;
import com.mdd.admin.validate.app.order.OrderSubmitValidate;
import com.mdd.admin.vo.app.order.*;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.*;

@Service
public class AppOrderServiceImpl implements IAppOrderService {

    @Resource
    private ShopConfigMapper shopConfigMapper;
    @Resource
    private ArticleMapper articleMapper;
    @Resource
    private ArticleCategoryMapper articleCategoryMapper;
    @Resource
    private OrdersMapper ordersMapper;
    @Resource
    private OrdersDishMapper ordersDishMapper;
    @Resource
    private SystemAuthDeptMapper deskMapper;
    @Resource
    private UserAddressMapper userAddressMapper;
    @Resource
    private UserMapper userMapper;
    @Resource
    private IAppCouponService appCouponService;
    @Resource
    private UserCouponMapper userCouponMapper;

    @Override
    public ShopVo shop(Integer aid) {
        ShopConfig shopConfig = shopConfigMapper.selectOne(new QueryWrapper<ShopConfig>().eq("aid", aid));
        if (shopConfig == null || shopConfig.getStatus() == 0) {
            throw new BaseException(500, "当前商家已暂停营业");
        }
        ShopVo vo = new ShopVo();
        BeanUtils.copyProperties(shopConfig, vo);
        vo.setAid(aid);
        vo.setImage(UrlUtils.toAbsoluteUrl(shopConfig.getImage()));
        return vo;
    }

    @Override
    public List<GoodsVo> menu(Integer aid) {
        List<GoodsVo> goodsVos = new ArrayList<>();
        List<ArticleCategory> categories = articleCategoryMapper.selectList(
                new QueryWrapper<ArticleCategory>().eq("aid", aid).eq("is_delete", 0).orderByAsc("sort"));
        for (ArticleCategory category : categories) {
            List<FoodVo> foods = articleMapper.selectJoinList(FoodVo.class, new MPJQueryWrapper<Article>()
                    .select("t.id as id, t.title as title, t.intro as intro, t.summary as price, t.image as image")
                    .eq("t.aid", aid)
                    .eq("t.cid", category.getId())
                    .eq("t.is_delete", 0)
                    .orderByAsc("t.sort"));
            if (foods.isEmpty()) {
                continue;
            }
            for (FoodVo food : foods) {
                food.setImage(UrlUtils.toAbsoluteUrl(food.getImage()));
            }
            GoodsVo goodsVo = new GoodsVo();
            goodsVo.setName(category.getName());
            goodsVo.setFoods(foods);
            goodsVos.add(goodsVo);
        }
        return goodsVos;
    }

    @Override
    @Transactional
    public Integer cartCreate(CartCreateValidate validate, Integer userId) {
        Orders existing = ordersMapper.selectOne(new QueryWrapper<Orders>()
                .eq("user_id", userId)
                .eq("aid", validate.getAid())
                .eq("status", 0)
                .last("limit 1"));
        if (existing != null) {
            validateDiningMode(validate);
            if (!Objects.equals(existing.getDiningMode(), validate.getDiningMode())
                    || !Objects.equals(existing.getDeskId(), validate.getDiningMode() == DiningModeEnum.DINE_IN ? validate.getDeskId() : 0)) {
                existing.setDiningMode(validate.getDiningMode());
                existing.setSource(validate.getSource() == null ? 2 : validate.getSource());
                existing.setType(mapTypeByDiningMode(validate.getDiningMode()));
                existing.setDeskId(validate.getDiningMode() == DiningModeEnum.DINE_IN ? validate.getDeskId() : 0);
                existing.setUserNum(validate.getDiningMode() == DiningModeEnum.DINE_IN && validate.getUserNum() != null ? validate.getUserNum() : 1);
                ordersMapper.updateById(existing);
            }
            return existing.getId();
        }

        validateDiningMode(validate);

        Orders orders = new Orders();
        orders.setAid(validate.getAid());
        orders.setUserId(userId);
        orders.setNumber(UUID.randomUUID().toString());
        orders.setDiningMode(validate.getDiningMode());
        orders.setSource(validate.getSource() == null ? 2 : validate.getSource());
        orders.setType(mapTypeByDiningMode(validate.getDiningMode()));
        orders.setStatus(0);
        orders.setPayStatus(0);
        orders.setDeskId(validate.getDiningMode() == DiningModeEnum.DINE_IN ? validate.getDeskId() : 0);
        orders.setUserNum(validate.getDiningMode() == DiningModeEnum.DINE_IN && validate.getUserNum() != null ? validate.getUserNum() : 1);
        orders.setCreateTime(TimeUtils.timestamp());
        ordersMapper.insert(orders);
        return orders.getId();
    }

    @Override
    public Map<String, Object> cartHas(Integer userId, Integer aid) {
        Orders orders = ordersMapper.selectOne(new QueryWrapper<Orders>()
                .eq("user_id", userId)
                .eq("aid", aid)
                .eq("status", 0)
                .last("limit 1"));
        if (orders == null) {
            return null;
        }
        List<OrdersDish> dishes = ordersDishMapper.selectList(new QueryWrapper<OrdersDish>().eq("order_id", orders.getId()));
        List<Map<String, Integer>> dishList = new ArrayList<>();
        for (OrdersDish dish : dishes) {
            Map<String, Integer> map = new HashMap<>();
            map.put("id", dish.getId());
            map.put("dishId", dish.getDishId());
            map.put("count", dish.getQuantity());
            dishList.add(map);
        }
        Map<String, Object> result = new HashMap<>();
        result.put("oid", orders.getId());
        result.put("diningMode", orders.getDiningMode());
        result.put("dish", dishList);
        return result;
    }

    @Override
    public Integer dishAdd(DishAddValidate validate) {
        Orders orders = ordersMapper.selectById(validate.getOrderId());
        if (orders == null || orders.getStatus() != 0) {
            throw new BaseException(500, "购物车不可用");
        }
        OrdersDish existing = ordersDishMapper.selectOne(new QueryWrapper<OrdersDish>()
                .eq("order_id", validate.getOrderId())
                .eq("dish_id", validate.getDishId())
                .last("limit 1"));
        if (existing != null) {
            ordersDishMapper.dishInc(existing.getId());
            return existing.getId();
        }
        OrdersDish ordersDish = new OrdersDish();
        ordersDish.setOrderId(validate.getOrderId());
        ordersDish.setDishId(validate.getDishId());
        ordersDish.setQuantity(1);
        ordersDish.setCreateTime(TimeUtils.timestamp());
        Article article = articleMapper.selectById(validate.getDishId());
        if (article == null) {
            throw new BaseException(500, "菜品不存在");
        }
        ordersDish.setAmount(new BigDecimal(article.getSummary()));
        ordersDish.setDishName(article.getTitle());
        ordersDish.setDishImage(article.getImage());
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
    public void toEmpty(Integer orderId, Integer userId) {
        Orders orders = getOwnedOrder(orderId, userId);
        if (orders.getStatus() != 0) {
            throw new BaseException(500, "当前订单不可清空");
        }
        ordersDishMapper.delete(new QueryWrapper<OrdersDish>().eq("order_id", orderId));
    }

    @Override
    @Transactional
    public OrderDetailVo submit(OrderSubmitValidate validate, Integer userId) {
        Orders orders = getOwnedOrder(validate.getOrderId(), userId);
        if (orders.getStatus() != 0) {
            throw new BaseException(500, "订单已提交");
        }

        BigDecimal dishAmount = ordersDishMapper.compute(validate.getOrderId());
        if (dishAmount == null || dishAmount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BaseException(500, "请先选择菜品");
        }

        ShopConfig shopConfig = shopConfigMapper.selectOne(new QueryWrapper<ShopConfig>().eq("aid", orders.getAid()));
        BigDecimal deliveryFee = BigDecimal.ZERO;
        if (orders.getDiningMode() == DiningModeEnum.DELIVERY) {
            deliveryFee = shopConfig.getDeliveryFee() == null ? BigDecimal.ZERO : shopConfig.getDeliveryFee();
            if (validate.getAddressId() == null) {
                throw new BaseException(500, "请选择收货地址");
            }
            UserAddress address = userAddressMapper.selectOne(new QueryWrapper<UserAddress>()
                    .eq("id", validate.getAddressId())
                    .eq("user_id", userId)
                    .eq("is_delete", 0));
            if (address == null) {
                throw new BaseException(500, "收货地址不存在");
            }
            orders.setAddressId(address.getId());
            orders.setAddressSnapshot(buildAddressSnapshot(address));
            orders.setContactName(address.getContactName());
            orders.setContactMobile(address.getContactMobile());
        } else {
            User user = userMapper.selectById(userId);
            orders.setContactName(validate.getContactName() != null ? validate.getContactName() : user.getNickname());
            orders.setContactMobile(validate.getContactMobile() != null ? validate.getContactMobile() : user.getMobile());
        }

        if (orders.getDiningMode() == DiningModeEnum.DINE_IN
                || orders.getDiningMode() == DiningModeEnum.TAKEOUT) {
            orders.setPickupCode(generatePickupCode());
        }

        BigDecimal totalAmount = dishAmount.add(deliveryFee);

        // 优惠券处理
        BigDecimal couponDiscount = BigDecimal.ZERO;
        if (validate.getCouponId() != null && validate.getCouponId() > 0) {
            UserCoupon userCoupon = userCouponMapper.selectById(validate.getCouponId());
            if (userCoupon == null || !userCoupon.getUserId().equals(userId)) {
                throw new BaseException(500, "优惠券不存在");
            }
            if (userCoupon.getStatus() != 1) {
                throw new BaseException(500, "优惠券不可用");
            }
            long nowCoupon = TimeUtils.timestamp();
            if (userCoupon.getUseStartTime() > 0 && nowCoupon < userCoupon.getUseStartTime()) {
                throw new BaseException(500, "优惠券尚未生效");
            }
            if (userCoupon.getUseEndTime() > 0 && nowCoupon > userCoupon.getUseEndTime()) {
                throw new BaseException(500, "优惠券已过期");
            }

            // 计算优惠金额
            couponDiscount = appCouponService.bestForOrder(validate.getOrderId(), userId).getDiscountAmount();
            if (couponDiscount == null || couponDiscount.compareTo(BigDecimal.ZERO) <= 0) {
                throw new BaseException(500, "该优惠券不适用于当前订单");
            }

            // 标记券已使用
            userCoupon.setStatus(2);
            userCoupon.setUseTime(nowCoupon);
            userCoupon.setOrderId(validate.getOrderId());
            userCouponMapper.updateById(userCoupon);

            orders.setCouponId(validate.getCouponId());
            orders.setCouponDiscount(couponDiscount);
            totalAmount = totalAmount.subtract(couponDiscount).max(BigDecimal.ZERO);
        }

        long now = TimeUtils.timestamp();
        orders.setRemark(validate.getRemark());
        orders.setAmount(totalAmount.toPlainString());
        orders.setDeliveryFee(deliveryFee);
        orders.setPayAmount(totalAmount);
        orders.setSubmitTime(now);

        // 优惠券全额抵扣时无需支付，直接标记已支付
        if (totalAmount.compareTo(BigDecimal.ZERO) <= 0) {
            orders.setPayStatus(1);
            orders.setStatus(1);
            orders.setPayTime(now);
            orders.setPayType("coupon");
            ordersMapper.updateById(orders);
            OrderDetailVo vo = buildDetailVo(orders);
            vo.setNeedPay(false);
            return vo;
        }

        orders.setPayStatus(0);
        orders.setStatus(4);
        ordersMapper.updateById(orders);

        OrderDetailVo vo = buildDetailVo(orders);
        vo.setNeedPay(true);
        return vo;
    }

    @Override
    public List<OrderListVo> list(Integer userId) {
        List<Orders> orders = ordersMapper.selectList(new QueryWrapper<Orders>()
                .eq("user_id", userId)
                .and(w -> w.gt("submit_time", 0).or().ne("status", 0))
                .orderByDesc("id"));
        List<OrderListVo> list = new ArrayList<>();
        for (Orders order : orders) {
            OrderListVo vo = new OrderListVo();
            BeanUtils.copyProperties(order, vo);
            vo.setCreateTime(TimeUtils.timestampToDate(order.getCreateTime()));
            list.add(vo);
        }
        return list;
    }

    @Override
    public OrderDetailVo detail(Integer orderId, Integer userId) {
        Orders orders = getOwnedOrder(orderId, userId);
        return buildDetailVo(orders);
    }

    @Override
    @Transactional
    public void cancel(Integer orderId, Integer userId, String reason) {
        Orders orders = getOwnedOrder(orderId, userId);
        if (orders.getStatus() == 2) {
            throw new BaseException(500, "订单已完成，无法取消");
        }
        if (orders.getPayStatus() != null && orders.getPayStatus() == 1 && orders.getStatus() == 1) {
            throw new BaseException(500, "订单制作中，无法取消");
        }
        orders.setStatus(3);
        orders.setPayStatus(4);
        orders.setCancelReason(reason);
        orders.setCancelTime(TimeUtils.timestamp());
        ordersMapper.updateById(orders);
    }

    private Orders getOwnedOrder(Integer orderId, Integer userId) {
        Orders orders = ordersMapper.selectById(orderId);
        if (orders == null || !orders.getUserId().equals(userId)) {
            throw new BaseException(HttpEnum.NO_PERMISSION.getCode(), "无权操作该订单");
        }
        return orders;
    }

    private void validateDiningMode(CartCreateValidate validate) {
        ShopConfig shop = shopConfigMapper.selectOne(new QueryWrapper<ShopConfig>().eq("aid", validate.getAid()));
        if (validate.getDiningMode() == DiningModeEnum.DINE_IN) {
            if (validate.getDeskId() == null) {
                throw new BaseException(500, "堂食请选择桌号");
            }
            SystemAuthDept desk = deskMapper.selectById(validate.getDeskId());
            if (desk == null || desk.getIsStop() == 1) {
                throw new BaseException(HttpEnum.FRONT_DESK_ERROR.getCode(), HttpEnum.FRONT_DESK_ERROR.getMsg());
            }
        } else if (validate.getDiningMode() == DiningModeEnum.TAKEOUT) {
            if (shop.getTakeoutEnable() != null && shop.getTakeoutEnable() == 0) {
                throw new BaseException(500, "当前店铺未开启外带");
            }
        } else if (validate.getDiningMode() == DiningModeEnum.DELIVERY) {
            if (shop.getDeliveryEnable() == null || shop.getDeliveryEnable() == 0) {
                throw new BaseException(500, "当前店铺未开启外卖");
            }
        }
    }

    private int mapTypeByDiningMode(Integer diningMode) {
        if (diningMode == DiningModeEnum.TAKEOUT) {
            return 3;
        }
        if (diningMode == DiningModeEnum.DELIVERY) {
            return 4;
        }
        return 2;
    }

    private String buildAddressSnapshot(UserAddress address) {
        JSONObject json = new JSONObject();
        json.put("contactName", address.getContactName());
        json.put("contactMobile", address.getContactMobile());
        json.put("province", address.getProvince());
        json.put("city", address.getCity());
        json.put("district", address.getDistrict());
        json.put("detail", address.getDetail());
        return json.toJSONString();
    }

    private String generatePickupCode() {
        return String.format("%04d", new Random().nextInt(10000));
    }

    private OrderDetailVo buildDetailVo(Orders orders) {
        OrderDetailVo vo = new OrderDetailVo();
        BeanUtils.copyProperties(orders, vo);
        vo.setCreateTime(TimeUtils.timestampToDate(orders.getCreateTime()));
        vo.setSubmitTime(orders.getSubmitTime() != null && orders.getSubmitTime() > 0
                ? TimeUtils.timestampToDate(orders.getSubmitTime()) : "");
        if (orders.getDeskId() != null && orders.getDeskId() > 0) {
            SystemAuthDept desk = deskMapper.selectById(orders.getDeskId());
            if (desk != null) {
                vo.setDeskName(desk.getName());
            }
        }
        List<OrdersDish> dishes = ordersDishMapper.selectList(new QueryWrapper<OrdersDish>().eq("order_id", orders.getId()));
        List<OrderDishVo> dishVos = new ArrayList<>();
        for (OrdersDish dish : dishes) {
            OrderDishVo dishVo = new OrderDishVo();
            BeanUtils.copyProperties(dish, dishVo);
            dishVo.setDishImage(UrlUtils.toAbsoluteUrl(dish.getDishImage()));
            dishVos.add(dishVo);
        }
        vo.setDishes(dishVos);
        return vo;
    }

    public void markPaid(Orders orders) {
        long now = TimeUtils.timestamp();
        Orders update = new Orders();
        update.setId(orders.getId());
        update.setPayStatus(1);
        update.setStatus(1);
        update.setPayTime(now);
        if (orders.getPayType() != null && !orders.getPayType().isEmpty()) {
            update.setPayType(orders.getPayType());
        }
        if (orders.getPayAmount() != null) {
            update.setPayAmount(orders.getPayAmount());
        }
        ordersMapper.updateById(update);
        orders.setPayStatus(1);
        orders.setStatus(1);
        orders.setPayTime(now);
        AdminNotifyUtils.notifySeller(orders.getAid().toString(), orders);
    }
}
