package com.mdd.common.config;

/**
 * 多数据源标识
 * <p>
 * 在 Service 或 Mapper 上使用 {@code @DS(DataSourceConstant.RUOYI)} 切换至 ruoyi 库。
 * 未标注时默认使用 master（like_admin）。
 */
public final class DataSourceConstant {

    /** 主库 like_admin */
    public static final String MASTER = "master";

    /** 若依库 ruoyi */
    public static final String RUOYI = "ruoyi";

    private DataSourceConstant() {
    }
}
