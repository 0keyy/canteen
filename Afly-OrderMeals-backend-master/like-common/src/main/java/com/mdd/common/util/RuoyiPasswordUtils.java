package com.mdd.common.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * 若依密码校验（BCrypt）
 */
public final class RuoyiPasswordUtils {

    private static final BCryptPasswordEncoder ENCODER = new BCryptPasswordEncoder();

    private RuoyiPasswordUtils() {
    }

    public static boolean matches(String rawPassword, String encodedPassword) {
        if (rawPassword == null || encodedPassword == null || encodedPassword.isEmpty()) {
            return false;
        }
        return ENCODER.matches(rawPassword, encodedPassword);
    }
}
