//
//  ErrorCodeUtils.m
//  PaipaiGou
//
//  Created by Levin on 7/19/12.
//  Copyright (c) 2012 ilovedev.com. All rights reserved.
//

#import "ErrorCodeUtils.h"

@implementation ErrorCodeUtils

+ (NSString *)getServerError:(NSDictionary *)dict
{
    NSInteger errorCode = [[dict objectForKey:HTTP_KEYNAME_RESPONSE_CODE] integerValue];
    if (errorCode != 0) {
        NSString *errorMsg = [dict objectForKey:HTTP_KEYNAME_RESPONSE_MSG];
        if (errorMsg && [errorMsg isKindOfClass:[NSString class]]) {
            return errorMsg;
        }
    }
    switch (errorCode) {
        case 0:
            return nil;
            break;
        case 1:
            return NSLocalizedString(@"请求失败", nil);
            break;
        case 2:
            return NSLocalizedString(@"访问受限", nil);
            break;
        case 3:
            return NSLocalizedString(@"参数错误", nil);
            break;
        case 4:
            return NSLocalizedString(@"绑定帐号过期", nil);
            break;
        default:
            return NSLocalizedString(@"服务器错误", nil);
            break;
    }
}

+ (NSString *)getHttpError:(NSDictionary *)dict
{
    NSInteger errorCode = [[dict objectForKey:HTTP_KEYNAME_FAIL_RETURN_CODE] integerValue];
    switch (errorCode) {
        case 0:
            return nil;
            break;
        case kHttpTimeOutErrorCode:
            return NSLocalizedString(@"请求超时", nil);
            break;
        case kNetworkUnavailabelErrorCode:
        case kNetworkUnavailabelErrorCode2:
            return NSLocalizedString(@"你的网络好像有问题，请稍后再试", nil);
            break;
        default:
            return NSLocalizedString(@"网络错误", nil);
            break;
    }
}

+ (NSString *)getErrorDetail:(NSDictionary *)dict
{
    NSString *httpError = [ErrorCodeUtils getHttpError:dict];
    if (httpError != nil) {
        return httpError;
    }
    NSString *serverError = [ErrorCodeUtils getServerError:dict];
    if (serverError != nil) {
        return serverError;
    }
    return nil;
}



@end
