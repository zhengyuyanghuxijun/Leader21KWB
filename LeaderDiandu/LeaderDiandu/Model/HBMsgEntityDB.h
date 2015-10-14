//
//  HBMsgEntityDB.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/14.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBMsgEntityDB : NSObject

+ (HBMsgEntityDB *)sharedInstance;

/**
 *  更新消息
 *
 *  @param msgEntityArr  消息
 *
 *  @return 操作结果
 */
- (BOOL)updateHBMsgEntity:(NSArray *)msgEntityArr;

/**
 *  获取所有消息
 *
 *  @return 消息数组
 */
- (NSMutableArray *)getAllMsgEntity;

@end
