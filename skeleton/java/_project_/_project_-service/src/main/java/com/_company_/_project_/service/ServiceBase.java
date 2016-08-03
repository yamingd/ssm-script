package com._company_._project_.service;

import com._company_._project_.exception.EntityNotFoundException;
import com.argo.security.UserIdentity;
import com._company_._project_.exception.ServiceException;

import java.io.Serializable;
import java.util.List;

/**
 * Created by yamingd on 9/20/15.
 */
public interface ServiceBase<T extends Serializable, PK extends Comparable> {
    /**
     * 按主键查找记录
     * @param id
     * @return T
     */
    T find(UserIdentity currentUser, PK id) throws EntityNotFoundException;
    /**
     * 按主键查找记录
     * @param ids
     * @return List
     */
    List<T> findList(UserIdentity currentUser, PK... ids);
    /**
     * 按主键查找记录
     * @param ids
     * @return List
     */
    List<T> findList(UserIdentity currentUser, List<PK> ids);
    /**
     * 按条件查找一条记录
     * @param criteria
     * @return T
     */
    T findOne(UserIdentity currentUser, T criteria) throws ServiceException;
    /**
     * 按条件统计记录数
     * @param criteria
     * @return T
     */
    int count(UserIdentity currentUser, T criteria) throws ServiceException;
    /**
     * 新建记录
     * @param item
     * @return T
     */
    T create(UserIdentity currentUser, T item) throws ServiceException;

    /**
     * 保存更新, NULL的值会被忽略
     * @param item
     * @return boolean
     */
    T saveNotNull(UserIdentity currentUser, T item) throws ServiceException;
    /**
     * 保存更新
     * @param item
     * @return boolean
     */
    T save(UserIdentity currentUser, T item) throws ServiceException;
    /**
     * 删除记录
     * @param id
     * @return int
     */
    int removeBy(UserIdentity currentUser, PK id) throws ServiceException;

    /**
     * 删除记录
     * @param item
     * @return int
     */
    int remove(UserIdentity currentUser, T item) throws ServiceException;
}