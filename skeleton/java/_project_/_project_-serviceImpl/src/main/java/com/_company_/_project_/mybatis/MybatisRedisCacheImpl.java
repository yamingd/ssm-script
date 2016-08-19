package com._company_._project_.mybatis;

import com.argo.redis.RedisBuket;
import org.apache.ibatis.cache.Cache;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.concurrent.locks.ReadWriteLock;

/**
 * Created by dengyaming on 8/19/16.
 */
public class MybatisRedisCacheImpl implements Cache {

    protected Logger logger = LoggerFactory.getLogger(this.getClass());

    private final ReadWriteLock readWriteLock = new DummyReadWriteLock();

    private String id;

    private RedisBuket redisBuket;

    /**
     * id 作为缓存命名空间
     * @param id
     */
    public MybatisRedisCacheImpl(final String id) {
        if (id == null) {
            throw new IllegalArgumentException("Cachestances require an ID");
        }
        this.id = id;
        logger.info("cache-ns: {}", id);
    }

    public MybatisRedisCacheImpl(final String id, RedisBuket redisBuket) {
        this.id = id;
        this.redisBuket = redisBuket;
    }

    @Override
    public String getId() {
        return this.id;
    }

    @Override
    public void putObject(Object key, Object value) {
        if (logger.isDebugEnabled()){
            logger.debug("put, key={}, value={}", key, value);
        }
    }

    @Override
    public Object getObject(Object key) {
        if (logger.isDebugEnabled()){
            logger.debug("get, key={}", key);
        }
        return null;
    }

    @Override
    public Object removeObject(Object key) {
        if (logger.isDebugEnabled()){
            logger.debug("remove, key={}", key);
        }
        return null;
    }

    @Override
    public void clear() {
        if (logger.isDebugEnabled()){
            logger.debug("clear");
        }
    }

    @Override
    public int getSize() {
        if (logger.isDebugEnabled()){
            logger.debug("getSize");
        }
        return 0;
    }

    @Override
    public ReadWriteLock getReadWriteLock() {
        return readWriteLock;
    }

}
