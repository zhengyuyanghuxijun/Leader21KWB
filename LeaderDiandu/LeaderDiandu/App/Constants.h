//
//  Constants.h
//  PaipaiGou
//
//  Created by Levin on 7/10/12.
//  Copyright (c) 2012 ilovedev.com. All rights reserved.
//

//开发调试阶段开启宏，用于区分调试代码，添加调试功能，发布版注释掉。
#define TEST_MODE


// 支持下载时暂停的宏
#define SUPPORT_PAUSE_IN_DOWNLAOD


//友盟相关
#define UMENG_KEY       @"5384b1d756240b0a910fbcc5"
#define UMENG_KEY_IPAD  @"53b22b1656240b9c0b0047db"
#define QQ_APPID  @"1101318393"
#define QQ_APPID_IPAD  @"1101817844"
#define WX_APPID    @"wxb940ac4e015146cb"

#define EXAMINE_SHARE_TEXT @"我完成了点读英语测评，成绩不错，你也来试试 http://www.61dear.com/diandu.jsp"

#define EXPERIENCE_SHARE_TEXT @"会发声的英语图书，美国原版图书，你也来试试 http://www.61dear.com/diandu.jsp"

#define SERVICE_PHONE_NUMBER @"4008126161"
#define SERVICE_PHONE_NUMBER_SHOW @"400-812-6161"

// 通知定义
#define kNotification_bookDownloadProgress  @"kNotification_bookDownloadProgress"

#define kNotification_LoginSuccess       @"kNotification_LoginSuccess"
#define kNotification_LoginOut           @"kNotification_LoginOut"

//暂停全部下载通知
#define kNotification_PauseAllDownload   @"kNotification_PauseAllDownload"
#define kNotification_ReadBookBack       @"kNotification_ReadBookBack"

#define kNotification_GetMsgSuccess      @"kNotification_GetMsgSuccess"
#define kNotification_GetExamSuccess     @"kNotification_GetExamSuccess"
//学生购买VIP成功
#define kNotification_PayVIPSuccess      @"kNotification_PayVIPSuccess"

#define kNotification_ChangeSubscribeSuccess       @"kNotification_ChangeSubscribeSuccess"

#define kNotification_logoutByForce       @"kNotification_logoutByForce"


#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define RGBACOLOR(r,g,b,a)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#ifdef USE_APPLE_PAY
#define RMB(x) [NSString stringWithFormat:@"%.2f 金币", x]
#else
#define RMB(x) [NSString stringWithFormat:@"¥ %.2f", x]
#endif

#define FONT_HEITI_BOLD(x)  [UIFont fontWithName:@"STHeitiTC-Medium" size:(x)]
#define FONT_HEITI(x)       [UIFont fontWithName:@"STHeitiTC-Light" size:(x)]
