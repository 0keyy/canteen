package com.mdd.admin.task;

import com.mdd.admin.service.app.IUserPointsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * 每月为已认证用户发放积分
 */
@Component
public class UserPointsMonthlyTask {

    private static final Logger log = LoggerFactory.getLogger(UserPointsMonthlyTask.class);

    private final IUserPointsService userPointsService;

    public UserPointsMonthlyTask(IUserPointsService userPointsService) {
        this.userPointsService = userPointsService;
    }

    /** 每月 1 日 01:00 执行 */
    @Scheduled(cron = "0 0 1 1 * ?")
    public void grantMonthlyPoints() {
        log.info("开始执行月度积分发放任务");
        userPointsService.grantMonthlyForAllVerifiedUsers();
        log.info("月度积分发放任务执行完成");
    }
}
