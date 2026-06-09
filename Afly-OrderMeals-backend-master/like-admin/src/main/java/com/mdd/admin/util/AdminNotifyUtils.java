package com.mdd.admin.util;

import com.alibaba.fastjson2.JSONObject;
import com.mdd.common.util.YmlUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.client.RestTemplate;

public class AdminNotifyUtils {

    private static final Logger log = LoggerFactory.getLogger(AdminNotifyUtils.class);
    private static final RestTemplate REST_TEMPLATE = new RestTemplate();

    private AdminNotifyUtils() {}

    public static void notifySeller(String aid, Object payload) {
        String url = YmlUtils.get("like.admin-notify-url");
        if (url == null || url.isEmpty()) {
            return;
        }
        try {
            JSONObject body = new JSONObject();
            body.put("aid", aid);
            body.put("msg", JSONObject.toJSONString(payload));
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            REST_TEMPLATE.postForEntity(url, new HttpEntity<>(body.toJSONString(), headers), String.class);
        } catch (Exception e) {
            log.warn("通知收银后台失败: {}", e.getMessage());
        }
    }
}
