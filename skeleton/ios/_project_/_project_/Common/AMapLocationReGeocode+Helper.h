//
//  AMapLocationReGeocode+Helper.h
//  _project_
//
//  Created by Yaming on 11/30/15.
//  Copyright © 2015 _project_.com. All rights reserved.
//

#import <AMapLocationKit/AMapLocationKit.h>

@interface AMapLocationReGeocode(Helper)

- (NSString*)addressWithoutCity;

- (NSString*)addressWithoutProvince;

- (NSString*)stressAddress;

@end
