package {{ _tbi_.java.service_ns }};

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.argo.collection.Pagination;
import com.argo.security.UserIdentity;
import com.{{prj._company_}}.{{prj._name_}}.exception.ServiceException;

import {{ _tbi_.java.model_ns }}.{{_tbi_.java.name}};
import com.{{prj._company_}}.{{prj._name_}}.service.ServiceBase;

/**
 * Created by {{_user_}}.
 */
public interface {{_tbi_.java.name}}Service extends ServiceBase<{{_tbi_.java.name}}, {{_tbi_.pk.java.typeName}}>  {

{% for qf in _tbi_.funcs %}
{% if qf.unique %}
	/**
     * 按{{ qf.nameWithDot }}读取
{% for c in qf.cols %}
     * @param {{c.name}}
{% endfor %}
     * @return {{_tbi_.java.name}}
     */
	{{_tbi_.java.name}} findBy{{ qf.name }}(UserIdentity currentUser, {{ qf.arglist }}) throws ServiceException;
{% else %}
    /**
     * 按{{ qf.nameWithDot }}分页读取
     * resultSet需要设置size, index, start 三个属性
     * @param resultSet
{% for c in qf.cols %}
     * @param {{c.name}}
{% endfor %}
     * @return Pagination
     */
    Pagination<{{_tbi_.java.name}}> findBy{{ qf.name }}(UserIdentity currentUser, Pagination<{{_tbi_.java.name}}> resultSet, {{ qf.arglist }}) throws ServiceException;
{% endif %}

{% endfor %}

}