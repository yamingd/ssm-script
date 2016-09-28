//
//  UIViewController+MDToast.h
//  _project_
//
//  Created by Yaming on 11/17/15.
//  Copyright © 2015 _project_.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MobileCodeCheckResult)(NSError*);

@class SCLAlertView;

@interface UIViewController(Helper)

- (void)showToast:(NSString*)msg;

- (void)showCRError:(NSString*)msg;

- (void)showCRErrorWithTapAction:(NSString*)msg block:(void(^)(void))block;

- (void)showCRSuccess:(NSString*)msg;

- (SCLAlertView*)showWaiting:(NSString*)title msg:(NSString*)msg;

- (void)requestMobileCode:(NSString*)mobile tag:(NSString*)tag;

- (void)checkMobileCode:(NSString*)passcode mobile:(NSString*)mobile tag:(NSString*)tag callback:(MobileCodeCheckResult)callback;

- (void)onRequestMobileCodeError;

- (void)initUIBarButtonLeft;
- (void)initUIBarButtonRight;

- (void)popupVC:(UIViewController*)vc;
- (void)makeImageTouch:(UIImageView*)imageView action:(SEL)action;
- (void)makeViewTouch:(UIView*)view action:(SEL)action;

- (void)setNavStyle;
- (void)resetNavStyle;
- (void)setNavBarTint;

- (SCLAlertView*)newAlertView;

@end
