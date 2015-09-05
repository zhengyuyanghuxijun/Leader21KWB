//
//  NSDictionary+Safe.m
//  magicEnglish
//
//  Created by tianlibin on 14-3-23.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "NSDictionary+Safe.h"

@implementation NSDictionary (Safe)


- (NSString*)stringForKey:(NSString*)key
{
    if (key.length > 0) {
        NSString* obj = [self objectForKey:key];
        if ([obj isKindOfClass:[NSString class]]) {
            return obj;
        }
    }
    return nil;
}

- (NSNumber*)numberForKey:(NSString*)key
{
    if (key.length > 0) {
        NSNumber* obj = [self objectForKey:key];
        if ([obj isKindOfClass:[NSNumber class]]) {
            return obj;
        }
    }
    return nil;
}

- (NSDictionary*)dicForKey:(NSString*)key
{
    if (key.length > 0) {
        NSDictionary* obj = [self objectForKey:key];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            return obj;
        }
    }
    return nil;
}

- (NSArray*)arrayForKey:(NSString*)key
{
    if (key.length > 0) {
        NSArray* obj = [self objectForKey:key];
        if ([obj isKindOfClass:[NSArray class]]) {
            return obj;
        }
    }
    return nil;
}


- (NSString*)stringForKey:(NSString*)key defautValue:(NSString*)value
{
    NSString* obj = [self stringForKey:key];
    if (obj != nil) {
        return obj;
    }
    else {
        return value;
    }
}

- (NSNumber*)numberForKey:(NSString*)key defautValue:(NSNumber*)value
{
    NSNumber* obj = [self numberForKey:key];
    if (obj != nil) {
        return obj;
    }
    else {
        return value;
    }
}

- (NSDictionary*)dicForKey:(NSString*)key defautValue:(NSDictionary*)value
{
    NSDictionary* obj = [self dicForKey:key];
    if (obj != nil) {
        return obj;
    }
    else {
        return value;
    }
}

- (NSArray*)arrayForKey:(NSString*)key defautValue:(NSArray*)value
{
    NSArray* obj = [self arrayForKey:key];
    if (obj != nil) {
        return obj;
    }
    else {
        return value;
    }
}

- (NSInteger)integerForKey:(NSString*)key
{
    NSNumber* val = [self numberForKey:key];
    if (val == nil) {
        NSString* str = [self stringForKey:key];
        return str.integerValue;
    }
    
    return val.integerValue;
}

- (long long)longForKey:(NSString*)key
{
    NSNumber* val = [self numberForKey:key];
    if (val == nil) {
        NSString* str = [self stringForKey:key];
        return str.longLongValue;
    }
    
    return val.longLongValue;
}


@end
