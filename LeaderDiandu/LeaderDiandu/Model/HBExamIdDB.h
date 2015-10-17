//
//  HBExamIdDB.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/15.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h> 

@interface HBExamIdDB : NSObject

+ (HBExamIdDB *)sharedInstance;

/**
 *  更新作业ID
 *
 *  @param ExamIdArr 作业ID数组
 *
 *  @return 操作结果
 */
- (BOOL)updateHBExamId:(NSArray *)ExamIdArr;

/**
 *  获取所有作业ID
 *
 *  @return 作业ID数组
 */
- (NSMutableArray *)getAllExamId;

@end
