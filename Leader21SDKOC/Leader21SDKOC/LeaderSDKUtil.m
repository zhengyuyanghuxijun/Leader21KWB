//
//  LeaderSDKUtil.m
//  Leader21SDKOC
//
//  Created by xijun on 15/9/19.
//  Copyright (c) 2015年 leader. All rights reserved.
//

#import "LeaderSDKUtil.h"

@implementation LeaderSDKUtil

+ (instancetype)defaultSDKUtil
{
    static id instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (DownloadEntity *)queryEntityByUrl:(NSString *)url
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND downloadUrl == %@", @(0), url];
    DownloadEntity* e = (DownloadEntity*)[CoreDataHelper getFirstObjectWithEntryName:@"DownloadEntity" withPredicate:predicate];
    return e;
}

@end
