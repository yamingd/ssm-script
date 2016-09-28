//
//  BaseTableVC.h
//  _project_
//
//  Created by Yaming on 11/16/15.
//  Copyright © 2015 _project_.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCProtocal.h"

@interface BaseTableVC : UITableViewController <FormDelegate>

@property(weak, nonatomic)id<FormDelegate> finishedDelegate;

@property (nonatomic, strong) NSMutableArray *dataSource;

// 设置回系统自带的group tableview样式
- (void)setSystomGroupTableStyle;
- (void)removeTableViewExtraSpace;

- (UIColor*)getBgColor;

- (void)initBgView:(UIColor*)bgcolor;

- (void)initHideKeyBoardEvent;

@end
