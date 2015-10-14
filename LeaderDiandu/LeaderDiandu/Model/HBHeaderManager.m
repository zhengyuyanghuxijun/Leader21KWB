//
//  HBHeaderManager.m
//  LeaderDiandu
//
//  Created by xijun on 15/10/13.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBHeaderManager.h"
#import "ASIHTTPRequest.h"

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
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
    
//    self.receivedBlock = receivedBlock;
    
    NSDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setValue:token forKey:NSHTTPCookieValue];
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
    [ASIHTTPRequest addSessionCookie:cookie];
    
    NSString *srtUrl = [NSString stringWithFormat:@"/api/user/avatar?f=%@.png", user];
    NSURL *url = [NSURL URLWithString:srtUrl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request setDelegate:self];
    request.didFinishSelector = @selector(requestFinished:);
    request.didFailSelector = @selector(requestFailed:);
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
