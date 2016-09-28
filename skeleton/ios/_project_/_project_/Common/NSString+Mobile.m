//
//  NSString+Mobile.m
//  _project_
//
//  Created by Yaming on 11/29/15.
//  Copyright © 2015 _project_.com. All rights reserved.
//

#import "NSString+Mobile.h"

@implementation NSString(Mobile)

- (NSString*)securyMobile{
    // 12345678901 --> 123****8901
    return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}

- (BOOL)validMobile{
    return self.length > 0 && [self hasPrefix:@"1"] && self.length == 11;
}

@end
