package com.mdd.admin.service.impl;

import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.baomidou.mybatisplus.core.toolkit.Assert;
import com.mdd.admin.service.IDecoratePageService;
import com.mdd.admin.validate.DecoratePageValidate;
import com.mdd.admin.vo.decorate.DecoratePageVo;
import com.mdd.common.entity.DecoratePage;
import com.mdd.common.mapper.DecoratePageMapper;
import com.mdd.common.util.UrlUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class DecoratePageServiceImpl implements IDecoratePageService {

    @Resource
    DecoratePageMapper decoratePageMapper;

    /**
     * 页面装修详情
     *
     * @author fzr
     * @param id 主键
     * @return DecoratePageVo
     */
    @Override
    public DecoratePageVo detail(Integer id) {
        DecoratePage decoratePage = decoratePageMapper.selectById(id);
        Assert.notNull(decoratePage, "数据不存在!");

        DecoratePageVo vo = new DecoratePageVo();
        vo.setId(decoratePage.getId());
        vo.setPageType(decoratePage.getPageType());
        vo.setPageData(decoratePage.getPageData());
        return vo;
    }

    @Override
    public DecoratePageVo detailForApp(Integer id) {
        DecoratePageVo vo = detail(id);
        vo.setPageData(resolveDecorateImages(vo.getPageData()));
        return vo;
    }

    private String resolveDecorateImages(String pageDataJson) {
        if (pageDataJson == null || pageDataJson.isEmpty()) {
            return pageDataJson;
        }
        JSONArray widgets = JSONArray.parseArray(pageDataJson);
        for (int i = 0; i < widgets.size(); i++) {
            JSONObject widget = widgets.getJSONObject(i);
            JSONObject content = widget.getJSONObject("content");
            if (content == null) {
                continue;
            }
            JSONArray data = content.getJSONArray("data");
            if (data != null) {
                for (int j = 0; j < data.size(); j++) {
                    JSONObject item = data.getJSONObject(j);
                    if (item.containsKey("image")) {
                        item.put("image", UrlUtils.toAbsoluteUrl(item.getString("image")));
                    }
                }
            }
            if (content.containsKey("qrcode")) {
                content.put("qrcode", UrlUtils.toAbsoluteUrl(content.getString("qrcode")));
            }
        }
        return widgets.toJSONString();
    }

    /**
     * 页面装修保存
     *
     * @author fzr
     * @param decoratePageValidate 参数
     */
    @Override
    public void save(DecoratePageValidate decoratePageValidate) {
        DecoratePage decoratePage = decoratePageMapper.selectById(decoratePageValidate.getId());
        Assert.notNull(decoratePage, "数据不存在!");

        decoratePage.setPageData(decoratePageValidate.getPageData());
        decoratePage.setUpdateTime(System.currentTimeMillis() / 1000);
        decoratePageMapper.updateById(decoratePage);
    }

}
