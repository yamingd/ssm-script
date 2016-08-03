package {{ _tbi_.java.model_ns }};

import javax.persistence.*;
import com.google.common.base.Objects;
import com.google.common.base.MoreObjects;
import org.msgpack.annotation.MessagePackMessage;
import java.util.Date;
import java.io.Serializable;

import {{ _tbi_.java.model_ns }}.{{ _tbi_.java.name }};

{% for r in _tbi_.impJavas %}
import {{r.model_ns}}.{{r.name}};
{% endfor %}


/**
 * {{ _tbi_.hint }}
 * Created by {{_user_}}.
 */
@MessagePackMessage
public class {{_tbi_.java.name }}VO extends {{ _tbi_.java.name }} {
	
    public {{_tbi_.java.name }}VO(){

    }

    public {{_tbi_.java.name }}VO({{ _tbi_.java.name }} item){

{% for col in _tbi_.columns %}
        this.set{{col.java.setterName}}(item.get{{ col.java.getterName }}());
{% endfor %}

    }

	    /****引用实体****/
{% for ref in _tbi_.refFields %}
    /**
     *
     * {{ref.docComment}}
     */
    protected {{ref.java.typeName}} {{ref.java.name}};
    public {{ref.java.typeName}} get{{ ref.java.getterName }}(){
        return this.{{ ref.java.name }};
    }
    public void set{{ ref.java.setterName }}({{ ref.java.typeName }} {{ ref.java.name }}){
        this.{{ ref.java.name }} = {{ ref.java.name }};
    }

{% endfor %} 


}