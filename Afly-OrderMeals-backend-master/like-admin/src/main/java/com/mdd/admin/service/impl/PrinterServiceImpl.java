package com.mdd.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.Assert;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.github.yulichang.query.MPJQueryWrapper;
import com.mdd.admin.LikeAdminThreadLocal;
import com.mdd.admin.service.IPrinterService;
import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.validate.shop.PrinterValidate;
import com.mdd.admin.vo.shop.PrinterVo;
import com.mdd.common.core.PageResult;
import com.mdd.common.entity.shop.Printer;
import com.mdd.common.mapper.shop.PrinterMapper;
import com.mdd.common.util.TimeUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
@Service
public class PrinterServiceImpl implements IPrinterService {
    @Resource
    private PrinterMapper printerMapper;

    @Override
    public PageResult<PrinterVo> list(PageValidate pageValidate) {
        Integer pageNo   = pageValidate.getPageNo();
        Integer pageSize = pageValidate.getPageSize();
        Integer aid = LikeAdminThreadLocal.getAdminId();

        IPage<Printer> page = new Page<>(pageNo,pageSize);
        IPage<Printer> data = printerMapper.selectPage(page, new QueryWrapper<Printer>().eq("aid", aid).eq("is_delete",0));
        List<Printer> records = data.getRecords();
        List<PrinterVo> printerVos = new ArrayList<>();
        for (Printer printer : records){
            PrinterVo printerVo = new PrinterVo();
            BeanUtils.copyProperties(printer,printerVo);
            printerVos.add(printerVo);
        }
        return PageResult.pageHelper(printerVos);
    }

    @Override
    public void add(PrinterValidate printerValidate) {
        Printer printer = new Printer();
        BeanUtils.copyProperties(printerValidate,printer);
        printer.setAid(LikeAdminThreadLocal.getAdminId());
        printer.setCreateTime(TimeUtils.timestamp());
        printerMapper.insert(printer);
    }

    @Override
    public PrinterVo detail(Integer id) {
        Assert.notNull(id,"参数错误");
        Printer printer = printerMapper.selectById(id);
        PrinterVo printerVo = new PrinterVo();
        BeanUtils.copyProperties(printer,printerVo);
        return printerVo;
    }
}
