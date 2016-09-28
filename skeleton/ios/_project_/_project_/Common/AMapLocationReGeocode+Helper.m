//
//  AMapLocationReGeocode+Helper.m
//  _project_
//
//  Created by Yaming on 11/30/15.
//  Copyright © 2015 _project_.com. All rights reserved.
//

#import "AMapLocationReGeocode+Helper.h"

@implementation AMapLocationReGeocode(Helper)

- (NSString*)addressWithoutCity{
    NSString* str = self.formattedAddress;
    
    str = [str stringByReplacingOccurrencesOfString:self.province withString:@""];
    str = [str stringByReplacingOccurrencesOfString:self.city withString:@""];
    
    return str;
}

- (NSString*)addressWithoutProvince{
    NSString* str = self.formattedAddress;
    
    str = [str stringByReplacingOccurrencesOfString:self.province withString:@""];

    return str;
}

- (NSString*)stressAddress{
    NSString* str = self.formattedAddress;
    
    str = [str stringByReplacingOccurrencesOfString:self.province withString:@""];
    str = [str stringByReplacingOccurrencesOfString:self.city withString:@""];
    str = [str stringByReplacingOccurrencesOfString:self.district withString:@""];
    
    return str;
}

@end
