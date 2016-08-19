package com._company_._project_;

/**
 * 获取记录唯一标识
 * Created by dengyaming on 8/19/16.
 */
public interface PrimaryKeyGetter<T> {

    /**
     * 获取主键
     * @return T
     */
    T getPrimaryKey();

}
