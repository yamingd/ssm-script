<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tx="http://www.springframework.org/schema/tx" xmlns:aop="http://www.springframework.org/schema/aop" xsi:schemaLocation="
http://www.springframework.org/schema/beans 
http://www.springframework.org/schema/beans/spring-beans-3.0.xsd 
http://www.springframework.org/schema/tx 
http://www.springframework.org/schema/tx/spring-tx-3.0.xsd
http://www.springframework.org/schema/aop 
http://www.springframework.org/schema/aop/spring-aop-3.0.xsd
">
	<bean id="{{ _module_ }}_parentDataSource" class="com.alibaba.druid.pool.DruidDataSource" init-method="init"
		  destroy-method="close" abstract="true">
		<property name="driverClassName" value="${jdbc.driverClassName}"/>
		<property name="filters" value="stat"/>
		<property name="maxActive" value="${jdbc.maxActive}"/>
		<property name="initialSize" value="1"/>
		<property name="maxWait" value="60000"/>
		<property name="minIdle" value="1"/>
		<property name="timeBetweenEvictionRunsMillis" value="3000"/>
		<property name="minEvictableIdleTimeMillis" value="60000"/>
		<property name="validationQuery" value="${jdbc.validationQuery}"/>
		<property name="testWhileIdle" value="true"/>
		<property name="testOnBorrow" value="false"/>
		<property name="testOnReturn" value="false"/>
		<property name="connectionInitSqls" value="set names utf8mb4;"/>
		<property name="removeAbandoned" value="true" />
		<property name="logAbandoned" value="false" />
	</bean>

	<!-- 只读模式 -->
	<bean name="{{ _module_ }}_dataSource_r" parent="{{ _module_ }}_parentDataSource">
		<property name="name" value="{{ _module_ }}_dataSource_r" />
		<property name="url" value="${jdbc.{{ _module_ }}.url}" />
		<property name="username" value="${jdbc.{{ _module_ }}.user}" />
		<property name="password" value="${jdbc.{{ _module_ }}.password}" />
	</bean>

	<bean id="{{ _module_ }}_sqlSessionFactory_r" class="org.mybatis.spring.SqlSessionFactoryBean">
		<property name="dataSource" ref="{{ _module_ }}_dataSource_r" />
		<property name="configLocation" value="classpath:mybatis-config.xml" />
		<property name="mapperLocations" value="classpath:mapper/{{_module_}}/*.xml" />
		<property name="plugins">
			<array>
				<bean class="com.github.pagehelper.PageHelper">
					<property name="properties">
						<value>
							dialect=mysql
						</value>
					</property>
				</bean>
			</array>
		</property>
	</bean>

	<bean id="{{ _module_ }}_MapperScannerConfigurer_r" class="tk.mybatis.spring.mapper.MapperScannerConfigurer">
		<property name="basePackage" value="com.{{prj._company_}}.{{prj._name_}}.mapper.{{ _module_ }}.r" />
		<property name="sqlSessionFactoryBeanName" value="{{ _module_ }}_sqlSessionFactory_r" />
		<property name="mapperHelper" ref="mybatisMapperHelper" />
        <property name="properties">
            <value>
                mappers=com.{{prj._company_}}.{{prj._name_}}.mapper.AllMapper
            </value>
        </property>
	</bean>

	<!-- 写模式 -->
	<bean name="{{ _module_ }}_dataSource_w" parent="{{ _module_ }}_parentDataSource" {% if prj._jta_ %}class="com.alibaba.druid.pool.xa.DruidXADataSource"{% endif %}>
		<property name="name" value="{{ _module_ }}_dataSource_w" />
		<property name="url" value="${jdbc.{{ _module_ }}.url}" />
		<property name="username" value="${jdbc.{{ _module_ }}.user}" />
		<property name="password" value="${jdbc.{{ _module_ }}.password}" />
	</bean>

	<bean id="{{ _module_ }}_MapperScannerConfigurer_w" class="tk.mybatis.spring.mapper.MapperScannerConfigurer">
		<property name="basePackage" value="com.{{prj._company_}}.{{prj._name_}}.mapper.{{ _module_ }}.w" />
		<property name="sqlSessionFactoryBeanName" value="{{ _module_ }}_sqlSessionFactory_w" />
		<property name="mapperHelper" ref="mybatisMapperHelper" />
        <property name="properties">
            <value>
                mappers=com.{{prj._company_}}.{{prj._name_}}.mapper.AllMapper
            </value>
        </property>
	</bean>

{% if not prj._jta_ %}
	<bean id="{{ _module_ }}_sqlSessionFactory_w" class="org.mybatis.spring.SqlSessionFactoryBean">
		<property name="dataSource" ref="{{ _module_ }}_dataSource_w" />
		<property name="configLocation" value="classpath:mybatis-config.xml" />
		<property name="mapperLocations" value="classpath:mapper/{{_module_}}/*.xml" />
		<property name="plugins">
			<array>
				<bean class="com.github.pagehelper.PageHelper">
					<property name="properties">
						<value>
							dialect=mysql
						</value>
					</property>
				</bean>
			</array>
		</property>
	</bean>

	<bean id="{{ _module_ }}_transactionManager_w" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
		<property name="dataSource" ref="{{ _module_ }}_dataSource_w" />
		<qualifier value="{{ _module_ }}Tx"/>
	</bean>
{% endif %}

{% if prj._jta_ %}
	<bean id="{{ _module_ }}_dataSource_wxa" class="com.atomikos.jdbc.AtomikosDataSourceBean" init-method="init" destroy-method="close">
        <property name="uniqueResourceName" value="{{ _module_ }}_dataSource_wxa"/>
        <property name="xaDataSource" ref="{{ _module_ }}_dataSource_w"/>
       	<property name="minPoolSize" value="1"/>  
       	<property name="maxPoolSize" value="${jdbc.maxActive}"/>  
       	<property name="borrowConnectionTimeout" value="60"/>  
       	<property name="reapTimeout" value="20"/>  
       	<property name="maxIdleTime" value="60"/>  
       	<property name="maintenanceInterval" value="3"/>  
       	<property name="loginTimeout" value="10"/>  
       	<property name="testQuery" value="${jdbc.validationQuery}"/>
    </bean>

    <bean id="{{ _module_ }}_sqlSessionFactory_w" class="org.mybatis.spring.SqlSessionFactoryBean">
		<property name="dataSource" ref="{{ _module_ }}_dataSource_wxa" />
		<property name="configLocation" value="classpath:mybatis-config.xml" />
		<property name="mapperLocations" value="classpath:mapper/{{_module_}}/*.xml" />
		<property name="plugins">
			<array>
				<bean class="com.github.pagehelper.PageHelper">
					<property name="properties">
						<value>
							dialect=mysql
						</value>
					</property>
				</bean>
			</array>
		</property>
	</bean>

	<bean id="{{ _module_ }}_transactionManager_w" class="com.atomikos.icatch.jta.UserTransactionManager" init-method="init" destroy-method="close">
        <description>{{ _module_ }}_transactionManager_w</description>
        <property name="forceShutdown" value="false" /> 
    </bean>

    <bean id="{{ _module_ }}_userTxImpl" class="com.atomikos.icatch.jta.UserTransactionImp">
        <property name="transactionTimeout" value="300" />
    </bean>

    <bean id="{{ _module_ }}_JtaTransactionManager" class="org.springframework.transaction.jta.JtaTransactionManager" >
        <property name="transactionManager" ref="{{ _module_ }}_transactionManager_w" /> 
        <property name="userTransaction" ref="{{ _module_ }}_userTxImpl" /> 
        <qualifier value="{{ _module_ }}Tx"/>
    </bean>
{% endif %}

</beans>