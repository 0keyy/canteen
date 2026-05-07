package com.mdd.admin.socket;

import org.springframework.stereotype.Component;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.util.*;

@Component
@ServerEndpoint("/backSocket/{aid}")
public class BackSocket {

    private static final Map<String, Session> socketClient = new HashMap<>();

    private String aid; //当前桌面组的id
//    private String uid; //客户端唯一id

    @OnOpen
    public void onOpen(Session session, @PathParam("aid") String aid) {
        this.aid = aid;
        socketClient.put(aid, session);
        System.out.println(aid + "链接成功");
    }

    @OnClose
    public void onClose() {
        socketClient.remove(this.aid);
    }

    @OnMessage
    public void onMessage(Session session, String message) {
    }


    public static void  sendToSeller(String aid, String msg) {
        Session session = socketClient.get(aid);
        if (session != null && session.isOpen()) {
            session.getAsyncRemote().sendText(msg);
        }

    }

}
