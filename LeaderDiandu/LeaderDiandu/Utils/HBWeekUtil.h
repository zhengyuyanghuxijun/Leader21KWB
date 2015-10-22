//
//  HBWeekUtil.h
//  LeaderDiandu
//
//  Created by xijun on 15/10/19.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBWeekUtil : NSObject

+ (id)sharedInstance;

//获取一年的总周数
- (NSInteger)getWeekTotalOfYear;
//获取当前属于一年的第几周
- (NSInteger)getWeekOfYear;
//获取当前年份，若date为nil则返回当前年份
- (NSInteger)getYearWithDate:(NSDate *)date;
- (NSDateComponents *)getCompontentsWithDate:(NSDate *)date;
//获取一周的起始和结束时间
- (NSMutableDictionary *)getWeekBeginAndEndWith:(NSDate *)newDate;
//获取上一周
- (NSDate *)turnWeekDay:(BOOL)isPre withCurrentDate:(NSDate *)currentDate;

@end
