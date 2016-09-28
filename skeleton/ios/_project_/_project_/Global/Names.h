//
//  Names.h
//  _project_
//
//  Created by Yaming on 11/15/15.
//  Copyright © 2015 _project_.com. All rights reserved.
//

#ifndef Names_h
#define Names_h

typedef enum : NSUInteger {
    LoginWithUserName = 1,
    LoginWithMobile = 2,
    LoginWithAuto = 3
} LoginMode;

typedef enum : NSUInteger {
    UserKindCustomer = 1,
    UserKindShopOwner = 2,
    UserKindDeliver = 3,
} UserKind;

#define kMobileCodeCountDown 120

#define TAG_SIGNIN @"signin"
#define TAG_SIGNUP @"signup"
#define TAG_MOBILE_UPDATE @"mobile_update"
#define TAG_PASSWD_UPDATE @"passwd_update"

#define kStoryBoardForShop @"Shop"
#define kStoryBoardForDeliver @"Deliver"
#define kStoryBoardForBuyer @"Buyer"

#define kCurrentUserKey @"currentUser"
#define kCurrentStoreKey @"currentStore"
#define kSessionLocationKey @"location"
#define kSessionRegionKey @"region"
#define kSessionCartKey @"cart"

#define kNotificationLocationOK @"NotificationLocationOK"
#define kNotificationLocationFailed @"NotificationLocationFailed"
#define kNotificationAreaPicked @"NotificationAreaPicked"
#define kNotificationAreaMissing @"NotificationAreaMissing"
#define kNotificationOrderDelivered @"NotificationOrderDelivered"
#define kNotificationGoodsCategoryDeleted @"NotificationGoodsCategoryDeleted"

#define imageHttpUrl(url) [NSString stringWithFormat:@"%@%@%@", kImageDomainUrl, kImageUrlPrefix, url]
#define Font(F) [UIFont systemFontOfSize:(F)]

#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define scale [UIScreen mainScreen].scale

#endif /* Names_h */
