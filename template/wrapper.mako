package {{ _tbi_.java.wrapper_impl_ns }};

import com.argo.collection.Pagination;
import com.{{prj._company_}}.{{prj._name_}}.exception.EntityNotFoundException;
import com.argo.security.UserIdentity;
import com.{{prj._company_}}.{{prj._name_}}.exception.ServiceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.stereotype.Component;
import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import {{ _tbi_.java.model_ns}}.{{_tbi_.java.name}};
import {{ _tbi_.java.service_ns}}.{{_tbi_.java.name}}Service;

{% for r in _tbi_.impJavas %}
import {{ r.model_ns }}.{{ r.name }};
import {{ r.service_ns }}.{{ r.name }}Service;
{% endfor %}

{% if _tbi_.hasBigDecimal %}
import java.math.BigDecimal;
{% endif %}

/**
 * Created by {{_user_}}.
 */
@Component
public class {{_tbi_.java.name}}WrapperImpl {
	
	@Autowired
	private {{_tbi_.java.name}}Service {{_tbi_.java.varName}}Service;

{% for r in _tbi_.impJavas %}
	@Autowired
	private {{r.name}}Service {{r.varName}}Service;
{% endfor %}

{% for rc in _tbi_.refFields %}
{% if rc.java.repeated %}
	/**
     * 加载引用关联的对象
     * @param currentUser
     * @param item
     * @return List<{{rc.java.refJava.name}}>
     * @throws ServiceException
     */
    public List<{{rc.java.refJava.name}}> wrap{{rc.java.nameC}}(UserIdentity currentUser, {{_tbi_.java.name}} item) throws ServiceException{
        Preconditions.checkNotNull(item);
        {{rc.column.java.typeName}} v0 = item.get{{rc.column.java.getterName}}();
        if(null == v0){
            return Collections.emptyList();
        }
        {{rc.java.typeName}} refItem = {{rc.java.refJava.varName}}Service.findList(currentUser, v0);
        item.set{{rc.java.setterName}}(refItem);
        return refItem;
    }
{% else %}
	/**
     * 加载引用关联的对象
     * @param currentUser
     * @param item
     * @return {{rc.java.refJava.name}}
     * @throws EntityNotFoundException
     */
    public {{rc.java.refJava.name}} wrap{{rc.java.nameC}}(UserIdentity currentUser, {{_tbi_.java.name}} item) throws EntityNotFoundException{
        Preconditions.checkNotNull(item);
        {{rc.column.java.typeName}} v0 = item.get{{rc.column.java.getterName}}();
        if(null == v0 || v0 <= 0){
            return null;
        }
        {{rc.java.typeName}} refItem = {{rc.java.refJava.varName}}Service.find(currentUser, v0);
        item.set{{rc.java.setterName}}(refItem);
        return refItem;
    }
{% endif %}
	/**
     * 加载引用关联的对象
     * @param currentUser
     * @param list
     * @return List<{{rc.java.refJava.name}}>
     * @throws ServiceException
     */
    public List<{{rc.java.refJava.name}}> wrap{{rc.java.nameC}}(UserIdentity currentUser, List<{{_tbi_.java.name}}> list) throws ServiceException{
        Preconditions.checkNotNull(list);
{% if rc.repeated %}
        List<{{rc.java.refJava.name}}> result = new ArrayList<{{rc.java.refJava.name}}>();
        for(int i=0; i<list.size(); i++){
            {{_tbi_.java.name}} item = list.get(i);
            if(null == item){
                continue;
            }
            {{rc.java.typeName}} refItems = {{rc.java.refJava.varName}}Service.findList(currentUser, item.get{{rc.column.java.getterName}}());
            item.set{{rc.java.setterName}}(refItems);
            result.addAll(refItems);
        }
        return result;
{% else %}
        List<{{rc.column.java.typeName}}> ids = new ArrayList<{{rc.column.java.typeName}}>();
        for(int i=0; i<list.size(); i++){
            {{_tbi_.java.name}} item = list.get(i);
            if(null == item){
                continue;
            }
            {{rc.column.java.typeName}} v0 = item.get{{rc.column.java.getterName}}();
            if(null == v0 || v0 <= 0){
                continue;
            }
            if(ids.contains(v0)){
                continue;
            }
            ids.add(v0);
        }
        List<{{rc.java.typeName}}> refItems = {{rc.java.refJava.varName}}Service.findList(currentUser, ids);
        for(int i=0; i<refItems.size(); i++){
            {{rc.java.typeName}} refItem = refItems.get(i);
            if(null == refItem){
                continue;
            }
            {{rc.table.pk.java.typeName}} v0 = refItem.get{{rc.table.pk.java.getterName}}();
            for(int j=0; j<list.size(); j++){
                {{_tbi_.java.name}} item = list.get(j);
                if(null == item){
                    continue;
                }
                {{rc.column.java.typeName}} v1 = item.get{{rc.column.java.getterName}}();
                if(null != v1 && v0.equals(v1)){
                    item.set{{rc.java.setterName}}(refItems.get(i));
                }
            }
        }
        return refItems;
{% endif %}
    }
{% endfor %}

}