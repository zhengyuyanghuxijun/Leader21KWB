//
//  HBWeekUtil.m
//  LeaderDiandu
//
//  Created by xijun on 15/10/19.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBWeekUtil.h"

@interface HBWeekUtil ()
{
    NSDate *_curDate;
    NSCalendar *_curCalendar;
}

@end

@implementation HBWeekUtil

+ (id)sharedInstance
{
    static HBWeekUtil *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HBWeekUtil alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _curDate = [NSDate date];
        _curCalendar = [NSCalendar currentCalendar];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [_curCalendar setTimeZone:timeZone];
    }
    return self;
}


- (NSInteger)getWeekTotalOfYear
{
    NSRange range = [_curCalendar rangeOfUnit:NSWeekCalendarUnit inUnit:NSYearCalendarUnit forDate:_curDate];
    return range.length;
}

- (NSInteger)getWeekOfYear
{
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComponents = [_curCalendar components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSCalendarUnitWeekOfYear) fromDate:_curDate];
//    NSInteger day = [currentComponents day];//当前日期
//    NSInteger weekday = [currentComponents weekday];//星期几，周日是1
    NSInteger weekOfYear = [currentComponents weekOfYear];//当年的第几周
    return weekOfYear;
}

- (NSInteger)getYearWithDate:(NSDate *)date
{
    if (date == nil) {
        date = [NSDate date];
    }
    NSDateComponents *curComponents = [_curCalendar components:NSCalendarUnitYear fromDate:date];
    NSInteger year = [curComponents year];
    return year;
}

- (NSDateComponents *)getCompontentsWithDate:(NSDate *)date
{
    if (date == nil) {
        date = [NSDate date];
    }
    NSDateComponents *curComponents = [_curCalendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear fromDate:date];
//    NSInteger year = [curComponents year];
//    NSInteger weekOfYear = [curComponents weekOfYear];//当年的第几周
    return curComponents;
}

- (NSMutableDictionary *)getWeekBeginAndEndWith:(NSDate *)newDate
{
    if (newDate == nil) {
        newDate = _curDate;
    }
    
    double interval = 0;
    //    [calendar setFirstWeekday:2];//设定周一为周首日
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    BOOL ok = [_curCalendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSMonthCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    
    NSString *s = [NSString stringWithFormat:@"%@-%@",beginString,endString];
    NSLog(@"%@",s);
    
    NSMutableDictionary *dateDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dateDic setObject:beginDate forKey:@"beginDate"];
    [dateDic setObject:endDate forKey:@"endDate"];
    
    return dateDic;
}

- (NSDate *)turnWeekDay:(BOOL)isPre
{
    NSDateComponents *components = [_curCalendar components:(NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:_curDate];
    if (isPre) {
        [components setDay:([components day] - 7)];
    } else {
        [components setDay:([components day] + 7)];
    }
    NSDate *weekDate  = [_curCalendar dateFromComponents:components];
    NSLog(@"lastWeek=%@", weekDate);
    
    return weekDate;
}

@end
