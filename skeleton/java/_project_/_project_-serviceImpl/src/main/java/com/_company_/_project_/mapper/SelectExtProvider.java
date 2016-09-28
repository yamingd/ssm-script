package com._company_._project_.mapper;

import org.apache.ibatis.mapping.MappedStatement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import tk.mybatis.mapper.entity.EntityColumn;
import tk.mybatis.mapper.mapperhelper.EntityHelper;
import tk.mybatis.mapper.mapperhelper.MapperHelper;
import tk.mybatis.mapper.mapperhelper.MapperTemplate;
import tk.mybatis.mapper.mapperhelper.SqlHelper;

import java.util.Set;

/**
 * Created by dengyaming on 8/3/16.
 */
public class SelectExtProvider extends MapperTemplate {

    public static final String COUNTER_PREFIX = "total_";

    protected Logger logger = LoggerFactory.getLogger(this.getClass());

    public SelectExtProvider(Class<?> mapperClass, MapperHelper mapperHelper) {
        super(mapperClass, mapperHelper);
    }

    /**
     * IN 查询
     *
     * @param ms
     * @return
     */
    public String selectIn(MappedStatement ms) {
        Class<?> entityClass = getEntityClass(ms);
        //修改返回值类型为实体类型
        setResultType(ms, entityClass);
        StringBuilder sql = new StringBuilder();
        sql.append(SqlHelper.selectAllColumns(entityClass));
        sql.append(SqlHelper.fromTable(entityClass, tableName(entityClass)));

        sql.append(" WHERE ID IN ");
        sql.append("<foreach collection=\"list\" item=\"itemId\"  open=\"(\" separator=\",\" close=\")\">");
        sql.append("#{itemId}");
        sql.append("</foreach>");

        return sql.toString();
    }

    /**
     * 查询PK
     *
     * @param ms
     * @return
     */
    public String selectPrimaryKeys(MappedStatement ms) {
        Class<?> entityClass = getEntityClass(ms);
        StringBuilder sql = new StringBuilder();

        sql.append("SELECT ");
        Set<EntityColumn> pkColumns = EntityHelper.getPKColumns(entityClass);
        if (pkColumns.size() > 0) {
            int index = pkColumns.size();
            for (EntityColumn column : pkColumns){
                sql.append(column.getColumn());
                index -- ;
                if (index == 0){
                    break;
                }
                sql.append(", ");
            }
        } else {
            logger.error("Table {}. does not have primary key.", entityClass);
        }

        sql.append(SqlHelper.fromTable(entityClass, tableName(entityClass)));
        sql.append(SqlHelper.whereAllIfColumns(entityClass, isNotEmpty()));
        return sql.toString();
    }

    /**
     * 查询PK
     *
     * @param ms
     * @return
     */
    public String selectLimitByExample(MappedStatement ms) {

        Class<?> entityClass = getEntityClass(ms);
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ");
        sql.append(SqlHelper.exampleSelectColumns(entityClass));
        sql.append(SqlHelper.fromTable(entityClass, tableName(entityClass)));
        sql.append(SqlHelper.exampleWhereClause());
        sql.append(SqlHelper.exampleOrderBy(entityClass));

        sql.append(" limit #{offset}, #{pageSize} ");

        return sql.toString();
    }

    /**
     *
     * 根据Example执行统计查询
     *
     * @param ms
     * @return
     */
    public String statByExample(MappedStatement ms) {
        Class<?> entityClass = getEntityClass(ms);
        StringBuilder sql = new StringBuilder();
        sql.append(exampleSelectGroupByColumns());
        sql.append(SqlHelper.fromTable(entityClass, tableName(entityClass)));
        sql.append(SqlHelper.exampleWhereClause());
        sql.append(exampleGroupBy());
        return sql.toString();
    }

    /**
     * example支持查询指定列时
     *
     * @return
     */
    public static String exampleSelectGroupByColumns() {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ");
        sql.append("${groupByColumns}").append(",${statClause}");
        return sql.toString();
    }

    /**
     * example查询中的groupBy条件
     *
     * @return
     */
    public static String exampleGroupBy() {
        StringBuilder sql = new StringBuilder();
        sql.append("<if test=\"groupByColumns != null\">");
        sql.append("group by ${groupByColumns}");
        sql.append("</if>");
        return sql.toString();
    }

    /**
     * 使用递增、递减方式修改计数器
     * @param ms
     * @return
     */
    public String updateCounterByPrimaryKey(MappedStatement ms){

        Class<?> entityClass = getEntityClass(ms);
        StringBuilder sql = new StringBuilder();
        sql.append(SqlHelper.updateTable(entityClass, tableName(entityClass)));

        sql.append("<set>");
        //获取全部列
        Set<EntityColumn> columnList = EntityHelper.getColumns(entityClass);
        //当某个列有主键策略时，不需要考虑他的属性是否为空，因为如果为空，一定会根据主键策略给他生成一个值
        String contents;
        for (EntityColumn column : columnList) {
            if (!column.isId() && column.isUpdatable()) {

                if (column.getColumn().startsWith(COUNTER_PREFIX)){

                    contents = column.getColumnEqualsHolder(null) + " + " + column.getColumn();

                }else{
                    contents = column.getColumnEqualsHolder(null);
                }

                sql.append(SqlHelper.getIfNotNull(null, column, contents + ",", isNotEmpty()));
            }
        }
        sql.append("</set>");

        sql.append(SqlHelper.wherePKColumns(entityClass));

        return sql.toString();
    }

    /**
     * 使用递增、递减方式修改计数器
     * @param ms
     * @return
     */
    public String updateCounterByExample(MappedStatement ms){

        Class<?> entityClass = getEntityClass(ms);
        StringBuilder sql = new StringBuilder();
        sql.append(SqlHelper.updateTable(entityClass, tableName(entityClass), "example"));

        sql.append("<set>");
        //获取全部列
        Set<EntityColumn> columnList = EntityHelper.getColumns(entityClass);
        //当某个列有主键策略时，不需要考虑他的属性是否为空，因为如果为空，一定会根据主键策略给他生成一个值
        String contents;
        for (EntityColumn column : columnList) {
            if (!column.isId() && column.isUpdatable()) {

                if (column.getColumn().startsWith(COUNTER_PREFIX)){

                    contents = column.getColumnEqualsHolder("record") + " + " + column.getColumn();

                }else{
                    contents = column.getColumnEqualsHolder("record");
                }

                sql.append(SqlHelper.getIfNotNull("record", column, contents + ",", isNotEmpty()));
            }
        }
        sql.append("</set>");

        sql.append(SqlHelper.updateByExampleWhereClause());

        return sql.toString();
    }
}
