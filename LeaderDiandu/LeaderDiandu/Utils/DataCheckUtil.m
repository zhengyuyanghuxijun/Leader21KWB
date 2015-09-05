//
//  DataCheckUtil.m
//  magicEnglish
//
//  Created by liu cf on 12-10-23.
//  Copyright (c) 2012年 ilovedev.com. All rights reserved.
//

#import "DataCheckUtil.h"

@implementation DataCheckUtil
+(BOOL)containOnlyDigit: (NSString*) string
{
    NSString *regex = @"^[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:string] == YES) {
        return YES;
    }
    return NO;
}

+(BOOL)isPhoneNum: (NSString*) string
{
    
    if ([self containOnlyDigit:string] && string.length==11) {
        return YES;
    }
    return NO;
}

//电子邮箱校验
+(BOOL)checkEmail:(NSString *)emailStr
{
    NSString *regex = @"[A-Z0-9a-z._-]+@[A-Za-z0-9._-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:emailStr];
}

+(BOOL)checkAccount:(NSString *)emailStr
{
    NSString *regex = @"[A-Z0-9a-z_]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:emailStr];
}

+ (int)wordCount:(NSString*)str
{
    int i,n=[str length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[str characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}

+ (BOOL)isAllCheseWords:(NSString *)str
{
    if (str == nil || [str length] == 0) {
        return NO;
    }

    for (int i = 0; i < [str length]; i++) {
        unichar c = [str characterAtIndex:i];
        if (!(c >= 0x4e00 && c < 0x9fff)) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)string:(NSString*)string lengthBetween:(NSInteger)min andMax:(NSInteger)max
{
    if (string.length >= min && string.length <= max) {
        return YES;
    }
    else {
        return NO;
    }
}
/*
 *  统计字数的方法：一个汉字占一个字数，两个字母或数字占一个字字数
 */
+(NSUInteger) unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        
        unichar uc = [text characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength / 2;
    
    if(asciiLength % 2) {
        unicodeLength++;
    }
    
    return unicodeLength;
}
@end
