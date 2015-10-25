//
//  HBHeaderManager.m
//  LeaderDiandu
//
//  Created by xijun on 15/10/13.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBHeaderManager.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "FileUtil.h"

@interface HBHeaderManager ()

@property (nonatomic, strong)NSString *user;

@end

@implementation HBHeaderManager

+ (id)defaultManager
{
    static HBHeaderManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HBHeaderManager alloc] init];
    });
    return manager;
}

- (void)requestGetAvatar:(NSString *)user token:(NSString *)token completion:(HBHeaderReceivedBlock)receivedBlock
{
    self.receivedBlock = receivedBlock;
    
//    NSDictionary *properties = [[NSMutableDictionary alloc] init];
//    [properties setValue:token forKey:NSHTTPCookieValue];
//    [properties setValue:@"ASIHTTPRequesHeaderCookie" forKey:NSHTTPCookieName];
//    [properties setValue:@"teach.61dear.cn" forKey:NSHTTPCookieDomain];
//    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
//    [properties setValue:@"/asi-http-request/headers" forKey:NSHTTPCookiePath];
//    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    NSString *srtUrl = [NSString stringWithFormat:@"%@/api/user/avatar?f=%@.png&token=%@&%@=%@", SERVICEAPI, user, token, KWBAppKey, KAppKeyStudy];
    NSURL *url = [NSURL URLWithString:srtUrl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Content-Type" value:@"image/jpeg"];
//    [request addRequestHeader:@"Cookie" value:token];
//    [request setUseCookiePersistence:NO];
//    [request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
    [request setDelegate:self];
    [request startAsynchronous];
    __weak typeof(request) weakRequest = request;
    [request setCompletionBlock:^{
        NSError *error = [weakRequest error];
        if (error == nil) {
            NSData *data = [weakRequest responseData];
            if (error == nil && [data length]>100) {
                NSString *path = [[FileUtil getFileUtil] getAvatarCachesPath];
                path = [NSString stringWithFormat:@"%@/%@.png", path, user];
                [[FileUtil getFileUtil] saveToFile:data filePath:path atomically:NO];
            }
            receivedBlock(nil, error);
        }
    }];
}

- (void)requestUpdateAvatar:(NSString *)user token:(NSString *)token file:(NSString *)avatarFile data:(NSData *)data completion:(HBHeaderReceivedBlock)receivedBlock
{
    NSString *server_base = [NSString stringWithFormat:@"%@/api/user/avatar/update", SERVICEAPI];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:server_base]];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator: NO];
    [request setDelegate :self];
//    [request setData:<#(id)#> withFileName:<#(NSString *)#> andContentType:<#(NSString *)#> forKey:<#(NSString *)#>]
    [request addRequestHeader:@"Content-Type" value:@"multipart/form-data; boundary=---------------------------7d9950509b4"];
    [request setFile:avatarFile forKey:@"avatar"];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setPostValue:user forKey:@"user"];
    [request setPostValue:token forKey:@"token"];
    [request setPostValue:KAppKeyStudy forKey:KWBAppKey];
    [request setPostBodyFilePath:avatarFile];
    NSMutableData *fileData = [NSMutableData dataWithContentsOfFile:avatarFile];
    [request setPostBody:fileData];
    [request setPostLength:[fileData length]];
    [request startSynchronous];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    if (self.receivedBlock) {
        self.receivedBlock(nil, error);
    }
}

- (void)Get:(NSString *)api dict:(NSMutableDictionary *)dict block:(HBHeaderReceivedBlock)receivedBlock
{
    [dict setObject:KAppKeyStudy forKey:KWBAppKey];
//    [[HBHTTPBaseRequest requestWithSubUrl:api] startWithMethod:HBHTTPRequestMethodGET parameters:dict completion:^(id responseObject, NSError *error)
//     {
//        if (error) {
//            NSDictionary *userDic = error.userInfo;
//            NSString *descValue = userDic[@"NSLocalizedDescription"];
//            if ([descValue containsString:@"401"]) {
//                //token过期，需要重新登录
//                [Navigator pushLoginController];
//            }
//        }
//        if (receivedBlock) {
//            NSLog(@"responseObject=\r\n%@", responseObject);
//            receivedBlock(responseObject,error);
//        }
//        self.receivedBlock = nil;
//    }];
}

- (NSString *)getAvatarFileByUser:(NSString *)user
{
    NSString *path = [[FileUtil getFileUtil] getAvatarCachesPath];
    path = [NSString stringWithFormat:@"%@/%@.png", path, user];
    if ([[FileUtil getFileUtil] isFileExist:path]) {
        return path;
    }
    return nil;
}

@end
