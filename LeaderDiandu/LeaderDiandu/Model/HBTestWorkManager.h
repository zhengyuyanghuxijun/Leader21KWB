//
//  HBTestWorkManager.h
//  LeaderDiandu
//
//  Created by xijun on 15/9/19.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBTestWorkManager : NSObject

@property (nonatomic, strong)NSArray *workArray;
@property (nonatomic, assign)NSInteger selIndex;

- (void)parseTestWork:(NSString *)path;

- (NSDictionary *)getQuestion:(NSInteger)index;

- (UIImage *)getPicture:(NSString *)fileName;

- (NSArray *)getOptionArray:(NSDictionary *)dict;

//计算文件夹下文件的总大小
+ (long)fileSizeForDir:(NSString*)path;

@end
