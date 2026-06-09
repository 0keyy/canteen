package com.mdd.admin;

import java.util.LinkedHashMap;
import java.util.Map;

public class AppThreadLocal {

    private static final ThreadLocal<Map<String, Object>> LOCAL = ThreadLocal.withInitial(LinkedHashMap::new);

    public static void put(String key, Object value) {
        LOCAL.get().put(key, value);
    }

    public static Object get(String key) {
        return LOCAL.get().get(key);
    }

    public static Integer getUserId() {
        Object value = get("userId");
        return value == null ? null : Integer.parseInt(value.toString());
    }

    public static void remove() {
        LOCAL.remove();
    }
}
