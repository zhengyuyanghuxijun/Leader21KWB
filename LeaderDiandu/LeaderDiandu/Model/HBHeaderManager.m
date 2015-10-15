//
//  HBHeaderManager.m
//  LeaderDiandu
//
//  Created by xijun on 15/10/13.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBHeaderManager.h"
#import "ASIHTTPRequest.h"

#define SERVICEAPI  @"http://teach.61dear.cn:9080"

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
//    self.receivedBlock = receivedBlock;
    
    NSDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setValue:token forKey:NSHTTPCookieValue];
    [properties setValue:@"ASIHTTPRequesHeaderCookie" forKey:NSHTTPCookieName];
    [properties setValue:@"teach.61dear.cn" forKey:NSHTTPCookieDomain];
    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
    [properties setValue:@"/asi-http-request/headers" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
    
    NSString *srtUrl = [NSString stringWithFormat:@"%@/api/user/avatar?f=%@.png",SERVICEAPI , user];
    NSURL *url = [NSURL URLWithString:srtUrl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUseCookiePersistence:NO];
    [request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(requestFinished:)]) {
//        [self.delegate requestFinished:self];
//    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(requestFailed:)]) {
//        [self.delegate requestFailed:self];
//    }
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

@end
