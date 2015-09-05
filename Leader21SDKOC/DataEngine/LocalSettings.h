//
//  LocalSettings.h
//  Three Hundred
//
//  Created by skye on 8/6/11.
//  Copyright 2011 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BookEntity;

@interface LocalSettings : NSObject

+ (void)createDirectory:(NSString *)path;
+ (void)createDirectoryForUser:(NSString *)userId;

+ (NSString*)documentPath;

+ (NSString*)bookCachePath;

+ (NSString*)bookDirectoryForUser:(NSString*)userId;
+ (NSString*)bookPathForCurrentUser:(NSString*)bookId;
+ (NSString*)bookPathForDefaultUser:(NSString*)bookId;

+ (NSString*)downingDirectoryForBook:(BookEntity*)book;
//+ (NSString*)downingPathForCurrentUser:(NSString*)bookId;
//+ (NSString*)downingPathForDefaultUser:(NSString*)bookId;

+ (BOOL)findBookLoginOrNot:(NSString*)bookId;



+ (NSArray *)readEmailSuffixArray;

+ (BOOL)downLoadIn3G;
+ (void)resetDownloadIn3G:(BOOL)down;

@end
