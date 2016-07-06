//
//  NSString+HBExt.m
//  LediKWB
//
//  Created by ChunGuo on 15/12/11.
//  Copyright © 2016年 huxijun. All rights reserved.
//

#import "NSString+HBExt.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (MD5)

- (NSString*) MD5 {
    unsigned int outputLength = CC_MD5_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_MD5(self.UTF8String, [self UTF8Length], output);
    return [self toHexString:output length:outputLength];
}

- (unsigned int) UTF8Length {
    return (unsigned int) [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*) toHexString:(unsigned char*) data length: (unsigned int) length {
    NSMutableString* hash = [NSMutableString stringWithCapacity:length * 2];
    for (unsigned int i = 0; i < length; i++) {
        [hash appendFormat:@"%02x", data[i]];
        data[i] = 0;
    }
    return hash;
}

@end



@implementation NSString (SHA)

- (NSString*) SHA1 {
    unsigned int outputLength = CC_SHA1_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_SHA1(self.UTF8String, [self UTF8Length], output);
    return [self toHexString:output length:outputLength];
}

- (NSString*) SHA256 {
    unsigned int outputLength = CC_SHA256_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_SHA256(self.UTF8String, [self UTF8Length], output);
    return [self toHexString:output length:outputLength];
}

- (unsigned int) UTF8Length {
    return (unsigned int) [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*) toHexString:(unsigned char*) data length: (unsigned int) length {
    NSMutableString* hash = [NSMutableString stringWithCapacity:length * 2];
    for (unsigned int i = 0; i < length; i++) {
        [hash appendFormat:@"%02x", data[i]];
        data[i] = 0;
    }
    return hash;
}

@end



@implementation NSString (HMAC_MD5)

+ (NSString *)HMAC_MD5:(NSString *)key Value:(NSString *)value
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [value cStringUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t cHMAC[CC_MD5_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgMD5, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", cHMAC[i]];
    }
    
    hash = output;
    return hash;
}

@end



@implementation NSString (HMAC_SHA)

+ (NSString *)HMAC_SHA1:(NSString *)key Value:(NSString *)value
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [value cStringUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", cHMAC[i]];
    }
    
    hash = output;
    return hash;
}

+ (NSString *)HMAC_SHA256:(NSString *)key Value:(NSString *)value
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [value cStringUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", cHMAC[i]];
    }
    
    hash = output;
    return hash;
}

@end



@implementation NSString (OAURLEncodingAdditions)

- (NSString *)URLEncodeString
{
    //同：stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

- (NSString *)URLEncodeStringByLegalCharacters
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

- (NSString *)URLDecodeString
{
    NSString*result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                          (CFStringRef)self,
                                                                                          CFSTR(""),
                                                                                          kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

@end




@implementation NSString (Common)

- (NSString *)trim
{
    //去除前后空格和换行符
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return str;
}

- (BOOL)isEmpty
{
    NSString *trimStr = [self trim];
    if ([trimStr length] == 0)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)myContainsString:(NSString *)other
{
    if (other == nil || self == nil) {
        return NO;
    }
    NSRange range = [self rangeOfString:other];
    return range.length != 0;
}

@end




@implementation NSString (TimeShow)

- (NSString *)getFormatTimeShow
{
    if ([self isEmpty])
    {
        return @"";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (self.length == 19)
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    else
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss SSS"];
    }
    
    NSDate *currentDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
    NSDate *senderDate = [dateFormatter dateFromString:self];
    
    //得到相差秒数
    NSTimeInterval time = [currentDate timeIntervalSinceDate:senderDate];
    
    NSInteger months = ((NSInteger)time)/(3600*24*30);
    NSInteger days = ((NSInteger)time)%(3600*24*30)/(3600*24);
    NSInteger hours = ((NSInteger)time)%(3600*24)/3600;
    NSInteger minute = ((NSInteger)time)%3600/60;
    
    NSString *dateContent = @"";
    
    if (months > 0 || days > 1)
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        dateContent = [dateFormatter stringFromDate:senderDate];
    }
    else if (days == 1)
    {
        dateContent = [NSString stringWithFormat:@"%@天前", @(days)];
    }
    else if(hours > 0)
    {
        dateContent = [NSString stringWithFormat:@"%@小时前", @(hours)];
    }
    else if(minute > 0)
    {
        dateContent = [NSString stringWithFormat:@"%@分钟前", @(minute)];
    }
    else
    {
        dateContent = @"刚刚";
    }
    
    [dateFormatter release];
    
    return dateContent;
}

@end



@implementation NSString (Birthday)

- (NSString *)getAfterYear
{
    if ([self isEmpty])
    {
        return @"";
    }
    
    NSString *s = [self substringWithRange:NSMakeRange(2, 1)];
    NSString *str = [NSString stringWithFormat:@"%@0后", s];
    
    return str;
}

- (NSString *)getConstellation
{
    if ([self isEmpty])
    {
        return @"";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:self];
    
    [dateFormatter setDateFormat:@"MM"];
    NSInteger month = [[dateFormatter stringFromDate:date] integerValue];
    
    [dateFormatter setDateFormat:@"dd"];
    NSInteger day = [[dateFormatter stringFromDate:date] integerValue];
    [dateFormatter release];
    
    NSString *str = @"";
    
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18))
    {
        str = @"水瓶座";
    }
    else if ((month == 2 && day >= 19) || (month == 3 && day <= 20))
    {
        str = @"双鱼座";
    }
    else if ((month == 3 && day >= 21) || (month == 4 && day <= 19))
    {
        str = @"白羊座";
    }
    else if ((month == 4 && day >= 20) || (month == 5 && day <= 20))
    {
        str = @"金牛座";
    }
    else if ((month == 5 && day >= 21) || (month == 6 && day <= 21))
    {
        str = @"双子座";
    }
    else if ((month == 6 && day >= 22) || (month == 7 && day <= 22))
    {
        str = @"巨蟹座";
    }
    else if ((month == 7 && day >= 23) || (month == 8 && day <= 22))
    {
        str = @"狮子座";
    }
    else if ((month == 8 && day >= 23) || (month == 9 && day <= 22))
    {
        str = @"处女座";
    }
    else if ((month == 9 && day >= 23) || (month == 10 && day <= 23))
    {
        str = @"天秤座";
    }
    else if ((month == 10 && day >= 24) || (month == 11 && day <= 21))
    {
        str = @"天蝎座";
    }
    else if ((month == 11 && day >= 22) || (month == 12 && day <= 21))
    {
        str = @"射手座";
    }
    else if ((month == 12 && day >= 22) || (month == 1 && day <= 19))
    {
        str = @"摩羯座";
    }
    
    return str;
}

- (NSInteger)getAge
{
    if ([self isEmpty])
    {
        return 0;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:self];
    NSDate *currentDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
    
    [dateFormatter setDateFormat:@"yyyy"];
    NSInteger year = [[dateFormatter stringFromDate:date] integerValue];
    NSInteger currentYear = [[dateFormatter stringFromDate:currentDate] integerValue];
    [dateFormatter release];
    
    NSInteger age = currentYear - year;
    
    return age;
}

@end

@implementation NSString (Json)

- (NSDictionary *)strToDict
{
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    return dict;
}

@end

