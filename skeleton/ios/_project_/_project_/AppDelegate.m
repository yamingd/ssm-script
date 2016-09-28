//
//  AppDelegate.m
//  _project_
//
//  Created by Yaming on 10/4/15.
//  Copyright © 2015 _company_.com. All rights reserved.
//

#import "AppDelegate.h"
#import "AppConfig.h"
#import "PBMapperInit.h"
#import "PBUserService.h"
#import "PBSessionService.h"
#import "UMMobClick/MobClick.h"
#import "UMessage.h"

@interface AppDelegate (){
    AMapLocationManager* locationManager;
    BOOL locationError;
    BOOL locationHit;
}
@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    LOG(@"willFinishLaunchingWithOptions");

    [self application:application prepareAppSession:launchOptions];
    [self application:application prepareDatabase:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.tintColor = kTintColor;
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          nil]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor paperColorGray900]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self application:application prepareRootController:launchOptions];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Set the app badge to 0 when coming to front
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

-(NSString*)getAppNameString{
    return kAppName;
}

-(BOOL)shouldEnableAPNS{
    return kAppAPNSEnable;
}

#pragma mark - Application Prepare

- (void)application:(UIApplication *)application prepareAppSession:(NSDictionary *)launchOptions{
    [super application:application prepareAppSession:launchOptions];
    [AppSession current].flash = [NSMutableDictionary dictionary];
    LOG(@"app sesssion: %@", [AppSession current].session);
    LOG(@"cookieId: %@, cookieSalt: %@, seed: %@", kAppCookieId, kAppCookieSalt, kAesSeed);
    [[AppSecurity instance] config:kAppCookieId salt:kAppCookieSalt aesSeed:kAesSeed];
    APIClient* client = [[APIClient shared] initWithApiBase:kAppAPIBaseUrl];
    [client resetHeaderValue];
    [client test];
}
- (void)application:(UIApplication *)application prepareComponents:(NSDictionary *)launchOptions{
    
    // Set out NSURLCache settings
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    UMConfigInstance.appKey = kTongJiKey;
    UMConfigInstance.channelId = nil;
    UMConfigInstance.bCrashReportEnabled = YES;
    UMConfigInstance.ePolicy = BATCH;
    [MobClick startWithConfigure:UMConfigInstance];
    
    [self startLocationManager];
    [self regSMSSDK];
    
}
- (void)application:(UIApplication *)application prepareDatabase:(NSDictionary *)launchOptions{
    [super application:application prepareDatabase:launchOptions];
    [[PBMapperInit instance] start];
}
- (void)application:(UIApplication *)application prepareOpenControllers:(NSDictionary *)launchOptions{
    [super application:application prepareOpenControllers:launchOptions];
}
- (void)application:(UIApplication *)application prepareRootController:(NSDictionary *)launchOptions{
    if ([AppSession current].isSignIn) {
        
        [PBSessionService autoLogin:^(id response, NSError *error, BOOL local) {
            LOG(@"autoLogin: %@", response);
            if (response) {
                LOG(@"user: %@", response);
            }else{
                [EventPoster send:kNotificationAccountSignout userInfo:nil];
            }
        }];
        
        UIViewController *rootVC = [XibFactory productWithStoryboardName:kRootStoryBoard identifier:kMainController];
        [self.window setRootViewController:rootVC];
    }else{
        UIViewController *rootVC = [XibFactory productWithStoryboardName:kRootStoryBoard identifier:kRootController];
        [self.window setRootViewController:rootVC];
    }
}

#pragma mark - Global Methods

-(void)application:(UIApplication *)application prepareAPNSToken:(NSDictionary *)launchOptions{
    //set AppKey and AppSecret
    [UMessage startWithAppkey:kAPNSKey launchOptions:launchOptions];
    LOG(@"prepareAPNSToken. %@", kAPNSKey);
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action_accept";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action_reject";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    //for log
    [UMessage setLogEnabled:YES];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [[AppSession current] saveDeviceToken:deviceTokenStr];
    if ([AppSession current].session.userId > 0) {
        [PBUserService saveDevice:deviceTokenStr withCallback:^(id response, NSError *error, BOOL local) {
            
        }];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}

#pragma mark - SMS
- (void)regSMSSDK{
//    [SMSSDK registerApp:kSMSKey withSecret:kSMSSceret];
}

#pragma mark - Location Manager

- (void)startLocationManager{
    [AMapServices sharedServices].apiKey = kAMapKey;
    locationManager = [[AMapLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    locationHit = 0;
    [self findLocation:YES];
}

-(BOOL)checkLocationStatus{
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status==kCLAuthorizationStatusNotDetermined) {
        return YES;
    }
    
    if (status==kCLAuthorizationStatusDenied) {
        return NO;
    }
    
    if (status==kCLAuthorizationStatusRestricted) {
        return YES;
    }
    
    if (status==kCLAuthorizationStatusAuthorizedAlways) {
        return YES;
    }
    
    if (status==kCLAuthorizationStatusAuthorizedWhenInUse) {
        return YES;
    }
    
    return NO;
    
}

- (void)findLocation:(BOOL)errorNotice{
    
    // 带逆地理（返回坐标和地址信息
    
    locationError = NO;
    locationHit = NO;
    
    [locationManager requestLocationWithReGeocode:YES
                                  completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
  
        if (error && !locationError){
            locationError = YES;
            [[AppSession current].flash removeObjectForKey:kSessionRegionKey];
            if (errorNotice) {
                [EventPoster send:kNotificationLocationFailed userInfo:nil];
            }
            
            LOG(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed){
                return;
            }
        }
        
        LOG(@"location[%d]:%@", locationHit, location);
        
        if (regeocode && !locationHit){
            locationHit = YES;
            LOG(@"reGeocode:%@", regeocode);
            
            [[AppSession current].flash setObject:regeocode forKey:kSessionLocationKey];
            [[AppSession current].flash setObject:@(location.coordinate.latitude) forKey:@"latitude"];
            [[AppSession current].flash setObject:@(location.coordinate.longitude) forKey:@"longitude"];
            
            [PBRegionService create:regeocode withCallback:^(id response, NSError *error, BOOL local) {
                locationHit = NO;
                if (response) {
                    [[AppSession current].flash setObject:response forKey:kSessionRegionKey];
                    [EventPoster send:kNotificationLocationOK userInfo:@{@"region": response}];
                }else{
                    [[AppSession current].flash removeObjectForKey:kSessionRegionKey];
                    if (errorNotice) {
                        [EventPoster send:kNotificationLocationFailed userInfo:nil];
                    }
                }
            }];
        }
                                  
    }];
}

#pragma mark - Global Event

-(void)onNetworkLost{
    
}

-(void)onNetworkReconnect{
    
}

-(void)onAccountSignin:(NSNotification*)notification{
    //NSDictionary *dictionary = [notification userInfo];
}

-(void)onAccountSignout:(NSNotification*)notification{
    //NSDictionary *dictionary = [notification userInfo];
    UIViewController *rootVC = [XibFactory productWithStoryboardName:kRootStoryBoard identifier:kRootController];
    [self.window setRootViewController:rootVC];
}

@end
