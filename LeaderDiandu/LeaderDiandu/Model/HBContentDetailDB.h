//
//  HBContentDetailDB.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/11.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBContentDetailDB : NSObject

+ (HBContentDetailDB *)sharedInstance;

/**
 *  更新课本信息
 *
 *  @param contentDetailArr   课本信息
 *
 *  @return 操作结果
 */
- (BOOL)updateHBContentDetail:(NSArray *)contentDetailArr;

/**
 *  读取课本信息
 *
 *  @param booksIDArr 课本ID号数组
 *
 *  @return 课本数组
 */
- (NSMutableArray*)booksWithBooksIDArr:(NSArray*)booksIDArr;


@end
