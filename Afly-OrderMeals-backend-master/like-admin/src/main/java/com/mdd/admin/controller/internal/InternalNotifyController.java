package com.mdd.admin.controller.internal;

import com.alibaba.fastjson2.JSONObject;
import com.mdd.admin.socket.BackSocket;
import com.mdd.common.core.AjaxResult;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/internal")
public class InternalNotifyController {

    @PostMapping("/notify")
    public AjaxResult<Object> notify(@RequestBody JSONObject body) {
        String aid = body.getString("aid");
        String msg = body.getString("msg");
        if (aid != null && msg != null) {
            BackSocket.sendToSeller(aid, msg);
        }
        return AjaxResult.success();
    }
}
