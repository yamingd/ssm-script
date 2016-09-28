package com._company_._project_.mapper;

import org.apache.ibatis.annotations.SelectProvider;
import tk.mybatis.mapper.common.Mapper;

import java.util.List;
import java.util.Map;

/**
 * Created by dengyaming on 8/3/16.
 */
public interface AllMapper<T> extends Mapper<T> {

    /**
     * IN 操作
     * @param itemIds
     * @return
     */
    @SelectProvider(type = SelectExtProvider.class, method = "dynamicSQL")
    List<T> selectIn(List<Integer> itemIds);

    /**
     * 读取记录的主键
     * @param record
     * @return
     */
    @SelectProvider(type = SelectExtProvider.class, method = "dynamicSQL")
    List<Integer> selectPrimaryKeys(T record);

    /**
     * 使用COUNT, SUM, GROUP BY操作符
     * @param example
     * @return
     */
    @SelectProvider(type = SelectExtProvider.class, method = "dynamicSQL")
    List<Map> statByExample(ExampleExt example);

    /**
     * 分页操作. Limit
     * @param example
     * @return
     */
    @SelectProvider(type = SelectExtProvider.class, method = "dynamicSQL")
    List<T> selectLimitByExample(ExampleExt example);

    /**
     * 递增/递减字段: total_*
     * 其他字段使用 =
     * @param record
     * @return
     */
    @UpdateProvider(type = SelectExtProvider.class, method = "dynamicSQL")
    int updateCounterByPrimaryKey(T record);

    /**
     * 递增/递减字段: total_*
     * 其他字段使用 =
     * @param record
     * @return
     */
    @UpdateProvider(type = SelectExtProvider.class, method = "dynamicSQL")
    int updateCounterByExample(@Param("record") T record, @Param("example") Object example);
    
}
