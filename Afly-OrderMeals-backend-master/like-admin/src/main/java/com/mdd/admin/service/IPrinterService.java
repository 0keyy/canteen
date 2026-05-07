package com.mdd.admin.service;

import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.validate.shop.PrinterValidate;
import com.mdd.admin.vo.shop.PrinterVo;
import com.mdd.common.core.PageResult;

import java.util.List;

public interface IPrinterService {
    /**
     * 打印机列表
     */
    PageResult<PrinterVo> list(PageValidate pageValidate);
    /**
     * 新增
     */
    void add(PrinterValidate printerValidate);
    /**
     * 详情
     */
    PrinterVo detail(Integer id);
}
