package com.{{_company_}}.{{_project_}}.testcases.controller.mobile.{{_module_}};

import com.{{_company_}}.{{_project_}}.{{_module_}}.{{_tbi_.entityName}};
import com.argo.core.web.JsonResponse;
import com.argo.core.protobuf.ProtobufMessage;
import com.{{_company_}}.{{_project_}}.testcases.MobileTestCase;
import com.google.common.collect.Maps;
import org.junit.Assert;
import org.junit.Test;

import java.util.List;
import java.util.Map;

/**
 */
public class {{_tbi_.entityName}}ControllerTest extends MobileTestCase {

    @Test
    public void testAll() throws Exception {
        currentUserId = null; //TODO:
        String url = "/m/{{_mvcurl_}}/list";
        ProtobufMessage html = super.getProtobuf(url, null);
        Assert.assertNotNull(html);
    }

    @Test
    public void testAdd() throws Exception {
        currentUserId = null; //TODO:

        String url = "/m/{{_mvcurl_}}/add";
        String html = super.getUrlView(url, null);
        Assert.assertNotNull(html);

        url = "/m/{{_mvcurl_}}/create";
        Map<String, Object> map = Maps.newHashMap();
        //TODO:设置map属性
        ProtobufMessage jsonResponse = super.postFormProtobuf(url, map);
        Assert.assertEquals(200L, jsonResponse.getCode() * 1L);
        System.out.println(jsonResponse);
    }

    @Test
    public void testAddWithError0() throws Exception {
        currentUserId = null; //TODO:

        String url = "/m/{{_mvcurl_}}/add";
        String html = super.getUrlView(url, null);
        Assert.assertNotNull(html);

        url = "/m/{{_mvcurl_}}/create";
        Map<String, Object> map = Maps.newHashMap();
        //TODO:设置map属性
        ProtobufMessage jsonResponse = super.postFormProtobuf(url, map);
        Assert.assertEquals(200L, jsonResponse.getCode() * 1L);
        System.out.println(jsonResponse);
    }

    @Test
    public void testAddWithError1() throws Exception {
        currentUserId = null; //TODO:

        String url = "/m/{{_mvcurl_}}/add";
        String html = super.getUrlView(url, null);
        Assert.assertNotNull(html);

        url = "/m/{{_mvcurl_}}/create";
        Map<String, Object> map = Maps.newHashMap();
        //TODO: 设置map属性
        ProtobufMessage jsonResponse = super.postFormProtobuf(url, map);
        Assert.assertEquals(200L, jsonResponse.getCode() * 1L);
        System.out.println(jsonResponse);
    }

    @Test
    public void testView() throws Exception {
        currentUserId = null; //TODO:
        
        String url = "/m/{{_mvcurl_}}/view/3";
        String html = super.getUrlView(url, null);
        Assert.assertNotNull(html);

        url = "/m/{{_mvcurl_}}/save/3";
        Map<String, Object> map = Maps.newHashMap();
        //TODO:设置map属性
        ProtobufMessage jsonResponse = super.postFormProtobuf(url, map);
        System.out.println(jsonResponse);

        url = "/m/{{_mvcurl_}}/remove/3";
        jsonResponse = super.postFormProtobuf(url, map);
        System.out.println(jsonResponse);
    }
}
