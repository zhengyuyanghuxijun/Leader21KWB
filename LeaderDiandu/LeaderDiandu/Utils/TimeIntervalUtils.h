//
//  TimeIntervalUtils.h
//  Three Hundred
//
//  Created by Levin on 11-8-16.
//  Copyright 2011年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TimeIntervalUtils : NSObject

@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter;

+ (TimeIntervalUtils *)sharedInstance;

+ (BOOL)isSameYear:(NSDate*)date1 withDate:(NSDate*)date2;
+ (BOOL)isSameDay:(NSDate*)date1 withDate:(NSDate*)date2;

+ (NSString*)getStringMDHMSFromTimeInterval:(NSTimeInterval)timeInterval;
+ (NSString*)getStringYearMonthFromTimeinterval:(NSTimeInterval)timeInterval;
+ (NSString*)getStringYearMonthDayFromTimeinterval:(NSTimeInterval)timeInterval;
+ (NSString*)getCNStringYearMonthDayFromTimeinterval:(NSTimeInterval)timeInterval;
+ (NSString*)getStringYMDHMFromTimeinterval:(NSTimeInterval)timeInterval;
+ (NSString*)getShortStringYMDHMFromTimeinterval:(NSTimeInterval)timeInterval withDate:(NSDate*)now;
+ (NSString*)getSameStringYMDHMFromTimeinterval:(NSTimeInterval)timeInterval withDate:(NSDate*)now;
+ (NSString*)getCNSameStringYMDHMFromTimeinterval:(NSTimeInterval)timeInterval withDate:(NSDate*)now;

+ (NSString*)getStringYearMonthFromDate:(NSDate*)date;
+ (NSString*)getStringYearMonthDayFromDate:(NSDate*)date;
+ (NSString*)getCNStringYearMonthDayFromDate:(NSDate*)date;
+ (NSString*)getStringYMDHMFromDate:(NSDate*)date;
+ (NSString*)getShortStringYMDHMFromDate:(NSDate*)date withDate:(NSDate*)now;
+ (NSString*)getSameStringYMDHMFromDate:(NSDate*)date withDate:(NSDate*)now;
+ (NSString*)getCNSameStringYMDHMFromDate:(NSDate*)date withDate:(NSDate*)now;


+ (NSString*)getShortStringFrom:(NSTimeInterval)sTime to:(NSTimeInterval)eTime;
+ (NSString*)getShortStringFrom:(NSTimeInterval)sTime to:(NSTimeInterval)eTime connectBy:(NSString*)ch;


//
//
//+ (NSString*)shortTextFromTimeIntervalSince1970:(NSTimeInterval)timeInterval;
//+ (NSString*)middleTextFromTimeIntervalSince1970:(NSTimeInterval)timeInterval withYear:(BOOL)flag;
//+ (NSString*)fullTextFromTimeIntervalSince1970:(NSTimeInterval)timeInterval;
//+ (NSString*)fullTextFromTimeString:(NSString *)timeStr;
//
//
//+ (NSString *)getNowDateString;
//+ (NSString *)getNowDateStringYMS;
//+ (NSString *)getNowTimeString_Second;
//+ (NSString *)getNowTimeString_Minutes;
//+ (NSString *)getNowTimeString_Hours;
//
//+ (NSString *)getDateStringFromTimeIntervalSince1970:(NSTimeInterval)timeInterval;
//+ (NSString *)getMonthDayStringFromTimeIntervalSince1970:(NSTimeInterval)timeInterval;
//+ (NSString *)getMonthAndDayStringFromTimeIntervalSince1970:(NSTimeInterval)timeInterval;
//+ (NSString *)getTimeString_SecondFromTimeIntervalSince1970:(NSTimeInterval)timeInterval;
//+ (NSString *)getTimeString_MinutesFromTimeIntervalSince1970:(NSTimeInterval)timeInterval;
//
//+ (NSString *)getStringFromDate:(NSDate *)sdate;
//+ (NSString *)getStringFromDate_Hours:(NSDate *)sdate;
//+ (NSString *)getStringFromDate_Month:(NSDate *)sdate;
//+ (NSDate *)getDateFromString:(NSString *)string;
//
+ (NSDate *)getDate_YearMonthFromString:(NSString *)string;
//+ (NSDate *)getDate_YearMonthDayFromString:(NSString *)string;
+ (NSString *)getDateString_YearMonthFromTimeIntervalSince1970:(NSTimeInterval)timeInterval;
//+ (NSString *)getDateString_YearMonth1FromTimeIntervalSince1970:(NSTimeInterval)timeInterval;
//
//
//+ (NSString *)getStringFromCalendarIntervalSince1970:(NSTimeInterval)timeInterval;
//+ (NSString *)getWeekStringFromCalendarIntervalSince1970:(NSTimeInterval)timeInterval;
//
//+ (NSString*)exactTextFromTimeIntervalSince1970:(NSTimeInterval)timeInterval;
//+ (NSString*)middleTextWithChineseFromTimeIntervalSince1970:(NSTimeInterval)timeInterval withYear:(BOOL)flag;
//
//+ (NSString *)timeAutomaticCup:(NSTimeInterval)timeInterval;
//
//




@end
