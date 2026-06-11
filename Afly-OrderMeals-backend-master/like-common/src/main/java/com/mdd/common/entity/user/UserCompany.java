package com.mdd.common.entity.user;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;

/**
 * 小程序用户公司认证
 */
@Data
@TableName("la_user_company")
public class UserCompany implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private Integer userId;

    private Long ruoyiUserId;

    private Long deptId;

    private String deptName;

    private String userName;

    private String nickName;

    private Long authTime;

    private Long createTime;

    private Long updateTime;

    @TableField(exist = false)
    private String mobile;

    @TableField(exist = false)
    private String nickname;

    @TableField(exist = false)
    private Integer balance;
}
