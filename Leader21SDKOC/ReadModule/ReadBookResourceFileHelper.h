//
//  ReadBookResourceFileHelper.h
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-15.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FILE_MANAGER                  [NSFileManager defaultManager]
#define FILE_EXCEPTION                (-1)

@interface ReadBookResourceFileHelper : NSObject

//+ (NSString *)documentPath;
+ (NSString *)userDocumentPath;
+ (NSString *)userDocumentPath:(BOOL)isBookFree;
+ (NSString *)readFile:(NSString *)filePath;
+ (BOOL)isExistFile:(NSString *)filePath;
+ (NSArray *)filesInDoc:(NSString *)docPath;
+ (BOOL)isFileFolder:(NSString *)filePath;

@end
