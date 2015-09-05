//
//  Constants.h
//  Leader21SDKOC
//
//  Created by leader on 15/7/2.
//  Copyright (c) 2015年 leader. All rights reserved.
//

#ifndef Leader21SDKOC_Constants_h
#define Leader21SDKOC_Constants_h


//http request info keys
#define HTTP_KEYNAME_RESPONSE_CODE          @"code"
#define HTTP_KEYNAME_RESPONSE_MSG           @"message"
#define HTTP_KEYNAME_FAIL_RETURN_CODE       @"HttpKeyName_FailReturnCode"

#define HOST                                @"http://teach.61dear.cn:9081"
#define API_GET_BOOK_INFO                   @"api/book"
#define API_DOWNLOAD_BOOK                   @"api/book/download"
#define kNotification_bookDownloadProgress  @"kNotification_bookDownloadProgress"

#define kNotification_clearPageHightLight    @"kNotification_clearPageHightLight"
#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define RGBACOLOR(r,g,b,a)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define BACKGROUNDCOLOUR            RGBCOLOR(245.0f,245.0f,245.0f)
#define NAVBAR_TITLE_COLOR          [UIColor whiteColor]
#endif
