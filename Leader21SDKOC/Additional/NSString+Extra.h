//
//  NSString+Extra.h
//  Roosher
//
//  Created by Levin on 10-9-27.
//  Copyright 2010 Roosher inc. All rights reserved.
//

@interface NSString (Extra)

+ (NSString*)stringWithNewUUID;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

- (NSString*)stringByTrimmingBoth;
- (NSString*)stringByTrimmingLeadingWhitespace;

+ (NSString*)formatYearMonthDayHourMinute:(NSTimeInterval)interval;
+ (NSString*)formatYearMonth:(NSTimeInterval)interval;
+ (NSString*)formatYearMonthCN:(NSTimeInterval)interval;
+ (NSString*)formatYearMonthDay:(NSTimeInterval)interval;
+ (NSString*)formatDay:(NSTimeInterval)interval;
+ (NSString*)formatHourMinute:(NSTimeInterval)interval;

- (CGFloat)measureTextHeight:(UIFont *)desFont desWidth:(CGFloat)desWidth;


- (NSString*)base64MD5;

- (NSString*)trimText;

@end
