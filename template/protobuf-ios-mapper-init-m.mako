//
//  PBMapperInit.m
//  {{prj._project_}}
//
//  Created by {{_user_}}.
//  Copyright © 2015 {{prj._company_}}. All rights reserved.
//

#import "PBMapperInit.h"

{% for t in ms %}
#import "{{t.pb.name}}Mapper.h"
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

{% for t in ms %}
	[[{{t.pb.name}}Mapper instance] prepare];
{% endfor %}

}

@end
