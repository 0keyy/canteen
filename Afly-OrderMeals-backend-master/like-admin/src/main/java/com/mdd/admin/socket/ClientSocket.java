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
@ServerEndpoint("/clientSocket/{did}")
public class ClientSocket {

    private static final Map<String, Map<String,Session>> socketClient = new HashMap<>();

    private String did; //当前桌面组的id
    private String uid; //客户端唯一id

    @OnOpen
    public void onOpen(Session session, @PathParam("did") String did){
        Map<String, Session> sessionMap = socketClient.get(did);
        this.did = did;
        this.uid = UUID.randomUUID().toString();
        if (sessionMap == null) {
            Map<String,Session> group = new HashMap<>();
            group.put(this.uid,session);
            socketClient.put(did,group);
        }else {
            sessionMap.put(this.uid,session);
        }
    }

    @OnClose
    public void onClose(){
        Map<String, Session> sessionMap = socketClient.get(did);
        sessionMap.remove(this.uid);
        if (sessionMap.isEmpty()){
            socketClient.remove(this.did);
        }
    }

    @OnMessage
    public void onMessage(Session session,String message){
        //向当前所在餐桌发送消息
        sendToDesks(this.did,message);
    }

    public void sendToDesks(String did,String msg){
        Map<String, Session> sessionMap = socketClient.get(did);
        Collection<Session> values = sessionMap.values();
        Iterator<Session> iterator = values.iterator();
        while (iterator.hasNext()){
            Session session = iterator.next();
            session.getAsyncRemote().sendText(msg);
        }
    }

}
