//
//  HBBaseEntity.m
//  LeaderDiandu
//
//  Created by xijun on 15/8/29.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBBaseEntity.h"

@implementation HBBaseEntity

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    //    NSLog(@"%s - %d - Undefined Key:%@", __func__, __LINE__, key);
}

- (void)setNilValueForKey:(NSString *)key {
    //    NSLog(@"%s - %d - nil Key:%@", __func__, __LINE__, key);
    [self setValue:@"0" forKey:key];
}

@end
