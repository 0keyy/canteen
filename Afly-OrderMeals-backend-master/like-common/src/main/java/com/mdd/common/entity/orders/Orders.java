package com.mdd.common.entity.orders;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;

import java.io.Serializable;
@Data
public class Orders implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(value="id", type= IdType.AUTO)
    private Integer id;         // 主键
    private Integer aid;        // 管理员id
    private String number;      //订单号
    private Integer deskId;     //桌号id
    private Integer userNum;     //用户id
    private Integer type;       //订单类型 0:后台点单1:扫码点单
    private Integer status;     //订单状态0:待下单1:待结帐2:已完成
    private String remark;      //下单备注
    private String amount;      //订单金额
    private Long createTime;    //创建时间
    private Long checkoutTime;  //结账时间
}
