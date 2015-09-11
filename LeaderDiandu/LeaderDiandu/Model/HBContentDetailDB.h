//
//  HBContentDetailDB.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/11.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBContentDetailEntity.h"

@interface HBContentDetailDB : NSObject

+ (HBContentDetailDB *)sharedInstance;

/**
 *  更新课本信息
 *
 *  @param contentDetailEntity   课本信息
 *
 *  @return 操作结果
 */
- (BOOL)updateHBContentDetail:(NSArray *)contentDetailArr;

/**
 *  读取课本信息
 *
 *  @param user 老师账号
 *
 *  @return 课本数组
 */
- (NSMutableArray*)booksWithUser:(NSString*)user;


@end
