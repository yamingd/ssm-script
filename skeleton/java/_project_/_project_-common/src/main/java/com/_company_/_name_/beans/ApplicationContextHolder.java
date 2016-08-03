package com._company_._project_.beans;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

/**
 * Created by yamingd on 9/10/15.
 */
@Component
public class ApplicationContextHolder implements ApplicationContextAware, InitializingBean {

    public static ApplicationContext current;

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        current = applicationContext;
    }

    @Override
    public void afterPropertiesSet() throws Exception {

    }

    /**
     * 获取Bean
     *
     * @param type
     * @param name
     * @param <T>
     * @return T
     */
    public static  <T> T bean(Class<T> type, String name){
        T o = current.getBean(name, type);
        return o;
    }

    /**
     * 获取Bean
     * @param type
     * @param <T>
     * @return T
     */
    public static  <T> T bean(Class<T> type){
        T o = current.getBean(type);
        return o;
    }
}
