package {{ _tbi_.java.service_ns }};

import com.argo.collection.Pagination;
import com.{{prj._company_}}.{{prj._name_}}.exception.EntityNotFoundException;
import com.argo.security.UserIdentity;
import com.{{prj._company_}}.{{prj._name_}}.exception.ServiceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.google.common.base.Preconditions;
import java.util.Collections;
import java.util.List;
import java.util.ArrayList;

import org.junit.Test;
import org.junit.Assert;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;

import com.{{prj._company_}}.{{prj._name_}}.service.ServiceTestCaseBase;
import {{ _tbi_.java.model_ns }}.{{_tbi_.java.name}};
import {{ _tbi_.java.service_impl_ns }}.{{_tbi_.java.name}}ServiceImpl;

/**
 * Created by dengyaming on 8/3/16.
 */
public class {{_tbi_.java.name}}ServiceImplTest extends ServiceTestCaseBase {

    @Autowired
    {{_tbi_.java.name}}ServiceImpl {{_tbi_.java.varName}}ServiceImpl;

    @Test
    public void test_find() {
        UserIdentity currentUser = null;
        {{_tbi_.pk.java.typeName}} id = null;
        try {
            {{_tbi_.java.name}} {{_tbi_.java.varName}} = {{_tbi_.java.varName}}ServiceImpl.find(currentUser, id);
            logger.debug("{{_tbi_.java.varName}}: {}", {{_tbi_.java.varName}});
            Assert.assertNotNull({{_tbi_.java.varName}});
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
    }

    @Test
    public void test_findOne(){
        UserIdentity currentUser = null;
        {{_tbi_.java.name}} criteria = new {{_tbi_.java.name}}();
        criteria.set{{_tbi_.pk.java.setterName}}(1);
        try {
            {{_tbi_.java.name}} {{_tbi_.java.varName}} = {{_tbi_.java.varName}}ServiceImpl.findOne(currentUser, criteria);
            logger.debug("{{_tbi_.java.varName}}: {}", {{_tbi_.java.varName}});
            Assert.assertNotNull({{_tbi_.java.varName}});
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }

    }

    @Test
    public void test_findList(){
        UserIdentity currentUser = null;
        logger.info("@@@ test_findList start. ");
        List<{{_tbi_.java.name}}> list = {{_tbi_.java.varName}}ServiceImpl.findList(currentUser, 1, 2, 3, 4);
        logger.debug("list: {}", list);
    }

    @Test
    public void test_findList2(){
        UserIdentity currentUser = null;
        logger.info("@@@ test_findList start. ");
        List<Integer> ids = new ArrayList<Integer>();
        ids.add(1);
        ids.add(2);
        List<{{_tbi_.java.name}}> list = {{_tbi_.java.varName}}ServiceImpl.findList(currentUser, ids);
        logger.debug("list: {}", list);
    }

    @Test
    public void test_count(){
        UserIdentity currentUser = null;
        {{_tbi_.java.name}} criteria = new {{_tbi_.java.name}}();
        try {
            int total = {{_tbi_.java.varName}}ServiceImpl.count(currentUser, criteria);
            logger.debug("total: {}", total);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
    }

    @Test
    public void test_create(){
        UserIdentity currentUser = null;
        {{_tbi_.java.name}} criteria = new {{_tbi_.java.name}}();
        try {
            {{_tbi_.java.name}} {{_tbi_.java.varName}} = {{_tbi_.java.varName}}ServiceImpl.create(currentUser, criteria);
            logger.debug("{{_tbi_.java.varName}}: {}", {{_tbi_.java.varName}});
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
    }

    @Test
    public void test_save(){
        UserIdentity currentUser = null;
        {{_tbi_.java.name}} criteria = new {{_tbi_.java.name}}();
        try {
            {{_tbi_.java.name}} {{_tbi_.java.varName}} = {{_tbi_.java.varName}}ServiceImpl.save(currentUser, criteria);
            logger.debug("{{_tbi_.java.varName}}: {}", {{_tbi_.java.varName}});
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
    }

    @Test
    public void test_saveNotNull(){
        UserIdentity currentUser = null;
        {{_tbi_.java.name}} criteria = new {{_tbi_.java.name}}();
        try {
            {{_tbi_.java.name}} {{_tbi_.java.varName}} = {{_tbi_.java.varName}}ServiceImpl.saveNotNull(currentUser, criteria);
            logger.debug("{{_tbi_.java.varName}}: {}", {{_tbi_.java.varName}});
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
    }

    @Test
    public void test_remove(){
        UserIdentity currentUser = null;
        {{_tbi_.java.name}} criteria = new {{_tbi_.java.name}}();
        try {
            int total = {{_tbi_.java.varName}}ServiceImpl.remove(currentUser, criteria);
            logger.debug("total: {}", total);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
    }

    @Test
    public void test_removeBy(){
        UserIdentity currentUser = null;
        try {
            int total = {{_tbi_.java.varName}}ServiceImpl.removeBy(currentUser, 1);
            logger.debug("total: {}", total);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
    }

{% for qf in _tbi_.funcs %}
{% if qf.unique %}
    @Test
    public void test_findBy{{ qf.name }}(){
        UserIdentity currentUser = null;
{% for c in qf.cols %}        
        {{c.java.typeName}} {{c.name}} = null;
{% endfor %}
        try{
            {{_tbi_.java.name}} item = {{_tbi_.java.varName}}ServiceImpl.findBy{{ qf.name }}(currentUser, {{ qf.varlist }});
            Assert.assertNotNull(item);
        }catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
    }
{% else %}
    @Test
    public void test_findBy{{ qf.name }}(){
        UserIdentity currentUser = null;
        Pagination<{{_tbi_.java.name}}> resultSet = new Pagination<>();
        resultSet.setSize(20);
        resultSet.setIndex(1);
{% for c in qf.cols %}
        {{c.java.typeName}} {{c.name}} = null;
{% endfor %}
        try {
            resultSet = {{_tbi_.java.varName}}ServiceImpl.findBy{{ qf.name }}(currentUser, resultSet, {{ qf.varlist }});
            for ({{_tbi_.java.name}} item : resultSet.getItems()) {
                logger.info("item: {}", item);
            }
        } catch (ServiceException e) {
            logger.error(e.getMessage(), e);
        }

    }
{% endif %}

{% endfor %}    

}
