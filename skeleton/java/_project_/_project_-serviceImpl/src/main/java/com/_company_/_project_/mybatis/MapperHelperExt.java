package com._company_._project_.mybatis;

import org.apache.ibatis.builder.annotation.ProviderSqlSource;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.reflection.MetaObject;
import org.apache.ibatis.reflection.SystemMetaObject;
import org.apache.ibatis.session.Configuration;
import tk.mybatis.mapper.mapperhelper.MapperHelper;

import java.util.ArrayList;

/**
 * Created by dengyaming on 8/19/16.
 */
public class MapperHelperExt extends MapperHelper {


    /**
     * 配置指定的接口
     *
     * @param configuration
     * @param mapperInterface
     */
    @Override
    public void processConfiguration(Configuration configuration, Class<?> mapperInterface) {
        String prefix;
        if (mapperInterface != null) {
            prefix = mapperInterface.getCanonicalName();
        } else {
            prefix = "";
        }
        for (Object object : new ArrayList<Object>(configuration.getMappedStatements())) {
            if (object instanceof MappedStatement) {
                MappedStatement ms = (MappedStatement) object;
                if (ms.getId().startsWith(prefix) && isMapperMethod(ms.getId())) {
                    if (ms.getSqlSource() instanceof ProviderSqlSource) {

                        // 检查缓存属性
                        try {
                            checkCache(ms);
                        } catch (Exception e) {
                            throw new RuntimeException(e);
                        }

                        setSqlSource(ms);

                    }
                }
            }
        }
    }

    /**
     * 检查是否配置过缓存
     *
     * @param ms
     * @throws Exception
     */
    private void checkCache(MappedStatement ms) throws Exception {
        if (MybatisCacheBeanFactory.getCache() != null) {
            MetaObject metaObject = SystemMetaObject.forObject(ms);
            metaObject.setValue("cache", MybatisCacheBeanFactory.getCache());
        }
    }

}
