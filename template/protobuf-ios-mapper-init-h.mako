//
//  PBMapperInit.h
//  {{prj._project_}}
//
//  Created by {{_user_}}.
//  Copyright © 2015 {{prj._company_}}. All rights reserved.
//

{% for t in ms %}
@class {{t.pb.name}}Mapper;
{% endfor %}

@interface PBMapperInit : NSObject

+(instancetype)instance;

-(void)start;

@end
