package {{ _tbi_.android.mapper_ns }};

import android.support.v4.util.ArrayMap;
import com.argo.sqlite.SqliteMapper;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import net.sqlcipher.Cursor;
import net.sqlcipher.database.SQLiteStatement;
import timber.log.Timber;

import {{ _tbi_.pb.model_ns }}.{{_tbi_.pb.name}};

{% for r in _tbi_.impJavas %}
import {{ r.android.model_ns }}.PB{{ r.name }};
import {{ r.android.mapper_ns }}.PB{{ r.name }}Mapper; 
{% endfor %}


public class {{_tbi_.pb.name}}Mapper extends SqliteMapper<{{_tbi_.pb.name}}, {{_tbi_.pk.java.typeName}}> {

  private static String pkColumn;

  private static String tableName;

  public static String dbContextTag;

  public static {{_tbi_.pb.name}}Mapper instance;

  static {
    pkColumn = "{{_tbi_.pk.pb.name}}";
    tableName = "{{_tbi_.pb.name}}";
    dbContextTag = "default"; //chang this if having different sqlite db
  }

  public {{_tbi_.pb.name}}Mapper() {
    super();
    instance = this;
  }

  @Override
  protected void bindInsertStatement(SQLiteStatement statement, {{_tbi_.pb.name}} o) {
{% for c in _tbi_.columns %}
    statement.{{c.android.binder}}({{c.index + 1}}, {{c.android.bindValue('o')}});
{% endfor %}

  }

  @Override
  public List<String> getColumns() {
    List<String> columns = new ArrayList<String>();
{% for c in _tbi_.columns %}
    columns.add("{{c.pb.name}}");
{% endfor %}
    return columns;
  }

  @Override
  public Map<String, String> getColumnInfo() {
    Map<String, String> columns = new ArrayMap<String, String>();
{% for c in _tbi_.columns %}
    columns.put("{{c.pb.name}}", "{{c.android.typeName}}");
{% endfor %}
    return columns;
  }

  @Override
  public String getPkColumn() {
    return pkColumn;
  }

  @Override
  public String getTableName() {
    return tableName;
  }

  @Override
  public Class<{{_tbi_.pb.name}}> getClassType() {
    return {{_tbi_.pb.name}}.class;
  }

  @Override
  public String getDbContextTag() {
    return dbContextTag;
  }

  @Override
  public String getTableCreateSql() {
    String sql = "{{_tbi_.android.createTableSql}}";
    return sql;
  }

  @Override
  public void prepare() {
    super.prepare();
    this.dbContext.initTable(this);
  }

  @Override
  public boolean saveWithRef({{_tbi_.pb.name}} o) {
    boolean ret = super.save(o);
    if (!ret) {
      return false;
    }
{% for r in _tbi_.refFields %}
    // save {{r.pb.nameC}};
{% if r.repeated %}
    List<{{ r.pb.typeName }}> refVar{{r.column.index}} = o.get{{ r.pb.nameC }}List();
    if (null != refVar{{r.column.index}} && refVar{{r.column.index}}.size() > 0) {
      {{ r.pb.typeName }}Mapper.instance.saveWithRef(refVar{{r.column.index}});
    }
{% else %}
    if (o.has{{ r.pb.nameC }}()) {
      {{ r.pb.typeName }}Mapper.instance.saveWithRef(o.get{{ r.pb.nameC }}());
    }
{% endif %}
{% endfor %}
    return true;
  }

  @Override
  public boolean saveWithRef(List<{{_tbi_.pb.name}}> list) {
    boolean ret = super.save(list);
    if (!ret) {
      return false;
    }
    List vars = new ArrayList();
{% for r in _tbi_.refFields %}
    // save {{r.pb.nameC}};
    for(int i=0; i<list.size(); i++) {
      {{_tbi_.pb.name}} o = list.get(i);
{% if r.repeated %}
      List<{{ r.pb.typeName }}> refVar{{r.column.index}} = o.get{{ r.pb.nameC }}List();
      if(refVar{{r.column.index}}.size() > 0){
        vars.add(refVar{{r.column.index}});
      }
{% else %}
      if(o.has{{ r.pb.nameC }}()){
        vars.add(o.get{{ r.pb.nameC }}());
      }
{% endif %}
    }
    if(vars.size() > 0){
      {{ r.pb.typeName }}Mapper.instance.saveWithRef(vars);
    }
    vars.clear();
{% endfor %}

    return true;
  }

  @Override
  public boolean saveWithRef(Set<{{_tbi_.pb.name}}> set) {
    boolean ret = super.save(new ArrayList<{{_tbi_.pb.name}}>(set));
    if (!ret) {
      return false;
    }
    List vars = new ArrayList();
{% for r in _tbi_.refFields %}
    // save {{r.pb.nameC}};
    Iterator<{{_tbi_.pb.name}}> refVar{{r.column.index}} = set.iterator();
    while (refVar{{r.column.index}}.hasNext()) {
       {{_tbi_.pb.name}} o = refVar{{r.column.index}}.next();
{% if r.repeated %}
      List<{{ r.pb.typeName }}> v = o.get{{ r.pb.nameC }}List();
      if(v.size() > 0){
        vars.add(v);
      }
{% else %}
      if(o.has{{ r.pb.nameC }}()){
        vars.add(o.get{{ r.pb.nameC }}());
      }
{% endif %}
    }
    if(vars.size() > 0){
      {{ r.pb.typeName }}Mapper.instance.saveWithRef(vars);
    }
    vars.clear();
{% endfor %}

    return true;
  }

  @Override
  public boolean delete({{_tbi_.pb.name}} o) {
    if (o == null) {
      return false;
    }
    if (deleteStatement == null) {
      this.compileDeleteStatement();
    }
    deleteStatement.{{_tbi_.pk.android.binder}}(1, o.get{{ _tbi_.pk.pb.nameC }}());
    int recs = deleteStatement.executeUpdateDelete();
    return (recs == 1);
  }

  @Override
  public {{_tbi_.pb.name}} map(Cursor cursor, {{_tbi_.pb.name}} o) {
    {{_tbi_.pb.name}}.Builder builder = {{_tbi_.pb.name}}.newBuilder();

    if (cursor.isBeforeFirst()) {
      cursor.moveToFirst();
    }
{% for c in _tbi_.columns %}
    builder.set{{c.pb.nameC}}(cursor.{{c.android.rsGetter()}}({{c.index}}));
{% endfor %}

    return builder.build();
  }

{% for r in _tbi_.refFields %}
{% if r.repeated %}
  public void wrapRef{{r.pb.nameC}}(List<{{_tbi_.pb.name}}.Builder> list) {
    for (int i = 0; i < list.size(); i++) {
      {{_tbi_.pb.name}}.Builder item = list.get(i);
      wrapRef{{r.pb.nameC}}(item);
    }
  }
{% else %}
  public void wrapRef{{r.pb.nameC}}(List<{{_tbi_.pb.name}}.Builder> list) {
    Set<{{ r.column.java.typeName }}> ids = new HashSet<{{ r.column.java.typeName }}>();
    for (int i = 0; i < list.size(); i++) {
      {{_tbi_.pb.name}}.Builder item = list.get(i);
      {{ r.column.java.typeName }} val = item.get{{ r.column.pb.nameC }}();
      if (null == val || val <= 0) {
        continue;
      }
      ids.add(val);
    }
    if (ids.size() == 0){
      return;
    }
    List<{{ r.pb.typeName }}> refList = {{ r.pb.typeName }}Mapper.instance.getsWithRef(ids);
    for (int j = 0; j < refList.size(); j++) {
        {{ r.pb.typeName }} targetItem = refList.get(j);
        for (int i = 0; i < list.size(); i++) {
          {{_tbi_.pb.name}}.Builder item = list.get(i);
          {{ r.column.java.typeName }} val = item.get{{ r.column.pb.nameC }}();
          if (null == val || val <= 0) {
            continue;
          }
          if (targetItem.get{{ r.table.pk.java.getterName }}() == item.get{{ r.column.pb.nameC }}()) {
            item.set{{ r.java.setterName }}(targetItem);
          }
        }
    }
  }
{% endif %}
{% endfor %}

  @Override
  public void wrapRef(List<{{_tbi_.pb.name}}> list) {
    if(list == null || list.size() == 0) {
      return;
    }

    List<{{_tbi_.pb.name}}.Builder> builders = new ArrayList<{{_tbi_.pb.name}}.Builder>();
    for(int i=0; i<list.size(); i++){
        builders.add({{_tbi_.pb.name}}.newBuilder(list.get(i)));
    }

{% for r in _tbi_.refFields %}
    wrapRef{{ r.pb.nameC}}(builders);
{% endfor %}

    for(int i=0; i<list.size(); i++){
        list.set(i, builders.get(i).build());
    }

  }

{% for r in _tbi_.refFields %}
  public void wrapRef{{r.pb.nameC}}({{_tbi_.pb.name}}.Builder builder) {
    {{ r.column.java.typeName }} val = builder.get{{ r.column.pb.nameC }}();
    if (null == val || val <= 0) {
      return;
    }
{% if r.repeated %}
    List<{{ r.pb.typeName }}> refItems = {{ r.pb.typeName }}Mapper.instance.getsWithRef(val);
    builder.addAll{{ r.pb.nameC }}(refItems);
{% else %}
    {{ r.pb.typeName }} refItem = {{ r.pb.typeName }}Mapper.instance.getWithRef(val);
    builder.set{{ r.pb.nameC }}(refItem);
{% endif %}

  }

{% endfor %}

  @Override
  public void wrapRef({{_tbi_.pb.name}} o) {
    if(o == null) {
      return;
    }
    {{_tbi_.pb.name}}.Builder builder = {{_tbi_.pb.name}}.newBuilder(o);
{% for r in _tbi_.refFields %}
    wrapRef{{ r.pb.nameC }}(builder);
{% endfor %}
    
    o = builder.build();

  }

}
