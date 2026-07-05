package com.mdd.admin.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.mdd.common.entity.article.Article;
import com.mdd.common.mapper.article.ArticleMapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 菜单目录批量加载，避免按分类逐条查菜品（N+1）。
 */
@Service
public class MenuCatalogService {

    @Resource
    private ArticleMapper articleMapper;

    /**
     * 一次查询指定门店全部菜品，按分类 ID 分组并保持 sort 顺序。
     */
    public Map<Integer, List<Article>> loadArticlesByCategory(Integer aid, boolean onlyNotDeleted, boolean onlyShow) {
        QueryWrapper<Article> wrapper = new QueryWrapper<Article>()
                .eq("aid", aid)
                .orderByAsc("sort");
        if (onlyNotDeleted) {
            wrapper.eq("is_delete", 0);
        }
        if (onlyShow) {
            wrapper.eq("is_show", 1);
        }

        List<Article> articles = articleMapper.selectList(wrapper);
        if (articles.isEmpty()) {
            return Collections.emptyMap();
        }

        Map<Integer, List<Article>> grouped = new LinkedHashMap<>();
        for (Article article : articles) {
            grouped.computeIfAbsent(article.getCid(), cid -> new ArrayList<>()).add(article);
        }
        return grouped;
    }
}
