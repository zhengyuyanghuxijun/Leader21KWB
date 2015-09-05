//
//  DataCheckUtil.h
//  magicEnglish
//
//  Created by liu cf on 12-10-23.
//  Copyright (c) 2012年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCheckUtil : NSObject
+(BOOL)containOnlyDigit: (NSString*) string;//校验只包含数字
+(BOOL)checkEmail:(NSString *)emailStr;//电子邮箱校验
+(BOOL)checkAccount:(NSString *)emailStr;
+(BOOL)isPhoneNum: (NSString*) string;//移动手机号校验
+ (int)wordCount:(NSString*)str;//统计字符串个数.
+ (BOOL)isAllCheseWords:(NSString *)str; //判断是否全是汉字
+(NSUInteger) unicodeLengthOfString: (NSString *) text;//统计字数的方法：一个汉字占一个字数，两个字母或数字占一个字字数
+ (BOOL)string:(NSString*)string lengthBetween:(NSInteger)min andMax:(NSInteger)max;

@end
