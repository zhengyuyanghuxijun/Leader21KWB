//
//  HBContentListDB.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/13.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBContentListDB : NSObject

+ (HBContentListDB *)sharedInstance;

/**
 *  更新套餐信息
 *
 *  @param contentListArr   套餐信息
 *
 *  @return 操作结果
 */
- (BOOL)updateHBContentList:(NSArray *)contentListArr;

/**
 *  根据套餐id返回该套餐对应的books字符串
 */
- (NSString*)booksidWithID:(NSInteger)ID;

@end
