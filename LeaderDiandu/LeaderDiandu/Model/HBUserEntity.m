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

- (NSString *)getUpAccountName
{
    if (self.type == 1) {
        return self.name;
    }
    if (self.name) {
        return [self.name uppercaseString];
    }
    return self.name;
}

@end
