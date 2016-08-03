package com._company_._project_.pool;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;

/**
 * Created by user on 12/27/14.
 */
public class AsyncTaskPool implements InitializingBean, DisposableBean{

    public static final Logger logger = LoggerFactory.getLogger(AsyncTaskPool.class);

    private int cores = 0;
    private TrackingThreadPoolTaskExecutor pool;

    @Override
    public void afterPropertiesSet() throws Exception {
        cores = Runtime.getRuntime().availableProcessors();
        this.pool = createPool();
        logger.info("AsyncTaskPool Created.");
    }

    protected TrackingThreadPoolTaskExecutor createPool() {
        TrackingThreadPoolTaskExecutor exe = new TrackingThreadPoolTaskExecutor();
        exe.setMaxPoolSize(this.cores);
        exe.setWaitForTasksToCompleteOnShutdown(true);
        exe.afterPropertiesSet();
        return exe;
    }

    public TrackingThreadPoolTaskExecutor getPool(){
        return pool;
    }

    @Override
    public void destroy() throws Exception {
        pool.destroy();
    }
}
