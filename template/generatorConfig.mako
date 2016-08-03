<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration
        PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
        "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">

<generatorConfiguration>
    <!-- http://blog.csdn.net/z69183787/article/details/50472069 -->
    <context id="mysqlTables" targetRuntime="MyBatis3Simple" defaultModelType="flat">

        <plugin type="com.github.yamingd.mybatis.FlexMapperPlugin">
            <property name="mappers" value="com.{{prj._company_}}.{{prj._name_}}.mapper.AllMapper"/>
            <!-- caseSensitive默认false，当数据库表名区分大小写时，可以将该属性设置为true -->
            <property name="caseSensitive" value="true"/>
        </plugin>
        
        <plugin type="org.mybatis.generator.plugins.EqualsHashCodePlugin">
            <property name="useEqualsHashCodeFromRoot" value="true" />
        </plugin>

        <plugin type="org.mybatis.generator.plugins.ToStringPlugin">
            <property name="useToStringFromRoot" value="true" />
        </plugin>

        <commentGenerator>
             <property name="suppressDate" value="true"/>
             <property name="suppressAllComments" value="true"/>
        </commentGenerator>

        <jdbcConnection driverClass="com.mysql.jdbc.Driver"
                        connectionURL="jdbc:mysql://{{ dbhost }}/{{ minfo['db'] }}?useUnicode=true&amp;characterEncoding=utf8"
                        userId="{{ dbuser }}"
                        password="{{ dbpwd }}">
        </jdbcConnection>

        <javaTypeResolver >
            <property name="forceBigDecimals" value="false" />
        </javaTypeResolver>

        <javaModelGenerator targetPackage="com.{{prj._company_}}.{{prj._name_}}.model.{{_module_}}" targetProject="../{{ prj._name_ }}-model/src/main/java">
            <property name="enableSubPackages" value="true" />
            <property name="trimStrings" value="true" />
        </javaModelGenerator>

        <sqlMapGenerator targetPackage="resources/mapper/{{_module_}}"  targetProject="../{{prj._name_}}-serviceImpl/src/main">
            <property name="enableSubPackages" value="true" />
        </sqlMapGenerator>

        <!-- <javaClientGenerator type="XMLMAPPER" targetPackage="com.{{prj._company_}}.{{prj._name_}}.mapper.{{_module_}}"  targetProject="../{{prj._name_}}-serviceImpl/src/main/java">
            <property name="enableSubPackages" value="true" />
        </javaClientGenerator> -->

{% for tb in minfo['tables'] %}
        <table tableName="{{tb.name}}" domainObjectName="{{tb.java.name}}">
            <property name="useActualColumnNames" value="false"/>
            <generatedKey column="id" sqlStatement="Mysql" identity="true" />
        </table>
{% endfor %}

    </context>
</generatorConfiguration>