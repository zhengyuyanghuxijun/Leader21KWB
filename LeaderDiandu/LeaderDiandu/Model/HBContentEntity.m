//
//  HBContentEntity.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/2.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBContentEntity.h"

@implementation HBContentEntity

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.bookId = [value integerValue];
    }
}

@end
