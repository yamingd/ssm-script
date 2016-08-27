package com.{{prj._company_}}.{{prj._project_}}.mapper;

{% for minfo in prj._modules_ %}
{% if minfo['ns'] != 'system' %}
{% for t in minfo['tables'] %}
import {{ t.android.mapper_ns }}.{{t.pb.name}}Mapper;
{% endfor %}
{% endif %}
{% endfor %}

public final class PBMapperInit {

{% for minfo in prj._modules_ %}
{% if minfo['ns'] != 'system' %}
{% for t in minfo['tables'] %}
      public static {{t.pb.name}}Mapper {{t.pb.varName}}Mapper;
{% endfor %}
{% endif %}
{% endfor %}

  static {

{% for minfo in prj._modules_ %}
{% if minfo['ns'] != 'system' %}
{% for t in minfo['tables'] %}
      {{t.pb.varName}}Mapper = new {{t.pb.name}}Mapper();
{% endfor %}
{% endif %}
{% endfor %}

  }

  public static void prepare() {
{% for minfo in prj._modules_ %}
{% if minfo['ns'] != 'system' %}
{% for t in minfo['tables'] %}
      {{t.pb.varName}}Mapper.prepare();
{% endfor %}
{% endif %}
{% endfor %}
  }

  public static void reset() {
{% for minfo in prj._modules_ %}
{% if minfo['ns'] != 'system' %}
{% for t in minfo['tables'] %}
      {{t.pb.varName}}Mapper.resetStatement();
{% endfor %}
{% endif %}
{% endfor %}
  }
}
