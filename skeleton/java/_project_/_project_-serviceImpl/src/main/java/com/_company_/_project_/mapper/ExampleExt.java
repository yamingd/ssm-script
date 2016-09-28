package com._company_._project_.mapper;

import tk.mybatis.mapper.entity.Example;

/**
 * Created by dengyaming on 9/5/16.
 */
public class ExampleExt extends Example {

    private String groupByColumns;

    private String statClause;

    private Integer offset;

    private Integer pageSize;

    public ExampleExt(Class<?> entityClass) {
        super(entityClass);
    }

    public ExampleExt(Class<?> entityClass, boolean exists) {
        super(entityClass, exists);
    }

    public ExampleExt(Class<?> entityClass, boolean exists, boolean notNull) {
        super(entityClass, exists, notNull);
    }

    public String getGroupByColumns() {
        return groupByColumns;
    }

    public void setGroupByColumns(String groupByColumns) {
        this.groupByColumns = groupByColumns;
    }

    public String getStatClause() {
        return statClause;
    }

    public void setStatClause(String statClause) {
        this.statClause = statClause;
    }

    public Integer getOffset() {
        return offset;
    }

    public void setOffset(Integer offset) {
        this.offset = offset;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }
    
}
