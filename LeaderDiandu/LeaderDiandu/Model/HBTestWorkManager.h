//
//  HBTestWorkManager.h
//  LeaderDiandu
//
//  Created by xijun on 15/9/19.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBTestWorkManager : NSObject

//计算文件夹下文件的总大小
+ (long)fileSizeForDir:(NSString*)path;

- (void)parseTestWork:(NSString *)path;

@end
