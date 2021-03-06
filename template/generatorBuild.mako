group 'com.github.yaming.arch-skeleton'
version '1.0-SNAPSHOT'

apply plugin: 'maven'
apply plugin: 'java'

apply plugin: 'war'
apply plugin: 'idea'
apply plugin: 'eclipse-wtp'

configurations {
{% for m in _modules_ %}
    mybatisGenerator_{{m['ns']}}
{% endfor %}
}

dependencies {
    compile rootProject.ext.mybatisDependencies.generator
    compile rootProject.ext.mybatisDependencies.mapper
{% for m in _modules_ %}    
    mybatisGenerator_{{m['ns']}} rootProject.ext.mybatisDependencies.generator
    mybatisGenerator_{{m['ns']}} rootProject.ext.dataDependencies.mysql
    mybatisGenerator_{{m['ns']}} rootProject.ext.mybatisDependencies.mapper
    mybatisGenerator_{{m['ns']}} rootProject.ext.logDependencies.slf4j
    mybatisGenerator_{{m['ns']}} files('../lib/dev-tools-1.0.jar')
{% endfor %}
}

{% for m in _modules_ %}
task mybatisGenerate_{{m['ns']}} << {

    ant.properties['targetProject'] = projectDir.path
    ant.properties['driverClass'] = 'com.mysql.jdbc.Driver'
    ant.properties['connectionURL'] = 'jdbc:mysql://{{ dbhost }}/{{ m['db'] }}?useUnicode=true&amp;characterEncoding=utf8'
    ant.properties['userId'] = '{{ dbuser }}'
    ant.properties['password'] = '{{ dbpwd }}'
    ant.properties['src_main_java'] = sourceSets.main.java.srcDirs[0].path
    ant.properties['src_main_resources'] = sourceSets.main.resources.srcDirs[0].path
    ant.properties['modelPackage'] = 'com.{{prj._company_}}.{{prj._name_}}.model.{{m['ns']}}'
    ant.properties['mapperPackage'] = 'com.{{prj._company_}}.{{prj._name_}}.mapper.{{m['ns']}}'
    ant.properties['sqlMapperPackage'] = 'resources/mapper/{{m['ns']}}'

    ant.taskdef(
            name: 'mbgenerator',
            classname: 'org.mybatis.generator.ant.GeneratorAntTask',
            classpath: configurations.mybatisGenerator_{{m['ns']}}.asPath
    )
    ant.mbgenerator(overwrite: true,
            configfile: '{{m['ns']}}_generatorConfig.xml', verbose: true) {
        propertyset {
            propertyref(name: 'targetProject')
            propertyref(name: 'userId')
            propertyref(name: 'driverClass')
            propertyref(name: 'connectionURL')
            propertyref(name: 'password')
            propertyref(name: 'src_main_java')
            propertyref(name: 'src_main_resources')
            propertyref(name: 'modelPackage')
            propertyref(name: 'mapperPackage')
            propertyref(name: 'sqlMapperPackage')
        }
    }
}

{% endfor %}