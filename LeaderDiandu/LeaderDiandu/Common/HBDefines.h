//
//  HBDefines.h
//  LediKWB
//
//  Created by ChunGuo on 15/12/11.
//  Copyright © 2015年 MERI. All rights reserved.
//

//#import "CocoaLumberjack.h"

#pragma mark - 屏幕尺寸
//设备全屏尺寸
#define HBFullScreenSize       [UIScreen mainScreen].bounds.size
//设备全屏宽度
#define HBFullScreenWidth      [UIScreen mainScreen].bounds.size.width
//设备全屏高度
#define HBFullScreenHeight     [UIScreen mainScreen].bounds.size.height

#define HBStatusBarHeight      20
#define HBNavBarHeight         64
#define HBTabBarHeight         49


#pragma mark - 网络相关

#define LEADER_SERVICE_RELEASE  1

#define KEnableThirdPay 0

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


#pragma mark - 第三方库key

static NSString *const UMENG_KEY        = @"5384b1d756240b0a910fbcc5";
static NSString *const UMENG_KEY_IPAD   = @"53b22b1656240b9c0b0047db";
static NSString *const QQ_APPID         = @"1101318393";
static NSString *const QQ_APPID_IPAD    = @"1101817844";
static NSString *const WX_APPID         = @"wxb940ac4e015146cb";
static NSString *const KWBBuglyAppID    = @"900014908";


#pragma mark - 常用与通用字符串

//提交App Store生成的AppID
static NSString *const KAppleID = @"1052643347";
//App Store地址
static NSString *const kAppStoreUrl     = @"https://itunes.apple.com/us/app/id1052643347?l=zh&ls=1&mt=8";
static NSString *const kAppLookupUrl    = @"http://itunes.apple.com/cn/lookup?id=1052643347";

static NSString *const kStringNetError = @"无法连接网络，请检查网络设置";
static NSString *const kStringNetError1011 = @"无法连接到服务器";
static NSString *const kStringUploadError = @"头像上传失败，请重试";
static NSString *const kStringLoading = @"正在提交...";

#define KAppVerValue [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


#pragma mark - 请求返回码
static NSString *const kRunCodeSuccess = @"1000";
static NSString *const kRunCodeTokenIdInvalid = @"1005";        //授权过期
static NSString *const kRunCodeIMEIInconsistency = @"1006";     //被踢下线


#pragma mark - 颜色转换

//十进制颜色转换
#define RGB(r,g,b)         [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r,g,b,a)      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
//适用于RGB颜色相同的场景
#define RGBEQ(rgb) [UIColor colorWithRed:(rgb)/255.0 green:(rgb)/255.0 blue:(rgb)/255.0 alpha:1.0f]
#define RGBEQA(rgb,a) [UIColor colorWithRed:(rgb)/255.0 green:(rgb)/255.0 blue:(rgb)/255.0 alpha:a]
//十六进制颜色转换（0xFFFFFF）
#define HEXRGBCOLOR(hex)        [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]
#define HEXRGBACOLOR(hex,a)     [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:a]

#define KLeaderRGB HEXRGBCOLOR(0xff8903)


#pragma mark - UI效果参数
static CGFloat  const   kBlurRadiusNumber = 30.0;
static CGFloat  const   kTableViewFooterHeight = 15.0;
static NSUInteger const kThumbAvatarWidth  = 100;   //头像大小
static NSUInteger const kThumbAvatarLWidth  = 300;  //头像大小
static NSUInteger const kThumbPicWidth  = 600;      //其他图片大小

#define HBNavItemImgMargin ((isIPhone4 || isIPhone5 || isIPhone6) ? 7.0 : 15.0)

#define FONT_HEITI_BOLD(x)  [UIFont fontWithName:@"STHeitiTC-Medium" size:(x)]
#define FONT_HEITI(x)       [UIFont fontWithName:@"STHeitiTC-Light" size:(x)]


#pragma mark - 适配

#define  SYSTEM_VERSION  [[[UIDevice currentDevice] systemVersion] floatValue]

#define  IOS7_Later      ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0)
#define  IOS8_Later      ([[[UIDevice currentDevice] systemVersion]floatValue] >= 8.0)
#define  IOS9_Later      ([[[UIDevice currentDevice] systemVersion]floatValue] >= 9.0)

#define isIPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


#pragma mark - 通知命名常量
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


#pragma mark - 访问权限提示语
static NSString *const kPhotoAuthTitle    = @"相册授权未开启";//相册权限
static NSString *const kPhotoAuthMsg      = @"此应用没有权限访问你的照片或视频，你可以在“设置-课外宝”中启用访问";
static NSString *const kCameraAuthTitle   = @"相机授权未开启";//相机权限
static NSString *const kCameraAuthMsg     = @"此应用没有权限访问你的相机，你可以在“设置-课外宝”中启用访问";
static NSString *const kLocationAuthTitle = @"定位服务未开启";//定位权限
static NSString *const kLocationAuthMsg   = @"此应用没有权限访问你的位置，你可以在“设置-课外宝”中启用访问";


#pragma mark - 沙盒目录
static NSString *const KCachePathVersionInfo = @"VersionInfo.txt";
static NSString *const KCachePathPreInfo = @"PreInfo.txt";
static NSString *const KDatabaseName = @"LediKWB.db";
static NSString *const KFriendListTable = @"FriendListTable";


#pragma mark - 调试模式开关
//调试模式－开
//static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
static const BOOL MRDebug = YES;
//打上线包－关
//static const DDLogLevel ddLogLevel = DDLogLevelOff;
//static const BOOL MRDebug = NO;
