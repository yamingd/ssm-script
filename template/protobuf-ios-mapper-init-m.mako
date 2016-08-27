//
//  PBMapperInit.m
//  {{prj._project_}}
//
//  Created by {{_user_}}.
//  Copyright © 2015 {{prj._company_}}. All rights reserved.
//

#import "PBMapperInit.h"

{% for minfo in prj._modules_ %}
{% if minfo['ns'] != 'system' %}
// {{minfo['ns']}}
{% for t in minfo['tables'] %}
#import "{{t.pb.name}}Mapper.h"
{% endfor %}
{% endif %}
{% endfor %}

@implementation PBMapperInit

+(instancetype)instance{
    static PBMapperInit *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[PBMapperInit alloc] init];
    });
    return _shared;
}

-(instancetype)init{
    self = [super init];
    return self;
}

-(void)start{

{% for minfo in prj._modules_ %}
{% if minfo['ns'] != 'system' %}
	// {{minfo['ns']}}
{% for t in minfo['tables'] %}
	[[{{t.pb.name}}Mapper instance] prepare];
{% endfor %}
{% endif %}
{% endfor %}

}

@end
