//
//  HBReadProgressDB.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/27.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBReadprogressEntity.h"

@interface HBReadProgressDB : NSObject

+ (HBReadProgressDB *)sharedInstance;

/**
 *  更新阅读进度信息
 *
 *  @param readprogressEntity   阅读进度信息
 *
 *  @return 操作结果
 */
- (BOOL)updateHBReadprogress:(NSArray *)readprogressEntityArr;

/**
 *  获取所有阅读进度信息
 *
 *  @return 阅读进度信息字典
 */
- (NSMutableDictionary *)getAllReadprogressDic;

@end
