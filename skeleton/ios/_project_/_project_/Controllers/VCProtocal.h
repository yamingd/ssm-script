//
//  VCProtocal.h
//  _project_
//
//  Created by Yaming on 11/16/15.
//  Copyright © 2015 _project_.com. All rights reserved.
//

#ifndef _VCProtocal_h
#define _VCProtocal_h

@protocol FormDelegate <NSObject>

@optional

//封装数据返回
- (void)form:(id)sender didFinishWithValue:(NSDictionary*)value;

//配置controller
- (void)form:(id)sender configController:(UIViewController*)controller;

@end


#endif
