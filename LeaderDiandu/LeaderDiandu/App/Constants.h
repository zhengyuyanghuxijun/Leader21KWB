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

//使用苹果内购方式充金币
#define USE_APPLE_PAY

//通用内购产品定义

#define IN_APP_PURCHASE_GENERAL_ITEM1 @"dianyu_tier1" //  6
#define IN_APP_PURCHASE_GENERAL_ITEM5 @"dianyu_tier5" //  32
#define IN_APP_PURCHASE_GENERAL_ITEM10 @"dianyu_tier10" // 75
#define IN_APP_PURCHASE_GENERAL_ITEM26 @"dianyu_tier26" // 190
#define IN_APP_PURCHASE_GENERAL_ITEM50 @"dianyu_tier50" // 380
#define IN_APP_PURCHASE_GENERAL_ITEM55 @"dianyu_tier55" // 580

#define IN_APP_PURCHASE_GENERAL_PAD_ITEM1 @"diandupad_tier1" //  6
#define IN_APP_PURCHASE_GENERAL_PAD_ITEM5 @"diandupad_tier5" //  32
#define IN_APP_PURCHASE_GENERAL_PAD_ITEM10 @"diandupad_tier10" // 75
#define IN_APP_PURCHASE_GENERAL_PAD_ITEM26 @"diandupad_tier26" // 190
#define IN_APP_PURCHASE_GENERAL_PAD_ITEM50 @"diandupad_tier50" // 380
#define IN_APP_PURCHASE_GENERAL_PAD_ITEM55 @"diandupad_tier55" // 580


#define  SERVICE_ERROR_CODE     20000
#define  SYSTEM_ERROR_CODE      10000
#define  AUTH_SERVICE_ERROR_CODE         SERVICE_ERROR_CODE + 100
#define  MODULE_SERVICE_ERROR_CODE_USER  SERVICE_ERROR_CODE + 200
#define  MODULE_SERVICE_ERROR_CODE_BOOK  SERVICE_ERROR_CODE + 300
#define  APPS_ERROR_CODE_BASE            SERVICE_ERROR_CODE + 400
#define  ACTIVITY_ERROR_CODE_BASE        SERVICE_ERROR_CODE + 500
#define  ORDER_ERROR_CODE_BASE           SERVICE_ERROR_CODE + 700
#define  COMMON_SERVICE_ERROR_CODE       SERVICE_ERROR_CODE + 9000


#define kNotification_clearPageHightLight    @"kNotification_clearPageHightLight"

// 通知定义
#define kNotification_addToShoppingCart         @"kNotification_addToShoppingCart"
#define kNotification_addToShoppingCartAndGo    @"kNotification_addToShoppingCartAndGo"
#define kNotification_removeFromShoppingCart    @"kNotification_removeFromShoppingCart"
#define kNotification_downOrReadBookInBuy    @"kNotification_downOrReadBookInBuy"
#define kNotification_deleteLocalBook    @"kNotification_deleteLocalBook"
//#define kNotification_shoppingUseDiscountCard   @"kNotification_shoppingUseDiscountCard"

#define kNotification_getUserLevelFinished      @"kNotification_getUserLevelFinished"
#define kNotification_getUserHasExamFinished        @"kNotification_getUserHasExamFinished"
#define kNotification_userGoldenCountChanged    @"kNotification_userGoldenCountChanged"

#define kNotification_bookHasBuyedSuccess       @"kNotification_bookHasBuyedSuccess"
#define kNotification_bookDownloadProgress       @"kNotification_bookDownloadProgress"

#define kNotification_LoginSuccess       @"kNotification_LoginSuccess"
#define kNotification_ReadBookBack       @"kNotification_ReadBookBack"

#define kNotification_GetMsgSuccess       @"kNotification_GetMsgSuccess"
#define kNotification_GetExamSuccess       @"kNotification_GetExamSuccess"

#define kNotification_ChangeSubscribeSuccess       @"kNotification_ChangeSubscribeSuccess"


#define kNotification_logoutByForce       @"kNotification_logoutByForce"

#define kNotification_paySuccess       @"kNotification_paySuccess"
#define kNotification_payFail          @"kNotification_payFail"


//http request info keys
#define HTTP_KEYNAME_RESPONSE_CODE          @"code"
#define HTTP_KEYNAME_RESPONSE_MSG           @"message"

#define HTTP_KEYNAME_FAIL_RETURN_CODE       @"HttpKeyName_FailReturnCode"


#define BEGIN_PAGENO         1
#define REQUEST_PAGESIZE     48


#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define RGBACOLOR(r,g,b,a)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//#define BACKGROUNDCOLOUR            @"#edf3f3"//背景色值
#define MAIN_ACTIVE_COLOR           RGBCOLOR(252.0f,111.0f,80.0f)
#define CUSTOM_NAVBAR_COLOR         RGBCOLOR(0.0f,161.0f,198.0f)
#define BACKGROUNDCOLOUR            RGBCOLOR(245.0f,245.0f,245.0f)
#define MAIN_ITEM_COLOR             [UIColor whiteColor]
#define NAVBAR_TITLE_COLOR          [UIColor whiteColor]

#define MAIN_BULE_COLOR RGBCOLOR(28.0f,158.0f,201.0f)


#ifdef USE_APPLE_PAY
#define RMB(x) [NSString stringWithFormat:@"%.2f 金币", x]
#else
#define RMB(x) [NSString stringWithFormat:@"¥ %.2f", x]
#endif

#define FONT_HEITI_BOLD(x)       [UIFont fontWithName:@"STHeitiTC-Medium" size:(x)]
#define FONT_HEITI(x)       [UIFont fontWithName:@"STHeitiTC-Light" size:(x)]




#define kDefaultCorpImage [UIImage imageNamed:@"img_company_default.png"]
#define kDefaultUserImage [UIImage imageNamed:@"userDefault.png"]
#define kDefaultBookCoverImage [UIImage imageNamed:@"book_holder.png"]




#define Max_List_LoadMore_Length    20
#define Max_List_Pulling_Length     20


typedef enum {
    PayTypeGolden = 0,
    PayTypeAlipay =1 ,
    PayTypeYinLian = 4 ,
    PayTypeYiBao = 5 ,
    PayTypeForApple = 6
}PayType;

