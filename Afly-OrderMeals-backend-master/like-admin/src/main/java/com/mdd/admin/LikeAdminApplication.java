package com.mdd.admin;

import org.mybatis.spring.annotation.MapperScan;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.data.redis.RedisRepositoriesAutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.socket.server.standard.ServerEndpointExporter;

import java.net.InetAddress;
import java.net.UnknownHostException;

/**
 * 启动器
 */
@Configuration
@ComponentScan(basePackages = {"com.mdd"})
@MapperScan(basePackages = {"com.mdd.*.mapper"})
@EnableTransactionManagement
@SpringBootApplication(exclude = {RedisRepositoriesAutoConfiguration.class})
public class LikeAdminApplication {

    private static final Logger log = LoggerFactory.getLogger(LikeAdminApplication.class);

    public static void main(String[] args) throws UnknownHostException {
        SpringApplication app = new SpringApplication(LikeAdminApplication.class);
        app.run(args);

        log.info("========================================");
        log.info("点餐后台应用启动成功！！！");
        log.info("========================================");
    }

    @Bean
    public ServerEndpointExporter serverEndpointExporter() {
        return new ServerEndpointExporter();
    }
}
