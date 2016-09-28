//
//  BaseViewController.h
//  _project_
//
//  Created by Yaming on 11/16/15.
//  Copyright © 2015 _project_.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCProtocal.h"

@interface BaseVC : UIViewController <FormDelegate>

@property(weak, nonatomic)id<FormDelegate> finishedDelegate;

- (void)configTableView:(UITableView*)tableView bgcolor:(UIColor*)bgcolor;

- (void)initHideKeyBoardEvent;;

@end
