package com.mdd.common.mapper.orders;

import com.mdd.common.core.basics.IBaseMapper;
import com.mdd.common.entity.orders.Orders;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface OrdersMapper extends IBaseMapper<Orders> {

    @Update("update la_orders set status=2,checkout_time=#{checkoutTime} where desk_id=#{did} and status!=2")
    void updateOrdersStatus(@Param("did") Integer did,@Param("checkoutTime") Long checkoutTime);
}
