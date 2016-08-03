package com._company_._project_.factory;

import com._company_._project_.pool.AsyncTaskPool;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.beans.factory.InitializingBean;

/**
 *
 * RedisBucket Bean
 *
 * Created by yaming_deng on 14-8-29.
 */
public class AsyncTaskPoolFactory implements FactoryBean<AsyncTaskPool>, InitializingBean, DisposableBean {

    protected Logger logger = LoggerFactory.getLogger(this.getClass());

    private AsyncTaskPool instance = null;

    @Override
    public void destroy() throws Exception {

    }

    @Override
    public AsyncTaskPool getObject() throws Exception {
        return instance;
    }

    @Override
    public Class<?> getObjectType() {
        return AsyncTaskPool.class;
    }

    @Override
    public boolean isSingleton() {
        return true;
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        instance = new AsyncTaskPool();
        instance.afterPropertiesSet();
    }

}
