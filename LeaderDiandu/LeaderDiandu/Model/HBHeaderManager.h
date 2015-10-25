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

@property (nonatomic, copy)HBHeaderReceivedBlock receivedBlock;

+ (id)defaultManager;

/**
 *  获取用户头像
 *
 *  @param user             用户ID
 *  @param token            登录返回的凭证
 *  @param receivedBlock 回调Block
 */
- (void)requestGetAvatar:(NSString *)user token:(NSString *)token completion:(HBHeaderReceivedBlock)receivedBlock;

/**
 *  更新用户头像
 *
 *  @param user             用户ID
 *  @param token            登录返回的凭证
 *  @param avatarFile       头像文件
 *  @param data             图片数据
 *  @param receivedBlock 回调Block
 */
- (void)requestUpdateAvatar:(NSString *)user token:(NSString *)token file:(NSString *)avatarFile data:(NSData *)data completion:(HBHeaderReceivedBlock)receivedBlock;

//获取头像文件
- (NSString *)getAvatarFileByUser:(NSString *)user;

@end
