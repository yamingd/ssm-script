package com.{{prj._company_}}.{{prj._project_}}.mapper;

{% for t in ms %}
import {{ t.android.mapper_ns }}.{{t.pb.name}}Mapper;
{% endfor %}

public final class PBMapperInit {

{% for t in ms %}
      public static {{t.pb.name}}Mapper {{t.pb.varName}}Mapper;
{% endfor %}

  static {

{% for t in ms %}
      {{t.pb.varName}}Mapper = new {{t.pb.name}}Mapper();
{% endfor %}

  }

  public static void prepare() {
{% for t in ms %}
      {{t.pb.varName}}Mapper.prepare();
{% endfor %}
  }

  public static void reset() {
{% for t in ms %}
      {{t.pb.varName}}Mapper.resetStatement();
{% endfor %}
  }
}
