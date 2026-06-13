package com.mdd.common.entity.user;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;

/**
 * 用户积分发放记录
 */
@Data
@TableName("la_user_points_log")
public class UserPointsLog implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 首次认证发放 */
    public static final int SOURCE_FIRST_AUTH = 1;

    /** 月度定时发放 */
    public static final int SOURCE_MONTHLY = 2;

    /** 订单余额支付扣减 */
    public static final int SOURCE_ORDER_PAY = 3;

    /** 后台手工发放 */
    public static final int SOURCE_MANUAL = 4;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private Integer userId;

    private Integer changeAmount;

    private Integer balanceAfter;

    private String grantMonth;

    /** 关联订单ID（余额支付扣减时使用，月度发放为 0） */
    private Integer orderId;

    private Long ruoyiRoleId;

    private String ruoyiRoleName;

    private Integer source;

    private Long createTime;

    @TableField(exist = false)
    private String mobile;

    @TableField(exist = false)
    private String nickName;

    /** 小程序用户昵称（la_user.nickname），与 nickName 不可同名避免 Lombok 冲突 */
    @TableField(exist = false)
    private String userNickname;
}
