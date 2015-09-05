//
//  NSString+Extra.m
//  Roosher
//
//  Created by Levin on 10-9-27.
//  Copyright 2010 Roosher inc. All rights reserved.
//

#import "NSString+Extra.h"

//#import "md5.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Extra)


+ (NSString*)stringWithNewUUID {
    // Create a new UUID
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, uuidObj);
    NSString *result = (__bridge_transfer NSString *)CFStringCreateCopy(NULL, uuidString);
    CFRelease(uuidObj);
    CFRelease(uuidString);
    return result;
}

- (NSString *)URLEncodedString {
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (__bridge CFStringRef)self,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
	return result;
}

- (NSString*)URLDecodedString {
	NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (__bridge CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8);
	return result;	
}

- (NSString*)stringByTrimmingBoth {
    NSString *trimmed = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmed;
}

- (NSString*)stringByTrimmingLeadingWhitespace {
    NSInteger i = 0;
    
    while ([[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:i]]) {
        i++;
    }
    return [self substringFromIndex:i];
}

+ (NSString*)formatYearMonthDayHourMinute:(NSTimeInterval)interval
{
    NSLog(@"interval:%f", interval);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat: @"MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [formatter stringFromDate:date];
}

+ (NSString*)formatYearMonth:(NSTimeInterval)interval
{
    if (interval == 0) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat: @"yyyy.MM"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [formatter stringFromDate:date];
}

+ (NSString*)formatYearMonthCN:(NSTimeInterval)interval
{
    if (interval == 0) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat: @"yyyy年M月"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [formatter stringFromDate:date];
}

+ (NSString*)formatYearMonthDay:(NSTimeInterval)interval
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [formatter stringFromDate:date];
}

+ (NSString*)formatDay:(NSTimeInterval)interval
{
    if (interval == 0) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat: @"dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [formatter stringFromDate:date];
}

+ (NSString*)formatHourMinute:(NSTimeInterval)interval
{
    if (interval == 0) {
        return @"";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat: @"HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [formatter stringFromDate:date];
}

- (CGFloat)measureTextHeight:(UIFont *)desFont desWidth:(CGFloat)desWidth
{
    if (self.length < 1) {
        return 10.0f;
    }
    
    CGFloat result = 0.0f;

    CGSize textSize = CGSizeMake(desWidth, 10000.0f);
    CGSize size = [self sizeWithFont:desFont
                   constrainedToSize:textSize
                       lineBreakMode:NSLineBreakByWordWrapping];
    result = size.height;	// at least one row

    return result;
}


- (NSString*)base64MD5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
//    MD5CPP(cStr, strlen(cStr), result); // This is the md5 call
    
    NSData* data = [NSData dataWithBytes:result length:16];
    NSString* base64 = [data base64Encoding];
    
    return base64;
}

- (NSString*)trimText
{
    if (self.length > 0) {
        NSCharacterSet* set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString* text = [self stringByTrimmingCharactersInSet:set];
        return text;
    }
    else {
        return self;
    }
}


@end
