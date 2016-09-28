//
//  AppDelegate.h
//  _project_
//
//  Created by _user_ on 10/4/15.
//  Copyright © 2015 _company_.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "iOSBootstrap/AppBootstrap.h"
#import "AMapFoundationKit/AMapFoundationKit.h"
#import "AMapLocationKit/AMapLocationKit.h"

@interface AppDelegate : AppBootstrap

- (void)findLocation:(BOOL)errorNotice;

-(BOOL)checkLocationStatus;

@end

