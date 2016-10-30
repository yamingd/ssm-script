jdbc.driverClassName=com.mysql.jdbc.Driver
jdbc.validationQuery=/* ping */SELECT 1
jdbc.maxActive=20
jdbc.statement.timeout=10

{% for m in prj._modules_ %}
jdbc.{{m['ns']}}.url=jdbc:mysql://{{ dbhost }}/{{ m['db'] }}?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&autoReconnect=true&failOverReadOnly=false&rewriteBatchedStatements=true
jdbc.{{m['ns']}}.user={{ dbuser }}
jdbc.{{m['ns']}}.password={{ dbpwd }}

{% endfor %}