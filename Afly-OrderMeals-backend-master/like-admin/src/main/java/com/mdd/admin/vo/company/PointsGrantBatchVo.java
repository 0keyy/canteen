package com.mdd.admin.vo.company;

import lombok.Data;

import java.io.Serializable;

@Data
public class PointsGrantBatchVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer totalUsers;
    private Integer successCount;
    private Integer totalAmount;
}
