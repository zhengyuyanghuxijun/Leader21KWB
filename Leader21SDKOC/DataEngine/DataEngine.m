//
//  DataEngine.m
//  leader21sdk
//
//  Created by leader on 15/6/30.
//  Copyright (c) 2015年 leader. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKHttpRequest.h"
#import "DataEngine.h"
#import "BookEntity.h"
#import "MKNetworkEngine.h"
#import "ErrorCodeUtils.h"
#import "ZipArchive.h"

static DataEngine *dataEngineInstance = nil;

@interface DataEngine()

@end

@implementation DataEngine
@synthesize mAppId;

+ (DataEngine *)sharedInstance
{
    @synchronized(dataEngineInstance) {
        if (dataEngineInstance == nil) {
            dataEngineInstance = [[DataEngine alloc] init];
        }
    }
    return dataEngineInstance;
}
- (id)init
{
    if (self = [super init]) {
        
        [self configApp];
        
        _networkEngine = [[MKNetworkEngine alloc] initWithHostName:self.serverUrl];
        
        //        _downloadEngine = [[MKNetworkEngine alloc] initWithHostName:@"http://boss.61dear.com"];
        //        _downloadEngine.wifiOnlyMode = YES;
        //        [_downloadEngine useCache];
        
        self.downloadDic = [NSMutableDictionary dictionaryWithCapacity:16];
        
//        if ([UIDevice isiPad]) {
//            _isPad = YES;
//        }
//        else {
//            _isPad = NO;
//        }
    }
    
    
    return self;
}
- (void)configApp
{
    self.version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey];
    
    self.deviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        NSInteger scale = [[UIScreen mainScreen] scale];
        self.deviceScreenSize = CGSizeMake(scale * self.deviceScreenSize.width, scale * self.deviceScreenSize.height);
    }
    
//    self.deviceUniqueId = [[UIDevice currentDevice] deviceIdentifier];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    self.appName = [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (self.appName.length == 0) {
        self.appName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
    }
}

- (MKHttpRequest*)requestGETWithApi:(NSString*)apiName
                              param:(NSDictionary*)param
                   completOpeartion:(MKNKResponseBlock)complete
                     errorOperation:(MKNKResponseErrorBlock)error
{
    return [self requestWithApi:apiName
                          param:param
                         method:@"GET"
                            url:nil
               completOpeartion:complete
                 errorOperation:error];
}

- (MKHttpRequest*)requestPOSTWithApi:(NSString*)apiName
                               param:(NSDictionary*)param
                    completOpeartion:(MKNKResponseBlock)complete
                      errorOperation:(MKNKResponseErrorBlock)error
{
    return [self requestWithApi:apiName
                          param:param
                         method:@"POST"
                            url:nil
               completOpeartion:complete
                 errorOperation:error];
}

- (MKHttpRequest*)requestWithApi:(NSString*)apiName
                           param:(NSDictionary*)param
                          method:(NSString*)method
                             url:(NSString*)url
                completOpeartion:(MKNKResponseBlock)complete
                  errorOperation:(MKNKResponseErrorBlock)error
{
    NSAssert([apiName hasPrefix:@"/"], @"apiname error /");
    
    if (method.length == 0) {
        method = @"POST";
    }
    
    NSString* fullUrl = self.serverUrl;
    if (url.length > 0) {
        fullUrl = url;
    }
    
    if (apiName.length > 0) {
        fullUrl = [NSString stringWithFormat:@"%@%@", fullUrl, apiName];
    }
    
    //
    NSDictionary* fullParam = [self generateFullParam:param];
    
    MKHttpRequest* r = [[MKHttpRequest alloc] initWithURLString:fullUrl params:fullParam httpMethod:method];
    
    //    if (([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"])
    //        && (fullParam && [fullParam count] > 0)) {
    //        // 与服务端约定使用JSON
    //        r.postDataEncoding = MKNKPostDataEncodingTypeJSON;
    //    }
    
    [r addHeaders:[self generateHeader]];
    [r addCompletionHandler:complete errorHandler:error];
    
//#ifdef DEBUG
    NSLog(@"REQUEST:%@", r);
//#endif
    
    [self.networkEngine enqueueOperation:r];
    
    return r;
}


- (NSDictionary *)generateHeader
{
    //    UIDevice *device = [UIDevice currentDevice];
    //    NSString *systemVersion = [NSString stringWithFormat:@"ios %@", device.systemVersion];
    
//    NSDate* date = [NSDate date];
//    NSTimeInterval time = [date timeIntervalSince1970];
//    NSString* callId = [NSString stringWithFormat:@"%lld", (long long)(time * 1000.0f)];
//    
//    // 登录后的参数
//    NSString* ticket = self.me.userTicket;
//    if (ticket == nil) {
//        ticket = @"";
//    }
//    
//    NSString* app_platform = @"1";
//    if ([DE isPad]) {
//        app_platform = @"2";
//    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleIdentifier"];
//    NSMutableDictionary *header = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   @"2", @"app_type", // 2:iOS
//                                   @"CH_ZN", @"language",
//                                   self.deviceUniqueId, @"device_id",
//                                   @"1", @"app_platform",
//                                   @"", @"location",
//                                   callId, @"call_id",
//                                   ticket, @"ticket",
//                                   nil];
    NSMutableDictionary *header = [NSMutableDictionary dictionaryWithObjectsAndKeys:app_Name,@"x-Requested-By", nil];
    return header;
}
- (NSDictionary*)generateFullParam:(NSDictionary*)param
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
//    // 加公共参数,签名
//    NSString* sigStr = [self sortParamWithParam:param];
//    NSString* base64 = [sigStr base64MD5];
//    [dic setObject:base64 forKey:@"sign"];
//    
//    
//    NSDate* date = [NSDate date];
//    NSTimeInterval time = [date timeIntervalSince1970];
//    NSString* callId = [NSString stringWithFormat:@"%lld", (long long)time * 1000];
//    
//    // 登录后的参数
//    NSString* ticket = self.me.userTicket;
//    if (ticket == nil) {
//        ticket = @"";
//    }
//    
//    [dic setObject:@"2" forKey:@"app_type"];// 2:iOS
//    [dic setObject:@"CH_ZN" forKey:@"language"];
//    [dic setObject:self.deviceUniqueId forKey:@"device_id"];
//    [dic setObject:@"1" forKey:@"app_platform"];
//    [dic setObject:@"" forKey:@"location"];
//    [dic setObject:callId forKey:@"call_id"];
//    
//    [dic setObject:ticket forKey:@"ticket"];
    
    return dic;
}
/**
 通过Book ID获取书本描述信息：
 参数名称:ids | 参数类型:string | 默认值: | 是否为空:N | 字段描述:多个书ID以英文逗号分隔
 参数名称:app_key | 参数类型:string | 默认值: | 是否为空:N | 字段描述:app唯一id
 */
- (MKHttpRequest *)requestBookInfo:(NSString *)bookIds onComplete:(ResponseBookListBlock)block{
    
    NSLog(@"REQUEST:%@", bookIds);
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    [param setObject:bookIds forKey:@"ids"];
    [param setObject:mAppId forKey:@"app_key"];
    
    MKHttpRequest *r = [self requestPOSTWithApi:API_GET_BOOK_INFO
                            param:param
                            completOpeartion:^(MKNetworkOperation * completedOperation){
                                //获取书本信息成功
                                NSDictionary* dic = [completedOperation responseJSON];
                                NSInteger code = [self getErrorCode:dic];
                                NSLog(@"book list :%@", [dic allValues]);
                                NSLog(@"reponse code %lu", code);

                                if (code == RequestErrorCodeSuccess) {
                                    // TODO
                                    //解析数据
                                    NSArray* array = [dic objectForKey:@"books"];
                                    NSMutableArray* booklist = [[NSMutableArray alloc] initWithCapacity:[array count]];
                                    if ([array isKindOfClass:[NSArray class]]) {
                                        for (NSDictionary* info in array) {
                                            BookEntity* book = [BookEntity itemWithDictionary:info];
                                            [booklist addObject:book];
                                        }
                                        
                                    }
                                    [CoreDataHelper save];
                                    if (block != nil){
                                        block(booklist, RequestErrorCodeSuccess,nil);
                                    }

                                }
                                else {
                                    NSLog(@"parser server data error");

                                    [self serverError:code data:dic onComplete:block];
                                }
                            }
                            errorOperation:^(MKNetworkOperation *completedOperation, NSError *error){
                                //获取书本信息失败
                                [self connectError:error onComplete:block];
                            }];
    
    return r;
}

/**
 * 下载确认
 * @param bookIds   书本ID列表
 * @param block  返回数据的回调
 */
- (MKHttpRequest*)requestBookNotify:(BookEntity*)bookEntity success:(BOOL)isSuccess onComplete:(ResponseBookListBlock)block
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    [param setObject:mAppId forKey:@"app_key"];
    [param setObject:bookEntity.fileId forKey:@"file_id"];
    [param setObject:@(isSuccess) forKey:@"status"];
    
    MKHttpRequest *r = [self requestPOSTWithApi:API_DOWNLOAD_NOTIFY param:param completOpeartion:^(MKNetworkOperation *completedOperation) {
        
    } errorOperation:^(MKNetworkOperation *completedOperation, NSError *error) {
        
    }];
    return r;
}

- (void)serverError:(NSInteger)code data:(NSDictionary*)dic onComplete:(ResponseBookListBlock)block
{
    
    if (block != nil) {
        block(nil, code, @"TODO error code");
    }
}
- (NSInteger)getErrorCode:(NSDictionary*)dic
{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        if ([self emptyDictionary:dic]) {
            return RequestErrorCodeException;
        }
        NSNumber* code = [dic objectForKey:@"error_code"];
        if (code != nil) {
            if ([code isKindOfClass:[NSNumber class]]) {
                return code.integerValue;
            }
            else if ([code isKindOfClass:[NSString class]]) {
                return [(NSString*)code integerValue];
            }
        }
        else {
            // 服务端不返回code，表示成功
            return RequestErrorCodeSuccess;
        }
    }
    else if ([dic isKindOfClass:[NSArray class]]) {
        return RequestErrorCodeSuccess;
    }
    else if (dic == nil) {
        return RequestErrorCodeSuccess;
    }
    
    return RequestErrorCodeNull;
}

#pragma mark - error process
- (BOOL)emptyDictionary:(NSDictionary*)dic
{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        if (dic == nil || [[dic allKeys] count] == 0) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        return NO;
    }
}

- (void)connectError:(NSError*)error onComplete:(ResponseBookListBlock)block
{
    if (block != nil) {
        NSString* msg = [self getHttpError:error];
        block(nil, RequestErrorCodeConnectError, msg);
    }
}

- (NSString *)getHttpError:(NSError *)error
{
    switch ([error code]) {
        case kHttpTimeOutErrorCode:
            return NSLocalizedString(@"请求超时", nil);
            break;
        case kNetworkUnavailabelErrorCode:
        case kNetworkUnavailabelErrorCode2:
            return NSLocalizedString(@"网络错误，请稍后再试", nil);
            break;
        default:
            return NSLocalizedString(@"网络错误", nil);
            break;
    }
}

- (BOOL)unZipFile:(NSString*)zipFile toPath:(NSString*)path
{
    ZipArchive* zip = [[ZipArchive alloc] init];
    
    if ([zip UnzipOpenFile:zipFile]) {
        BOOL ret = [zip UnzipFileTo:path overWrite:YES];
        [zip UnzipCloseFile];
        return ret;
    }
    
    return NO;
}
@end