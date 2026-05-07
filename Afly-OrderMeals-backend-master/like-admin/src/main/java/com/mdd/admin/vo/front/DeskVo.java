package com.mdd.admin.vo.front;

import lombok.Data;

import java.io.Serializable;
@Data
public class DeskVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;        // 主键
    private String area;       // 区域
    private String name;       // 名称
    private Integer num;       // 最大就餐人数
}
