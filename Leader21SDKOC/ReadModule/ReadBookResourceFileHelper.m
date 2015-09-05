//
//  ReadBookResourceFileHelper.m
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-15.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookResourceFileHelper.h"
#import "DataEngine.h"
#import "ReadBookDecrypt.h"
#import "LocalSettings.h"

@implementation ReadBookResourceFileHelper

//+ (NSString *)documentPath
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [paths objectAtIndex:0];
//    return docDir;
//}

+ (NSString *)userDocumentPath
{
//    if ([DE me].userID == nil) {
        return [NSString stringWithFormat:@"%@/0",[LocalSettings bookCachePath]];
//    }
//    else
//    {
//        return [NSString stringWithFormat:@"%@/%@",[LocalSettings bookCachePath],DE.me.userID];
//    }
    
}

+ (NSString *)userDocumentPath:(BOOL)isBookFree
{
    if (isBookFree) {
        return [NSString stringWithFormat:@"%@/0",[LocalSettings bookCachePath]];
    }
    else
    {
        return [self userDocumentPath];
    }
    
}

+ (NSString *)readFile:(NSString *)filePath
{
    NSData *readerData = [NSData dataWithContentsOfFile:filePath];
    NSString *resStr = [[NSString alloc] initWithData:readerData encoding:NSUTF8StringEncoding];
    return resStr;
}

+ (BOOL)isExistFile:(NSString *)filePath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (NSArray *)filesInDoc:(NSString *)docPath
{
    NSError *error = nil;
    NSArray *filesArray = [FILE_MANAGER contentsOfDirectoryAtPath:docPath error:&error];
    if (error) {
        return nil;
    }
    else
    {
        return filesArray;
    }
}

+ (BOOL)isFileFolder:(NSString *)filePath
{
    NSError *error = nil;
    NSDictionary *attribs = [FILE_MANAGER attributesOfItemAtPath:filePath error:&error];
    if (error) {
        return NO;
    }
    else
    {
        if ([attribs objectForKey:@"NSFileType"] == NSFileTypeDirectory) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}
@end
