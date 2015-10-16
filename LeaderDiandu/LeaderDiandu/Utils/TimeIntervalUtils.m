//
//  TimeIntervalUtils.m
//  Three Hundred
//
//  Created by Levin on 11-8-16.
//  Copyright 2011年 ilovedev.com. All rights reserved.
//

#import "TimeIntervalUtils.h"
#import "NSDateUtilities.h"

@interface TimeIntervalUtils ()

@property (nonatomic, strong, readwrite) NSDateFormatter *dateFormatter;

@end

static TimeIntervalUtils *singleton = nil;
@implementation TimeIntervalUtils
@synthesize dateFormatter = _dateFormatter;

+ (TimeIntervalUtils *)sharedInstance
{
    if (singleton == nil) {
        singleton = [[TimeIntervalUtils alloc] init];
    }
    return singleton;
}

- (id)init
{
    if (self = [super init]) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale:[NSLocale currentLocale]];
        [_dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    return self;
}


//+ (NSString*)shortTextFromTimeIntervalSince1970:(NSTimeInterval)timeInterval
//{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    NSTimeInterval theSeconds = [date timeIntervalSinceNow];
//    int seconds = 0 - theSeconds;
//    
//    if (seconds >= 0 &&seconds < 60) {//just now
//        return NSLocalizedString(@"刚刚", @"");
//    }
//    else if (seconds >= 60 && seconds < 60 * 60) {//min
//        return [NSString stringWithFormat:NSLocalizedString(@"%d分钟", @""), seconds / 60];
//    }
//    else if (seconds >= 60 * 60 && seconds < 60 * 60 * 24) {//hour
//        return [NSString stringWithFormat:NSLocalizedString(@"%d小时", @""), seconds / (60 * 60)];
//    }
//    else if (seconds >= 60 * 60 * 24 && seconds < 60 * 60 * 24 * 30) {//day
//        return [NSString stringWithFormat:NSLocalizedString(@"%d天", @""), seconds / (60 * 60 * 24)];
//    }
//    else {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
//        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
//        
//        NSString *formattedDateString = [dateFormatter stringFromDate:date];
//        return formattedDateString;        
//    }
//}
//
//+ (NSString*)middleTextFromTimeIntervalSince1970:(NSTimeInterval)timeInterval withYear:(BOOL)flag
//{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    NSTimeInterval theSeconds = [date timeIntervalSinceNow];
//    int seconds = 0 - theSeconds;
//    
//    if (seconds >= 0 && seconds < 60 * 5) {//just now
//        return NSLocalizedString(@"刚刚", @"");
//    } else if (seconds >= 60 *5  && seconds < 60 * 60) {//min
//        return  [TimeIntervalUtils getStringFromDate_Hours:date];   
//        return  [NSString stringWithFormat:NSLocalizedString(@"%dm前", @""),seconds /60];
//    } else if (seconds >= 60 * 60 && seconds < 60 * 60 * 24) {//hour
//        return  [TimeIntervalUtils getStringFromDate_Hours:date];
//        return [NSString stringWithFormat:NSLocalizedString(@"%dh前", @""), seconds / (60 * 60)];
//    } else if(seconds >= 60 * 60 * 24 && seconds < 60 * 60 * 24 * 365){
//        return  [TimeIntervalUtils getStringFromDate_Month:date];
//
//        TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//        if (flag) {
//            [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy-MM-dd hh:mm", @"")];
//        }else{
//            if (seconds >= 60 * 60 * 24 * 365) {
//                [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy-MM-dd", @"")];
//            } else {
//                [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"MM-dd", @"")];
//            }
//        }
//        
//        return [timeutils.dateFormatter stringFromDate:date];
//    }else{
//        return [TimeIntervalUtils getStringFromDate:date];
//
//    }
//}
//
//+ (NSString*)fullTextFromTimeIntervalSince1970:(NSTimeInterval)timeInterval
//{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    NSTimeInterval theSeconds = [date timeIntervalSinceNow];
//    int seconds = 0 - theSeconds;
//    
//    if (seconds >= 0 && seconds < 60) {//just now
//        return NSLocalizedString(@"刚刚", @"");
//    } else if (seconds >= 60 && seconds < 60 * 60) {//min
//        return [NSString stringWithFormat:NSLocalizedString(@"%d分钟前", @""), seconds / 60];
//    } else if (seconds >= 60 * 60 && seconds < 60 * 60 * 24) {//hour
//        return [NSString stringWithFormat:NSLocalizedString(@"%d小时前", @""), seconds / (60 * 60)];
//    } else if (seconds >= 60 * 60 * 24 && seconds < 60 * 60 * 24 * 7) {//day
//        return [NSString stringWithFormat:NSLocalizedString(@"%d天前", @""), seconds / (60 * 60 * 24)];
//    } else if (seconds >= 60 * 60 * 24 * 7 && seconds < 60 * 60 * 24 * 30) {//zhou
//        return [NSString stringWithFormat:NSLocalizedString(@"%d周前", @""), seconds / (60 * 60 * 24 * 7)];
//    } else if (seconds >= 60 * 60 * 24 * 30 && seconds < 60 * 60 * 24 * 30 * 12) {//yue
//        return [NSString stringWithFormat:NSLocalizedString(@"%d月前", @""), seconds / (60 * 60 * 24 * 30)];
//    } else if (seconds >= 60 * 60 * 24 * 30 * 12) {//nian
//        return [NSString stringWithFormat:NSLocalizedString(@"%d年前", @""), seconds / (60 * 60 * 24 * 30 * 12)];
//    } else {
//        TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//        [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy.MM.dd", @"")];
//        return [timeutils.dateFormatter stringFromDate:date];    
//    }
//}
//
//+ (NSString*)fullTextFromTimeString:(NSString *)timeStr
//{
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy-MM-dd", @"")];
//    NSDate *date = [timeutils.dateFormatter dateFromString:timeStr];
//    
//    NSTimeInterval theSeconds = [date timeIntervalSinceNow];
//    int seconds = 0 - theSeconds;
//    
//    if (seconds >= 0 && seconds < 60) {//just now
//        return NSLocalizedString(@"刚刚", @"");
//    } else if (seconds >= 60 && seconds < 60 * 60) {//min
//        return [NSString stringWithFormat:NSLocalizedString(@"%d分钟前", @""), seconds / 60];
//    } else if (seconds >= 60 * 60 && seconds < 60 * 60 * 24) {//hour
//        return [NSString stringWithFormat:NSLocalizedString(@"%d小时前", @""), seconds / (60 * 60)];
//    } else if (seconds >= 60 * 60 * 24 && seconds < 60 * 60 * 24 * 7) {//day
//        return [NSString stringWithFormat:NSLocalizedString(@"%d天前", @""), seconds / (60 * 60 * 24)];
//    } else {
//        TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//        [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy-MM-dd", @"")];
//        return [timeutils.dateFormatter stringFromDate:date];
//    }
//}
//
//
//+ (NSString *)getNowDateString
//{
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy-MM-dd HH:mm:ss", @"")];
//    return [timeutils.dateFormatter stringFromDate:[NSDate date]];
//}
//
//
//
//+ (NSString *)getNowDateStringYMS
//{
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy/MM/dd", @"")];
//    return [timeutils.dateFormatter stringFromDate:[NSDate date]];
//}
//
//+ (NSString *)getNowTimeString_Second
//{
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:@"HH:mm:ss"];
//    return [timeutils.dateFormatter stringFromDate:[NSDate date]];
//}
//
//
//+ (NSString *)getNowTimeString_Minutes
//{
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:@"HH:mm a"];
//    return [timeutils.dateFormatter stringFromDate:[NSDate date]];
//}
//
//+ (NSString *)getNowTimeString_Hours
//{
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:@"HH"];
//    return [timeutils.dateFormatter stringFromDate:[NSDate date]];
//}
//
//
//
//+ (NSString *)getMonthDayStringFromTimeIntervalSince1970:(NSTimeInterval)timeInterval
//{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"MM月dd日", @"")];
//    return [timeutils.dateFormatter stringFromDate:date];
//}
//
//
//+ (NSString *)getStringFromDate_HourMinite:(NSTimeInterval)timeInterval
//{
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    
//    return [self getStringFromDate_Hours:date];
//}
//
//
//+ (NSString *)getMonthAndDayStringFromTimeIntervalSince1970:(NSTimeInterval)timeInterval
//{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"MM-dd", @"")];
//    return [timeutils.dateFormatter stringFromDate:date];
//}
//+ (NSString *)getTimeString_SecondFromTimeIntervalSince1970:(NSTimeInterval)timeInterval
//{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:@"HH:mm:ss a"];
//    return [timeutils.dateFormatter stringFromDate:date];
//}
//
//+ (NSString *)getTimeString_MinutesFromTimeIntervalSince1970:(NSTimeInterval)timeInterval
//{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:@"a hh:mm"];
//    return [timeutils.dateFormatter stringFromDate:date];
//}
//
//
//+ (NSString *)getStringFromDate:(NSDate *)sdate {
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy年MM月dd日", @"")];
//    return [timeutils.dateFormatter stringFromDate:sdate];
//}
//
//+ (NSString *)getDateStringFromTimeIntervalSince1970:(NSTimeInterval)timeInterval
//{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy-MM-dd", @"")];
//    return [timeutils.dateFormatter stringFromDate:date];
//}
//
//+ (NSString *)getStringFromDate_Hours:(NSDate *)sdate
//{
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"HH:mm", @"")];
//    return [timeutils.dateFormatter stringFromDate:sdate];
//}
//
//+ (NSString *)getStringFromDate_Month:(NSDate *)sdate
//{
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"MM-dd", @"")];
//    return [timeutils.dateFormatter stringFromDate:sdate];
//}
//
//
//+ (NSDate *)getDateFromString:(NSString *)string {
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy-MM-dd", @"")];
//    return [timeutils.dateFormatter dateFromString:string];
//}
//
+ (NSDate *)getDate_YearMonthFromString:(NSString *)string
{
    NSString *trimmed = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy年M月", @"")];
    return [timeutils.dateFormatter dateFromString:trimmed];
}

//+ (NSDate *)getDate_YearMonthDayFromString:(NSString *)string{
//    NSString *trimmed = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy年MM月dd日", @"")];
//    return [timeutils.dateFormatter dateFromString:trimmed];
//}
//
+ (NSString *)getDateString_YearMonthFromTimeIntervalSince1970:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:@"yyyy年MM月"];
    return [timeutils.dateFormatter stringFromDate:date];
}
//+ (NSString *)getDateString_YearMonth1FromTimeIntervalSince1970:(NSTimeInterval)timeInterval
//{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:@"yyyy年M月"];
//    return [timeutils.dateFormatter stringFromDate:date];
//}
//
//+ (NSString *)getStringFromCalendarIntervalSince1970:(NSTimeInterval)timeInterval
//{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    if ([date isToday]) {
//        return NSLocalizedString(@"今天", @"");
//    } else if ([date isTomorrow]) {
//        return NSLocalizedString(@"明天", @"");
//    }
//    
//    return nil;
//}
//
//+ (NSString *)getWeekStringFromCalendarIntervalSince1970:(NSTimeInterval)timeInterval
//{
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    unsigned units = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit;
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    NSDateComponents *components = [calendar components:units fromDate:date];
//    switch ([components weekday]) {
//        case 2:
//            return @"星期一";
//            break;
//        case 3:
//            return @"星期二";
//            break;
//        case 4:
//            return @"星期三";
//            break;
//        case 5:
//            return @"星期四";
//            break;
//        case 6:
//            return @"星期五";
//            break;
//        case 7:
//            return @"星期六";
//            break;
//        case 1:
//            return @"星期天";
//            break;
//        default:
//            return @"No Week";
//            break;
//    }
//}
//
//+ (NSString*)exactTextFromTimeIntervalSince1970:(NSTimeInterval)timeInterval
//{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    NSTimeInterval theSeconds = [date timeIntervalSinceNow];
//    int seconds = 0 - theSeconds;
//    
//    
//    if (seconds >= 0 && seconds < 60) {//just now
//        return NSLocalizedString(@"刚刚", @"");
//    }
//    else if (seconds >= 60 && seconds < 60 * 60) {//min
//        return [NSString stringWithFormat:NSLocalizedString(@"%d分钟前", @""), seconds / 60];
//    }
//    else if (seconds >= 60 * 60 && seconds < 60 * 60 * 24) {//hour
//        return [NSString stringWithFormat:NSLocalizedString(@"%d小时前", @""), seconds / (60 * 60)];
//    }
//    else {
//         TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//        [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"MM-dd", @"")];
//        return [timeutils.dateFormatter stringFromDate:date];
//    }
//}
//+ (NSString*)middleTextWithChineseFromTimeIntervalSince1970:(NSTimeInterval)timeInterval withYear:(BOOL)flag
//{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    NSTimeInterval theSeconds = [date timeIntervalSinceNow];
//    int seconds = 0 - theSeconds;
//    
//    if (seconds >= 0 && seconds < 60) {//just now
//        return NSLocalizedString(@"刚刚", @"");
//    } else if (seconds >= 60 && seconds < 60 * 60) {//min
//        return NSLocalizedString(@"1小时前", @"");
//    } else if (seconds >= 60 * 60 && seconds < 60 * 60 * 24) {//hour
//        return [NSString stringWithFormat:NSLocalizedString(@"%d小时前", @""), seconds / (60 * 60)];
//    } else {
//        TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//        if (flag) {
//            [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy-MM-dd", @"")];
//        }else{
//            [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"MM-dd", @"")];
//        }
//        
//        return [timeutils.dateFormatter stringFromDate:date];
//    }
//}
//
//
//+ (NSString *)getTimeString_YYY:(NSDate*)date
//{
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy", @"")];
//    return [timeutils.dateFormatter stringFromDate:date];
//}
//
//+ (NSString *)timeAutomaticCup:(NSTimeInterval)timeInterval{
//    NSDate *tody = [NSDate date];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    
//    NSString *timeAutomaticCup;
//    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
//    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy", @"")];
//    if ([[timeutils.dateFormatter stringFromDate:date] isEqualToString:[timeutils.dateFormatter stringFromDate:tody]]) {
//        [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy-MM", @"")];
//        if ([[timeutils.dateFormatter stringFromDate:date] isEqualToString:[timeutils.dateFormatter stringFromDate:tody]]) {
//            [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy-MM-DD", @"")];
//            if ([[timeutils.dateFormatter stringFromDate:date] isEqualToString: [timeutils.dateFormatter stringFromDate:tody]]) {
//                timeAutomaticCup = [TimeIntervalUtils getStringFromDate_Hours:date];
//            }else{
//                timeAutomaticCup = [TimeIntervalUtils getMonthAndDayStringFromTimeIntervalSince1970:timeInterval];
//            }
//        }else{
//            timeAutomaticCup = [TimeIntervalUtils getMonthAndDayStringFromTimeIntervalSince1970:timeInterval];
//        }
//        
//    }else{
//        timeAutomaticCup = [TimeIntervalUtils getDateStringFromTimeIntervalSince1970:timeInterval];
//    }
//
//    return timeAutomaticCup;
//}

+ (BOOL)isSameYear:(NSDate*)date1 withDate:(NSDate*)date2
{
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy", @"")];

    NSString* d1 = [timeutils.dateFormatter stringFromDate:date1];
    NSString* d2 = [timeutils.dateFormatter stringFromDate:date2];

    if ([d1 isEqualToString:d2]) {
        return  YES;
    }
    else {
        return  NO;
    }
}

+ (BOOL)isSameDay:(NSDate*)date1 withDate:(NSDate*)date2;
{
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy-MM-DD", @"")];
    
    NSString* d1 = [timeutils.dateFormatter stringFromDate:date1];
    NSString* d2 = [timeutils.dateFormatter stringFromDate:date2];
    
    if ([d1 isEqualToString:d2]) {
        return  YES;
    }
    else {
        return  NO;
    }
}

+ (NSString*)getStringMDHMSFromTimeInterval:(NSTimeInterval)timeInterval
{
#if 1
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"MM-dd HH:mm", @"")];
    NSString* str = [timeutils.dateFormatter stringFromDate:date];
#else
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString* str = [dateFormatter stringFromDate:date];
#endif
    
    return str;
}

+ (NSString*)getStringYearMonthFromTimeinterval:(NSTimeInterval)timeInterval
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self getStringYearMonthFromDate:date];
}

+ (NSString*)getStringYearMonthDayFromTimeinterval:(NSTimeInterval)timeInterval
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self getStringYearMonthDayFromDate:date];
}

+ (NSString *)getCNStringYearMonthDayFromTimeinterval:(NSTimeInterval)timeInterval
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self getCNStringYearMonthDayFromDate:date];
}

+ (NSString*)getStringYMDHMFromTimeinterval:(NSTimeInterval)timeInterval
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [TimeIntervalUtils getStringYMDHMFromDate:date];
}

+ (NSString*)getShortStringYMDHMFromTimeinterval:(NSTimeInterval)timeInterval withDate:(NSDate*)now
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [TimeIntervalUtils getShortStringYMDHMFromDate:date withDate:now];
}

+ (NSString*)getSameStringYMDHMFromTimeinterval:(NSTimeInterval)timeInterval withDate:(NSDate*)now
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [TimeIntervalUtils getSameStringYMDHMFromDate:date withDate:now];
}

+ (NSString*)getCNSameStringYMDHMFromTimeinterval:(NSTimeInterval)timeInterval withDate:(NSDate*)now
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [TimeIntervalUtils getCNSameStringYMDHMFromDate:date withDate:now];
}



+ (NSString*)getStringYearMonthFromDate:(NSDate*)date
{
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy年MM月", @"")];
    NSString* str = [timeutils.dateFormatter stringFromDate:date];
    
    return str;
}

+ (NSString*)getStringYearMonthDayFromDate:(NSDate*)date
{
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy-MM-dd", @"")];
    NSString* str = [timeutils.dateFormatter stringFromDate:date];
    
    return str;
}

+ (NSString *)getCNStringYearMonthDayFromDate:(NSDate *)date
{
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy年MM月dd日", @"")];
    NSString* str = [timeutils.dateFormatter stringFromDate:date];
    
    return str;
}

+ (NSString*)getStringYMDHMFromDate:(NSDate*)date
{
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy-MM-dd HH:mm", @"")];
    NSString* str = [timeutils.dateFormatter stringFromDate:date];

    return str;
}

+ (NSString*)getShortStringYMDHMFromDate:(NSDate*)date withDate:(NSDate*)now
{
    NSString* formate = NSLocalizedString(@"yyyy-MM-dd HH:mm", @"");
    if (now == nil) {
        now = [NSDate date];
    }
    if ([TimeIntervalUtils isSameDay:now withDate:date]) {
        formate = NSLocalizedString(@"HH:mm", @"");
    }
    else if ([TimeIntervalUtils isSameYear:now withDate:date]) {
        formate = NSLocalizedString(@"MM-dd HH:mm", @"");
    }
    
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:formate];
    NSString* str = [timeutils.dateFormatter stringFromDate:date];
    
    return str;
}

+ (NSString*)getSameStringYMDHMFromDate:(NSDate*)date withDate:(NSDate*)now
{
    NSString* formate = NSLocalizedString(@"yyyy-MM-dd", @"");
    if (now == nil) {
        now = [NSDate date];
    }
    if ([TimeIntervalUtils isSameDay:now withDate:date]) {
        formate = NSLocalizedString(@"HH:mm", @"");
    }
    else if ([TimeIntervalUtils isSameYear:now withDate:date]) {
        formate = NSLocalizedString(@"MM-dd", @"");
    }
    
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:formate];
    NSString* str = [timeutils.dateFormatter stringFromDate:date];
    
    return str;
}

+ (NSString*)getCNSameStringYMDHMFromDate:(NSDate*)date withDate:(NSDate*)now
{
    NSString* formate = NSLocalizedString(@"yyyy年MM月dd日", @"");
    if (now == nil) {
        now = [NSDate date];
    }
    if ([TimeIntervalUtils isSameDay:now withDate:date]) {
        formate = NSLocalizedString(@"HH:mm", @"");
    }
    else if ([TimeIntervalUtils isSameYear:now withDate:date]) {
        formate = NSLocalizedString(@"MM月dd日", @"");
    }
    
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:formate];
    NSString* str = [timeutils.dateFormatter stringFromDate:date];
    
    return str;
}


+ (NSString*)getShortStringFrom:(NSTimeInterval)sTime to:(NSTimeInterval)eTime
{
    return [TimeIntervalUtils getShortStringFrom:sTime to:eTime connectBy:@"-"];
}

+ (NSString*)getShortStringFrom:(NSTimeInterval)sTime to:(NSTimeInterval)eTime connectBy:(NSString*)ch
{
    if (ch.length == 0) {
        ch = @" ";
    }
    NSString* s1 = [TimeIntervalUtils getStringYMDHMFromTimeinterval:sTime];
    NSDate* now = [NSDate dateWithTimeIntervalSince1970:sTime];
    NSString* s2 = [TimeIntervalUtils getShortStringYMDHMFromTimeinterval:eTime withDate:now];
    
    NSString* str = [NSString stringWithFormat:@"%@%@%@", s1, ch, s2];
    
    return str;
}


@end
