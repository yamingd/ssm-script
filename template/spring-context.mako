<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xsi:schemaLocation="
       http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
       http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-3.2.xsd
       http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-3.1.xsd
       http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx-3.2.xsd
       ">

    <context:property-placeholder location="classpath:jdbc.properties" />

    <import resource="classpath:/com/argo/freemarker/config.xml" />

    <bean class="com.{{prj._company_}}.{{prj._name_}}.factory.RedisBucketBeanFactory" />

    <bean class="com.{{prj._company_}}.{{prj._name_}}.factory.AsyncTaskPoolFactory" />

    <bean class="com.{{prj._company_}}.{{prj._name_}}.mybatis.MybatisCacheBeanFactory" />

    <bean id="mybatisMapperHelper" class="com.{{prj._company_}}.{{prj._name_}}.mybatis.MapperHelperExt" />

    <context:annotation-config />
    <aop:aspectj-autoproxy />
    <tx:annotation-driven/>

{% for m in prj._modules_ %}
    <import resource="classpath:/mybatis/{{m['ns']}}.xml" />
{% endfor %}

    <context:component-scan base-package="com.argo">
        <context:include-filter type="regex" expression="com.argo.security.password.*"/>
    </context:component-scan>

    <context:component-scan base-package="com.{{prj._company_}}.{{prj._name_}}">
        <context:include-filter type="regex" expression="com.{{prj._company_}}.{{prj._name_}}.service.impl.*"/>
        <context:include-filter type="regex" expression="com.{{prj._company_}}.{{prj._name_}}.wrapper.impl.*"/>
        <context:include-filter type="regex" expression="com.{{prj._company_}}.{{prj._name_}}.beans.*"/>
        <context:exclude-filter type="regex"
                                expression=".*Test" />
        <context:exclude-filter type="regex"
                                expression=".*TestCase" />

    </context:component-scan>

    <bean name="quartzScheduler" lazy-init="false"
          class="org.springframework.scheduling.quartz.SchedulerFactoryBean">
        <property name="applicationContextSchedulerContextKey" value="applicationContextKey" />
        <property name="configLocation" value="classpath:quartz.properties" />
        <property name="autoStartup" value="true" />
        <property name="jobFactory">
            <bean class="org.springframework.scheduling.quartz.SpringBeanJobFactory" />
        </property>
    </bean>

</beans>
