//
//  AppDefine.h
//  LeaderDiandu
//
//  Created by xijun on 15/10/1.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#ifndef LeaderDiandu_AppDefine_h
#define LeaderDiandu_AppDefine_h

//开发调试阶段开启宏，用于区分调试代码，添加调试功能，发布版注释掉。
#define TEST_MODE

// 支持下载时暂停的宏
#define SUPPORT_PAUSE_IN_DOWNLAOD

#define LEADER_SERVICE_RELEASE  1

#define KEnableThirdPay 0

#define SYSTEM_VERSION ([[UIDevice currentDevice].systemVersion floatValue])

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define isRetina ([[UIScreen mainScreen] scale] > 1.0 ? YES : NO)

#define APP_DELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define KWBAppKey       @"app_key"

#if LEADER_SERVICE_RELEASE
static NSString *const KAppKeyKWB = @"3164809f635225668555a168d42b8f4c908aa02e";
static NSString *const SERVICEAPI = @"http://reader.61dear.com";
static NSString *const CONTENTAPI = @"http://teach.61dear.com:9081";
#else
//static NSString *const KAppKeyKWB = @"a8cffcee338038dd35d9e81ad93540d9c1b13e5d";
static NSString *const KAppKeyKWB = @"3164809f635225668555a168d42b8f4c908aa02e";
static NSString *const SERVICEAPI = @"http://teach.61dear.cn:9080";
static NSString *const CONTENTAPI = @"http://teach.61dear.cn:9081";
#endif
static NSString *const BOOKIMGURL = @"http://teach.61dear.com:9083";
static NSString *const KHBBookImgFormatUrl = @"http://teach.61dear.com:9083/bookImgStorage/%@.jpg?t=BASE64(%@)";

//友盟相关
static NSString *const UMENG_KEY        = @"5384b1d756240b0a910fbcc5";
static NSString *const UMENG_KEY_IPAD   = @"53b22b1656240b9c0b0047db";
static NSString *const QQ_APPID         = @"1101318393";
static NSString *const QQ_APPID_IPAD    = @"1101817844";
static NSString *const WX_APPID         = @"wxb940ac4e015146cb";
static NSString *const KWBBuglyAppID    = @"900014908";


static NSString *const kAppLookupUrl    = @"http://itunes.apple.com/cn/lookup?id=1052643347";
static NSString *const kAppStoreUrl     = @"https://itunes.apple.com/us/app/id1052643347?l=zh&ls=1&mt=8";
//@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@"

// 通知定义
static NSString *const kNotification_bookDownloadProgress = @"kNotification_bookDownloadProgress";

static NSString *const kNotification_LoginSuccess = @"kNotification_LoginSuccess";
static NSString *const kNotification_LoginOut = @"kNotification_LoginOut";

//暂停全部下载通知
static NSString *const kNotification_PauseAllDownload = @"kNotification_PauseAllDownload";
static NSString *const kNotification_ReadBookBack = @"kNotification_ReadBookBack";

static NSString *const kNotification_GetMsgSuccess = @"kNotification_GetMsgSuccess";
static NSString *const kNotification_GetExamSuccess = @"kNotification_GetExamSuccess";
//学生购买VIP成功
static NSString *const kNotification_PayVIPSuccess = @"kNotification_PayVIPSuccess";

static NSString *const kNotification_ChangeSubscribeSuccess = @"kNotification_ChangeSubscribeSuccess";

static NSString *const KHBTestWorkPath      = @"HBTestWork";

#define KLeaderRGB [UIColor colorWithHex:0xff8903]

#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0f]
//适用于RGB颜色相同的场景
#define RGBEQ(rgb) [UIColor colorWithRed:(rgb)/255.0 green:(rgb)/255.0 blue:(rgb)/255.0 alpha:1.0f]
#define RGBEQA(rgb,a) [UIColor colorWithRed:(rgb)/255.0 green:(rgb)/255.0 blue:(rgb)/255.0 alpha:a]

#define FONT_HEITI_BOLD(x)  [UIFont fontWithName:@"STHeitiTC-Medium" size:(x)]
#define FONT_HEITI(x)       [UIFont fontWithName:@"STHeitiTC-Light" size:(x)]

#endif
