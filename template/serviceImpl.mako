package {{ _tbi_.java.service_impl_ns }};

import com.argo.collection.Pagination;
import com.argo.security.UserIdentity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;
import java.util.Collections;
import java.util.List;

import tk.mybatis.mapper.entity.Example;
import com.{{prj._company_}}.{{prj._name_}}.mapper.ExampleExt;

import com.{{prj._company_}}.{{prj._name_}}.exception.EntityNotFoundException;
import com.{{prj._company_}}.{{prj._name_}}.exception.ServiceException;

import {{ _tbi_.java.model_ns }}.{{_tbi_.java.name}};
import {{ _tbi_.java.mapper_ns }}.{{_tbi_.java.name}}Tx;
import {{ _tbi_.java.mapper_ns }}.r.{{_tbi_.java.name}}MapperSlave;
import {{ _tbi_.java.mapper_ns }}.w.{{_tbi_.java.name}}MapperMaster;
import {{ _tbi_.java.service_ns }}.{{_tbi_.java.name}}Service;
import {{ _tbi_.java.wrapper_impl_ns }}.{{_tbi_.java.name}}WrapperImpl;
import com.{{prj._company_}}.{{prj._name_}}.service.impl.ServiceBaseImpl;

/**
 * Created by {{_user_}}.
 */
@Service
public class {{_tbi_.java.name}}ServiceImpl extends ServiceBaseImpl implements {{_tbi_.java.name}}Service {

    /**
     * 从库读模式
     */
    @Autowired
    protected {{_tbi_.java.name}}MapperSlave {{_tbi_.java.varName}}MapperSlave;

    /**
     * 主库读写模式
     */
    @Autowired
    protected {{_tbi_.java.name}}MapperMaster {{_tbi_.java.varName}}MapperMaster;

    /**
     * 对象关联wrapper
     */
    @Autowired
    protected {{_tbi_.java.name}}WrapperImpl {{_tbi_.java.varName}}WrapperImpl;

    @Override
    public {{_tbi_.java.name}} find(UserIdentity currentUser, {{_tbi_.pk.java.typeName}} id) throws EntityNotFoundException {
        Preconditions.checkNotNull(id, "id is NULL");
        {{_tbi_.java.name}} item = {{_tbi_.java.varName}}MapperSlave.selectByPrimaryKey(id);
        if (null == item){
            throw new EntityNotFoundException({{_tbi_.java.name}}.class.getSimpleName(), id);
        }
        return item;
    }

    @Override
    public List<{{_tbi_.java.name}}> findList(UserIdentity currentUser, {{_tbi_.pk.java.typeName}}... ids) {
        if (null == ids){
            return Collections.emptyList();
        }
        List<{{_tbi_.pk.java.typeName}}> itemIds = Lists.newArrayList(ids);
        if (itemIds.size() == 0){
            return Collections.emptyList();
        }
        List<{{_tbi_.java.name}}> list = {{_tbi_.java.varName}}MapperSlave.selectIn(itemIds);
        return list;
    }

    @Override
    public List<{{_tbi_.java.name}}> findList(UserIdentity currentUser, List<{{_tbi_.pk.java.typeName}}> ids) {
        if (null == ids || ids.size() == 0){
            return Collections.emptyList();
        }
        List<{{_tbi_.java.name}}> list = {{_tbi_.java.varName}}MapperSlave.selectIn(ids);
        return list;
    }

    @Override
    public List<{{_tbi_.java.name}}> findList(UserIdentity currentUser, String idDots) {
        if (idDots == null || idDots.trim().length() == 0){
            return Collections.emptyList();
        }
        String[] tmp = idDots.split(",");
        if (tmp.length == 0){
            return Collections.emptyList();
        }
        List<{{_tbi_.pk.java.typeName}}> ids = Lists.newArrayList();
        for(String str : tmp){
            ids.add(new {{_tbi_.pk.java.typeName}}(str));
        }
        List<{{_tbi_.java.name}}> list = {{_tbi_.java.varName}}MapperSlave.selectIn(ids);
        return list;
    }

    @Override
    public {{_tbi_.java.name}} findOne(UserIdentity currentUser, {{_tbi_.java.name}} criteria) throws ServiceException{
        Preconditions.checkNotNull(criteria, "criteria is NULL");
        {{_tbi_.java.name}} item = {{_tbi_.java.varName}}MapperSlave.selectOne(criteria);
        return item;
    }

    @Override
    public int count(UserIdentity currentUser, {{_tbi_.java.name}} criteria) throws ServiceException {
        Preconditions.checkNotNull(criteria, "criteria is NULL");
        int total = {{_tbi_.java.varName}}MapperSlave.selectCount(criteria);
        return total;
    }

    @Override
    @{{_tbi_.java.name}}Tx
    public {{_tbi_.java.name}} create(UserIdentity currentUser, {{_tbi_.java.name}} item) throws ServiceException {
        Preconditions.checkNotNull(item, "item is NULL");
        {{_tbi_.java.varName}}MapperMaster.insertSelective(item);
        return item;
    }

    @Override
    @{{_tbi_.java.name}}Tx
    public {{_tbi_.java.name}} save(UserIdentity currentUser, {{_tbi_.java.name}} item) throws ServiceException {
        Preconditions.checkNotNull(item, "item is NULL");
        {{_tbi_.java.varName}}MapperMaster.updateByPrimaryKey(item);
        return item;
    }

    @Override
    @{{_tbi_.java.name}}Tx
    public {{_tbi_.java.name}} saveNotNull(UserIdentity currentUser, {{_tbi_.java.name}} item) throws ServiceException {
        Preconditions.checkNotNull(item, "item is NULL");
        {{_tbi_.java.varName}}MapperMaster.updateByPrimaryKeySelective(item);
        return item;
    }

    @Override
    @{{_tbi_.java.name}}Tx
    public int removeBy(UserIdentity currentUser, {{_tbi_.pk.java.typeName}} id) throws ServiceException {
        Preconditions.checkNotNull(id, "id is NULL");
        return {{_tbi_.java.varName}}MapperMaster.deleteByPrimaryKey(id);
    }

    @Override
    @{{_tbi_.java.name}}Tx
    public int remove(UserIdentity currentUser, {{_tbi_.java.name}} item) throws ServiceException {
        return {{_tbi_.java.varName}}MapperMaster.delete(item);
    }

    @Override
    public Pagination<{{_tbi_.java.name}}> findAll(UserIdentity currentUser, Pagination<{{_tbi_.java.name}}> resultSet, {{_tbi_.java.name}} criteria) throws ServiceException {
        ExampleExt exampleExt = new ExampleExt({{_tbi_.java.name}}.class);
        exampleExt.setPageSize(resultSet.getSize());
        exampleExt.setOffset(resultSet.getOffset());
        exampleExt.orderBy("{{_tbi_.pk.name}}");
        Example.Criteria criteriaExt = exampleExt.createCriteria();
        //TODO:

        // 读取
        List<{{_tbi_.java.name}}> page = {{_tbi_.java.varName}}MapperSlave.selectLimitByExample(exampleExt);
        int total = {{_tbi_.java.varName}}MapperSlave.selectCountByExample(exampleExt);

        resultSet.setItems(page);
        resultSet.setTotal(total);

        return resultSet;
    }

{% for lc in _tbi_.linkFuncs %}
    @Override
    public List<{{_tbi_.java.name}}> {{ lc.queryFunc }}(UserIdentity currentUser, {{ lc.parent.pk.java.typeName }} {{ lc.queryField }}) throws ServiceException {
        {{_tbi_.java.name}} criteria = new {{_tbi_.java.name}}();
        criteria.set{{ lc.parent.java.name }}Id({{ lc.queryField }});
        // 读取全部
        List<{{_tbi_.java.name}}> list = {{_tbi_.java.varName}}MapperSlave.select(criteria);
        return list;
    }

{% endfor %}    

{% for qf in _tbi_.funcs %}
{% if qf.unique %}
    @Override
    public {{_tbi_.java.name}} findBy{{ qf.name }}(UserIdentity user, {{ qf.arglist }}) throws ServiceException {
        {{_tbi_.java.name}} criteria = new {{_tbi_.java.name}}();
{% for c in qf.cols %}        
        criteria.set{{ c.java.setterName }}({{ c.name }});
{% endfor %}
        {{_tbi_.java.name}} item = {{_tbi_.java.varName}}MapperSlave.selectOne(criteria);
        return item;
    }
{% else %}
    @Override
    public Pagination<{{_tbi_.java.name}}> findBy{{ qf.name }}(UserIdentity user, Pagination<{{_tbi_.java.name}}> resultSet, {{ qf.arglist }}) throws ServiceException {
        
        if (resultSet.getSize() > 0) {
            // 分页读取
            ExampleExt exampleExt = new ExampleExt({{_tbi_.java.name}}.class);
            exampleExt.setPageSize(resultSet.getSize());
            exampleExt.setOffset(resultSet.getOffset());
            exampleExt.orderBy("{{_tbi_.pk.name}}");
            Example.Criteria criteria = exampleExt.createCriteria();
            //查询条件:
{% for c in qf.cols %}        
            criteria.andEqualTo("{{c.java.name}}", {{ c.java.name }});
{% endfor %}
            // 读取
            List<{{_tbi_.java.name}}> page = {{_tbi_.java.varName}}MapperSlave.selectLimitByExample(exampleExt);
            int total = {{_tbi_.java.varName}}MapperSlave.selectCountByExample(exampleExt);

            resultSet.setItems(page);
            resultSet.setTotal(total);

            return resultSet;

        }else{

            {{_tbi_.java.name}} criteria = new {{_tbi_.java.name}}();
            {% for c in qf.cols %}        
            criteria.set{{ c.java.setterName }}({{ c.java.name }});
            {% endfor %}
            // 读取全部
            List<{{_tbi_.java.name}}> list = {{_tbi_.java.varName}}MapperSlave.select(criteria);
            resultSet.setItems(list);
            return resultSet;

        }
    }
{% endif %}

{% endfor %}

}
