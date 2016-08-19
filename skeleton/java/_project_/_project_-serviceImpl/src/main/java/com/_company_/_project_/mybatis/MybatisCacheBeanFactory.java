package com._company_._project_.mybatis;

import com.argo.redis.RedisBuket;
import org.apache.ibatis.cache.Cache;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;

/**
 *
 * RedisBucket Bean
 *
 * Created by yaming_deng on 14-8-29.
 */
public class MybatisCacheBeanFactory implements FactoryBean<Cache>, InitializingBean, DisposableBean {

    protected Logger logger = LoggerFactory.getLogger(this.getClass());

    private static Cache instance = null;

    @Autowired
    private RedisBuket redisBuket;

    private String namespace = null;

    @Override
    public void destroy() throws Exception {

    }

    @Override
    public Cache getObject() throws Exception {
        return instance;
    }

    @Override
    public Class<?> getObjectType() {
        return Cache.class;
    }

    @Override
    public boolean isSingleton() {
        return true;
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        instance = new MybatisRedisCacheImpl(namespace, redisBuket);
    }

    /**
     * 获取创建的对象
     *
     * @return RedisBuket
     */
    public static Cache getCache(){
        return instance;
    }

    public RedisBuket getRedisBuket() {
        return redisBuket;
    }

    public String getNamespace() {
        return namespace;
    }

    public void setNamespace(String namespace) {
        this.namespace = namespace;
    }

    public void setRedisBuket(RedisBuket redisBuket) {
        this.redisBuket = redisBuket;
    }
}
