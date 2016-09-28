//
//  AppConfig.h
//  _project_
//
//  Created by Yaming on 11/24/15.
//  Copyright © 2015 _project_.com. All rights reserved.
//

#ifndef AppConfig_Agent_h
#define AppConfig_Agent_h

// 顾客版配置
#undef kAppName
#undef kAppTitle
#undef kRootStoryBoard
#undef kRootController
#undef kSMSKey
#undef kSMSSceret
#undef kRegisterUserKind
#undef kRegisterActionSegue
#undef kSigninLoginIdTitle
#undef kSigninActionSegue
#undef kMainController

#undef kTongJiKey
#define kTongJiKey @"_project_"

#undef kAPNSKey
#define kAPNSKey @"_project_"

#define kRootStoryBoard @"Main"
#define kRootController @"MainTabsController"
#define kAppName @"_project_"
#define kAppTitle @"_project_"

#define kRegisterUserKind 1
#define kMainController @"MainTabsController"
#define kSigninLoginIdTitle @"_project_"
#define kSigninActionSegue @"MainSigninController"

#ifdef DEBUG

// com.bwm.buyer.dev

#undef kAMapKey
#define kAMapKey @"_project_"

#endif

#ifdef RELEASE

// com.bwm.buyer

#undef kAMapKey
#define kAMapKey @"_project_"

#endif

#endif /* AppConfig_Agent_h */
