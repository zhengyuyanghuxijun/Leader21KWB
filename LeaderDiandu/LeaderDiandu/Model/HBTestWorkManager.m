//
//  HBTestWorkManager.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/19.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBTestWorkManager.h"

#define KLeaderSelection    @"selection"//选择题
#define KLeaderJudge        @"judge"    //判断题
#define KLeaderPair         @"pair"     //连线题

#define KLeaderQuestion     @"questions"

@interface HBTestWorkManager ()

@property (nonatomic, strong)NSString *workPath;

@end

@implementation HBTestWorkManager

- (void)parseTestWork:(NSString *)path
{
    self.workPath = path;
    
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取path下全部文件及文件夹
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
    NSMutableArray *dictArray = [[NSMutableArray alloc] init];
    for (NSString *file in fileList) {
        //完整路径
        NSString *fullPath = [path stringByAppendingPathComponent:file];
        //获取后缀名
        NSString *extension = [file pathExtension];
        if ([extension isEqualToString:@"json"]) {
            //获取文件名
            NSString *fileName = [file stringByDeletingPathExtension];
            if ([fileName isEqualToString:KLeaderSelection]) {
                //json解析
                NSData *fileData = [fileManager contentsAtPath:fullPath];
                NSDictionary *workDict = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingAllowFragments error:&error];
                [dictArray insertObject:workDict atIndex:0];
            } else if ([fileName isEqualToString:KLeaderJudge]) {
                NSData *fileData = [fileManager contentsAtPath:fullPath];
                NSDictionary *workDict = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingAllowFragments error:&error];
                [dictArray addObject:workDict];
            }
        }
    }
    
    NSMutableArray *workArray = nil;
    NSInteger count = [dictArray count];
    for (NSInteger i=0; i<count; i++) {
        NSDictionary *dict = dictArray[i];
        NSArray *array = dict[KLeaderQuestion];
        if (i == 0) {
            workArray = [NSMutableArray arrayWithArray:array];
        } else {
            [workArray addObjectsFromArray:array];
        }
    }
    
    self.workArray = workArray;
}

- (UIImage *)getPicture:(NSString *)fileName
{
    UIImage *image = nil;
    if (fileName) {
        NSString *imgFileName = [NSString stringWithFormat:@"%@/pics/%@", _workPath, fileName];
        image = [UIImage imageWithContentsOfFile:imgFileName];
    }
    
    return image;
}

- (NSArray *)getOptionArray:(NSDictionary *)dict
{
    NSMutableArray *optionArr = [[NSMutableArray alloc] init];
    NSArray *array = dict[@"Options"];
    for (NSString *option in array) {
        if ([[option pathExtension] isEqualToString:@"jpg"]) {
            NSString *imgFileName = [NSString stringWithFormat:@"%@/pics/%@", _workPath, option];
            UIImage *image = [UIImage imageWithContentsOfFile:imgFileName];
            [optionArr addObject:image];
        } else {
            [optionArr addObject:option];
        }
    }
    
    return optionArr;
}

- (NSDictionary *)getQuestion:(NSInteger)index
{
    if (index>=0 && index<[self.workArray count]) {
        self.selIndex = index;
        return self.workArray[index];
    }
    return nil;
}

//计算文件夹下文件的总大小
+ (long)fileSizeForDir:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    long size = 0;
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            size += fileAttributeDic.fileSize;
        }
        else
        {
            [self fileSizeForDir:fullPath];
        }
    }

    return size;
}

@end
