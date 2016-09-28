//
//  pb-models-all.h
//  {{prj._project_}}
//
//  Created by {{_user_}}.
//  Copyright © 2015 {{prj._company_}}. All rights reserved.
//

#ifndef PB_MODELS_ALL_H
#define PB_MODELS_ALL_H

{% for t in ms %}
#import "{{t.pb.name}}Proto.pb.h"
{% endfor %}

#endif