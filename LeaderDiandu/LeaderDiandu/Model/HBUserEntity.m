//
//  HBUserEntity.m
//  LeaderDiandu
//
//  Created by xijun on 15/8/30.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBUserEntity.h"

@implementation HBUserEntity

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.userid = [value integerValue];
    } else if ([key isEqualToString:@"class"]) {
        self.myClass = value;
    }
}

@end
