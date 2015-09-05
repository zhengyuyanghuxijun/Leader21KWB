//
//  DataEngine.h
//  leader21sdk
//
//  Created by leader on 15/6/30.
//  Copyright (c) 2015年 leader. All rights reserved.
//

#ifndef leader21sdk_DataEngine_h
#define leader21sdk_DataEngine_h

#import <Foundation/Foundation.h>
#import "MKHttpRequest.h"
#import "DownloadItem.h"
#import "Leader21SDKOC.h"

@class MKNetworkEngine;

typedef enum {
    RequestErrorCodeSuccess = 0,
    RequestErrorCodeConnectError = -1,
    RequestErrorCodeCanceled = -2,
    
    RequestErrorCodeNull = 32000,
    RequestErrorCodeException = 32100,
    
}RequestErrorCode;

typedef void (^RequestBlock)(NSDictionary *sourceDic, NSInteger errorCode, NSString* errorMsg, BOOL hasMore, id otherData);

#define DE [DataEngine sharedInstance]
@interface DataEngine : NSObject

@property (nonatomic, copy) NSString* hostUrl;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *deviceUniqueId;
@property (assign, nonatomic) CGSize   deviceScreenSize;
@property (nonatomic, assign) BOOL isPad;
@property (nonatomic, strong) NSMutableDictionary* downloadDic;

@property (nonatomic, strong) MKNetworkEngine* networkEngine;
@property (nonatomic, strong) NSString *mAppId;

typedef enum {
    downloadStatusNone = 0,
    downloadStatusDownloading = Downloading,
    downloadStatusDownloadFailed = DownloadFailed,
    downloadStatusDownloadSuccess = DownloadFinished,
    downloadStatusPause = DownloadPaused,
    downloadStatusUnZipping = 8,
    downloadStatusFinished = 10,
}downloadStatus;

+ (DataEngine *)sharedInstance;

- (BOOL)unZipFile:(NSString*)zipFile toPath:(NSString*)path;
// post request
- (MKHttpRequest*)requestGETWithApi:(NSString*)apiName
                              param:(NSDictionary*)param
                   completOpeartion:(MKNKResponseBlock)complete
                     errorOperation:(MKNKResponseErrorBlock)error;

- (MKHttpRequest*)requestPOSTWithApi:(NSString*)apiName
                               param:(NSDictionary*)param
                    completOpeartion:(MKNKResponseBlock)complete
                      errorOperation:(MKNKResponseErrorBlock)error;

- (MKHttpRequest*)requestWithApi:(NSString*)apiName
                           param:(NSDictionary*)param
                          method:(NSString*)method
                             url:(NSString*)url
                completOpeartion:(MKNKResponseBlock)complete
                  errorOperation:(MKNKResponseErrorBlock)error;

/**
 * 请求书本详细信息
 * @param bookIds   书本ID列表
 * @param block  返回数据的回调
 */
- (MKHttpRequest*)requestBookInfo:(NSArray*)bookIds
                       onComplete:(ResponseBookListBlock)block;



@end

#endif
