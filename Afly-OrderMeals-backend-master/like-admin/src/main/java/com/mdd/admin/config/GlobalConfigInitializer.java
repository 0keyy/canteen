package com.mdd.admin.config;

import com.mdd.common.config.GlobalConfig;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.Arrays;

/**
 * 根据 Spring Profile 同步全局调试开关，避免生产环境泄露堆栈与内部错误信息。
 */
@Component
public class GlobalConfigInitializer implements ApplicationListener<ContextRefreshedEvent> {

    @Resource
    private Environment environment;

    private boolean initialized;

    @Override
    public void onApplicationEvent(ContextRefreshedEvent event) {
        if (initialized) {
            return;
        }
        initialized = true;
        GlobalConfig.debug = Arrays.asList(environment.getActiveProfiles()).contains("dev");
    }
}
