//
//  HBHeaderManager.h
//  LeaderDiandu
//
//  Created by xijun on 15/10/13.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HBHeaderReceivedBlock) (id responseObject, NSError *error);

@interface HBHeaderManager : NSObject

+ (id)defaultManager;

/**
 *  获取用户头像
 *
 *  @param user             用户ID
 *  @param token            登录返回的凭证
 *  @param receivedBlock 回调Block
 */
- (void)requestGetAvatar:(NSString *)user token:(NSString *)token completion:(HBHeaderReceivedBlock)receivedBlock;

@end
