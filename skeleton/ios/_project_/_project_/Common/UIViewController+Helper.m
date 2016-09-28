//
//  UIViewController+MDToast.m
//  _project_
//
//  Created by Yaming on 11/17/15.
//  Copyright © 2015 _project_.com. All rights reserved.
//

#import "UIViewController+Helper.h"
#import <MaterialControls/MDToast.h>
#import "CRToast/CRToast.h"
#import "SCLAlertView.h"
#import "NavigationController.h"
#import "PBSMSService.h"

@implementation UIViewController(Helper)

-(void)showToast:(NSString*)msg{
    MDToast *toast = [[MDToast alloc] initWithText:msg duration:kMDToastDurationLong];
    [toast show];
}

-(void)showCRError:(NSString*)msg{
    
    NSDictionary *options = @{
                              kCRToastTextKey : msg,
                              kCRToastTimeIntervalKey: @(3.0),
                              kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastBackgroundColorKey : kNoticeError,
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastImageKey: [UIImage imageNamed:@"ic_error_white"],
                              kCRToastInteractionRespondersKey: @[[CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap
                                                                                                                  automaticallyDismiss:YES
                                                                                                                                 block:^(CRToastInteractionType interactionType) {
                                                                                                                                     
                                                                                                                                 }]]
                              };
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    
                                }];
}

-(void)showCRErrorWithTapAction:(NSString*)msg block:(void(^)(void))block{
    
    NSDictionary *options = @{
                              kCRToastTextKey : msg,
                              kCRToastForceUserInteractionKey: @YES,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastBackgroundColorKey : kNoticeError,
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastImageKey: [UIImage imageNamed:@"ic_error_white"],
                              kCRToastInteractionRespondersKey: @[[CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap
                                                                                                                  automaticallyDismiss:YES
                                                                                                                                 block:^(CRToastInteractionType interactionType) {
                                                                                                                                     block();
                                                                                                                                 }]]
                              };
    
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    
                                }];
    
}

-(void)showCRSuccess:(NSString*)msg{
    
    NSDictionary *options = @{
                              kCRToastTextKey : msg,
                              kCRToastTimeIntervalKey: @(1.5),
                              kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastBackgroundColorKey : kNoticeSuccess,
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastImageKey: [UIImage imageNamed:@"ic_done_white"],
                              kCRToastInteractionRespondersKey: @[[CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap
                                                                                                                  automaticallyDismiss:YES
                                                                                                                                 block:^(CRToastInteractionType interactionType) {
                                                                                                                                     
                                                                                                                                 }]]
                              };
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    
                                }];
    
}

-(void)requestMobileCode:(NSString*)mobile tag:(NSString *)tag{
//    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
//                            phoneNumber:mobile zone:@"86" customIdentifier:nil result:^(NSError *error) {
//        
//                                if (error) {
//                                    LOG(@"错误吗：%@ ",error);
//                                    [self showToast:@"获取验证码错误，请稍候再试~~"];
//                                    [self onRequestMobileCodeError];
//                                }
//    }];
    LOG(@"requestMobileCode: %@, %@", mobile, tag);
    [PBSMSService getVerifyCode:tag mobile:mobile withCallback:^(id response, NSError *error, BOOL local) {
        if (error) {
            LOG(@"错误吗：%@ ",error);
            [self showCRError:@"获取验证码错误，请稍候再试~~"];
            [self onRequestMobileCodeError];
        }
    }];
    
}

- (void)checkMobileCode:(NSString*)passcode mobile:(NSString*)mobile tag:(NSString*)tag callback:(MobileCodeCheckResult)callback{
    
//    [SMSSDK commitVerificationCode:passcode phoneNumber:mobile zone:@"86" result:^(NSError *error) {
//        if (error) {
//            LOG(@"错误吗：%@ ",error);
//            [self showCRError:@"您输入的验证码错误，请重新输入~~"];
//        }else{
//            //[self showCRSuccess:@"您输入的验证码正确"];
//            callback(error);
//        }
//    }];
    
    [PBSMSService checkCode:tag mobile:mobile code:passcode withCallback:^(id response, NSError *error, BOOL local) {
        if (error) {
            LOG(@"错误吗：%@ ",error);
            [self showCRError:@"您输入的验证码错误，请重新输入~~"];
        }else{
            //[self showCRSuccess:@"您输入的验证码正确"];
            callback(error);
        }
    }];
    
}

-(void)onRequestMobileCodeError{
    
}

- (void)initUIBarButtonLeft{
    // set back item title
//    UIBarButtonItem *backitem = [UIBarButtonItem new];
//    backitem.title = @"返回";
//    self.navigationItem.backBarButtonItem = backitem;
}

- (void)initUIBarButtonRight{
    
}

- (void)popupVC:(UIViewController*)vc{
    NavigationController* uvc = [[NavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:uvc animated:YES completion:^{
        
    }];
}

- (void)makeImageTouch:(UIImageView*)imageView action:(SEL)action{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:action];
    [gesture setNumberOfTapsRequired:1];
    [imageView setUserInteractionEnabled:YES];
    [imageView addGestureRecognizer:gesture];
}

- (void)makeViewTouch:(UIView*)view action:(SEL)action{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:action];
    [gesture setNumberOfTapsRequired:1];
    [view setUserInteractionEnabled:YES];
    [view addGestureRecognizer:gesture];
}

- (void)setNavStyle{
    
    self.navigationController.navigationBar.tintColor = kNavTitleColor;
    self.navigationController.navigationBar.backItem.titleView.tintColor = kNavTitleColor;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   kNavTitleColor, NSForegroundColorAttributeName,
                                                                   nil];
    
}

- (void)resetNavStyle{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                   nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)setNavBarTint{
    //UIColor* tintColor = [UIColor paperColorBlue];
    self.navigationController.navigationBar.barTintColor = kTintColor;
    self.navigationController.navigationBar.translucent = NO;
}

- (SCLAlertView*)newAlertView{
    // Get started
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.backgroundViewColor = [UIColor paperColorGray100];
    alert.customViewColor = [UIColor paperColorDeepOrange];
    [self.view endEditing:YES];
    return alert;
}

- (SCLAlertView*)showWaiting:(NSString*)title msg:(NSString*)msg{
    SCLAlertView* view = [self newAlertView];
    [view showWaiting:self title:title subTitle:msg closeButtonTitle:nil duration:0.0f];
    return view;
}

@end
