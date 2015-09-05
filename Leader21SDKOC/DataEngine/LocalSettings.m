//
//  LocalSettings.m
//  Three Hundred
//
//  Created by skye on 8/6/11.
//  Copyright 2011 ilovedev.com. All rights reserved.
//

#import "LocalSettings.h"

#import "BookEntity.h"
#import "DataEngine.h"


@interface LocalSettings ()


@end

@implementation LocalSettings


+ (void)createDirectory:(NSString *)path
{
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        NSError* error = nil;
		[fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error != nil) {
            NSLog(@"CreateDicrectior Error:%@", error);
        }
    }
}

+ (void)createDirectoryForUser:(NSString *)userId
{
    //    NSString* doc = [self documentPath];
    NSString* cache = [self bookCachePath];
    //    NSString* path1 = nil;
    NSString* path2 = nil;
    if (userId.length == 0) {
        //        path1 = [NSString stringWithFormat:@"%@/0", doc];
        path2 = [NSString stringWithFormat:@"%@/0", cache];
    }
    else {
        //        path1 = [NSString stringWithFormat:@"%@/%@", doc, userId];
        path2 = [NSString stringWithFormat:@"%@/%@", cache, userId];
    }
    
    //    [self createDirectory:path1];
    [self createDirectory:path2];
}

+ (BOOL)checkDirectory:(NSString*)path
{
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        return YES;
    }
    else {
        return NO;
    }
}


+ (NSString*)documentPath
{
    NSArray *documenetPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([documenetPaths count] > 0) {
        return [documenetPaths objectAtIndex:0];
    }
    else {
        return @"";
    }
}

+ (NSString*)bookCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0) {
        return [paths objectAtIndex:0];
    }
    else {
        return @"";
    }
}


+ (NSString*)bookDirectoryForUser:(NSString*)userId
{
    NSString* doc = [self bookCachePath];
    NSString* path = @"";
    path = [NSString stringWithFormat:@"%@/%@", doc, userId];
    
    return path;
}

+ (NSString*)bookPathForCurrentUser:(NSString*)bookId
{
    NSString* path = [self bookDirectoryForUser:DE.mAppId];
    path = [NSString stringWithFormat:@"%@/%@", path, bookId];
    [self createDirectory:path];
    
    return path;
}

+ (NSString*)bookPathForDefaultUser:(NSString*)bookId
{
    NSString* doc = [self bookCachePath];
    NSString* path = [NSString stringWithFormat:@"%@/0", doc];
    path = [NSString stringWithFormat:@"%@/%@", path, bookId];
    [self createDirectory:path];
    
    return path;
}

+ (NSString*)downingDirectoryForBook:(BookEntity*)book
{
    NSString* doc = [self documentPath];
    NSString* path = [NSString stringWithFormat:@"%@/downing", doc];
    [self createDirectory:path];
    

    path = [NSString stringWithFormat:@"%@/%@", path, @"0"];
    
    [self createDirectory:path];
    
    NSString* file = [NSString stringWithFormat:@"%@/%@", path, book.bookId];
    
    return file;
}

//+ (NSString*)downingPathForCurrentUser:(NSString*)bookId
//{
//    NSString* path = [self downingDirectoryForUser:DE.me.userID.stringValue];
//    path = [NSString stringWithFormat:@"%@/%@", path, bookId];
//    [self createDirectory:path];
//    
//    return path;
//}
//
//+ (NSString*)downingPathForDefaultUser:(NSString*)bookId
//{
//    NSString* path = [self downingDirectoryForUser:@"0"];
//    path = [NSString stringWithFormat:@"%@/%@", path, bookId];
//    [self createDirectory:path];
//    
//    return path;
//}

+ (BOOL)findBookLoginOrNot:(NSString*)bookFile
{
    NSString* fileName = [bookFile lowercaseString];
    NSString* path = [self bookPathForCurrentUser:fileName];
    if ([self checkDirectory:path]) {
        // 看下有没有文件
        NSArray* sub = [[NSFileManager defaultManager] subpathsAtPath:path];
        if ([sub count] > 0) {
            return YES;
        }
    }
    
    NSString* path2 = [self bookPathForDefaultUser:fileName];
    if ([self checkDirectory:path2]) {
        // 看下有没有文件
        NSArray* sub = [[NSFileManager defaultManager] subpathsAtPath:path2];
        if ([sub count] > 0) {
            return YES;
        }
    }
    
    
    return NO;
}



+ (NSArray *)readEmailSuffixArray
{
    NSError *error;
    NSArray *lines = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle]
                                                          pathForResource:@"emailSuffix"
                                                          ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error]
					  componentsSeparatedByString:@"\n"];
    return lines;
}

+ (BOOL)downLoadIn3G
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"kDownloadIn3G"];
}

+ (void)resetDownloadIn3G:(BOOL)down
{
    [[NSUserDefaults standardUserDefaults] setBool:down forKey:@"kDownloadIn3G"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
