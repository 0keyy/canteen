package com.mdd.common.mapper.orders;

import com.mdd.common.core.basics.IBaseMapper;
import com.mdd.common.entity.orders.OrdersDish;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.math.BigDecimal;

@Mapper
public interface OrdersDishMapper extends IBaseMapper<OrdersDish> {
    @Update("update la_orders_dish set quantity = quantity + 1 where id = #{id}")
    void dishInc(Integer id);

    @Update("update la_orders_dish set quantity = quantity - 1 where id = #{id}")
    void dishDec(Integer id);

    @Delete("delete from la_orders_dish where id = #{id}")
    void dishDel(Integer id);

    @Select("select sum(quantity*amount) from la_orders_dish where order_id = #{id}")
    BigDecimal compute(Integer id);
}
