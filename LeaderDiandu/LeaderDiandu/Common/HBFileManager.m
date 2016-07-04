//
//  TFFileManager.m
//  LediKWB
//
//  Created by ChunGuo on 15/12/11.
//  Copyright © 2016年 huxijun. All rights reserved.
//

#import "HBFileManager.h"

@implementation TFFileManager

+ (NSString *)getHomePath
{
    NSString *path = NSHomeDirectory();
    
    return path;
}

+ (NSString *)getDocumentsPath
{
    NSString *path =[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    return path;
}

+ (NSString *)getTempPath
{
    NSString *path = NSTemporaryDirectory();
    
    return path;
}

+ (NSString *)getCachePath
{
    NSString *libraryPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
    NSString *path = [libraryPath stringByAppendingPathComponent:@"Caches"];
    
    return path;
}

+ (NSString *)getBundlePath:(NSString *)fileName
{
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

+ (NSString *) getFilePathWithParentPath:(NSString *) parentPath fileName:(NSString *) fileName
{
    NSString *filePath = nil;
    
    if (parentPath && parentPath.length > 0 && fileName && fileName.length > 0) {
        filePath = [parentPath stringByAppendingPathComponent:fileName];
    }
    
    return filePath;
}

+ (BOOL)fileExistsAtPath:(NSString*)path isDirectory:(BOOL)isDir
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
}

+ (BOOL)createFile:(NSString *)fileName AtsandBox:(SANDBOXPATH)sbPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL ifSucceed = NO;
    
    if (sbPath == EDocuments) {
        NSString *documentsPath = [self getDocumentsPath];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
        BOOL isExists = [self fileExistsAtPath:filePath isDirectory:NO];
        if (isExists == NO) {
            ifSucceed = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        }
    }else if (sbPath == ETemp){
        NSString *tempPath = [self getTempPath];
        NSString *filePath = [tempPath stringByAppendingPathComponent:fileName];
        BOOL isExists = [self fileExistsAtPath:filePath isDirectory:NO];
        if (isExists == NO) {
            ifSucceed = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        }
    }
    
    return ifSucceed;
}

+ (BOOL)deleteFile:(NSString *)fileName AtsandBox:(SANDBOXPATH)sbPath
{
    NSString *filePath = @"";
    
    if (sbPath == EDocuments) {
        NSString *documentsPath = [self getDocumentsPath];
        filePath = [documentsPath stringByAppendingPathComponent:fileName];
        BOOL isExists = [self fileExistsAtPath:filePath isDirectory:NO];
        if (isExists == NO) {
            return YES;
        }
    }else if (sbPath == ETemp){
        NSString *documentsPath = [self getDocumentsPath];
        filePath = [documentsPath stringByAppendingPathComponent:fileName];
        BOOL isExists = [self fileExistsAtPath:filePath isDirectory:NO];
        if (isExists == NO) {
            return YES;
        }
    }
    
    return [[NSFileManager defaultManager]
            removeItemAtPath:filePath
            error:nil];
}

+ (BOOL)copyFile:(NSString *)srcPath toPath:(NSString *)toPath
{
    BOOL isOk = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:toPath])
    {
        NSError *error = nil;
        [TFFileManager createFolder:[toPath stringByDeletingLastPathComponent]];
        [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:toPath error:&error];
        [[NSFileManager defaultManager] setAttributes:[NSDictionary dictionaryWithObject:NSFileProtectionNone forKey:NSFileProtectionKey] ofItemAtPath:toPath error:&error];
        if (error)
        {
            isOk = NO;
        }
    }
    return isOk;
}

+ (BOOL)createFileAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [self fileExistsAtPath:filePath isDirectory:NO];
    
    if (isExists == YES) {
        return YES;
    }
    
    return [fileManager createFileAtPath:filePath contents:nil attributes:nil];
}

+ (BOOL)deleteFileAtPath:(NSString *)filePath
{
    BOOL isExists = [self fileExistsAtPath:filePath isDirectory:NO];
    
    if (isExists == NO) {
        return YES;
    }
    
    return [[NSFileManager defaultManager]
            removeItemAtPath:filePath
            error:nil];
    
}

+ (BOOL)createFolder:(NSString *)folderPath
{
    return [[NSFileManager defaultManager] createDirectoryAtPath:folderPath
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:nil];
}

+ (BOOL)createFolder:(NSString *)folderName atParentPath:(NSString *)parentPath
{
    NSString *directory = [parentPath stringByAppendingPathComponent:folderName];
    
    return [[NSFileManager defaultManager] createDirectoryAtPath:directory
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:nil];
}

+ (BOOL)deleteDirectory:(NSString *)path
{
    return [[NSFileManager defaultManager]
            removeItemAtPath:path
            error:nil];
}

+ (NSArray *)getAllFilesAtFolder:(NSString *)folderPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager contentsOfDirectoryAtPath:folderPath error:nil];
}

+ (NSDictionary *)getAttributesAtPath:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    return [manager attributesOfItemAtPath:path error:nil];
}

+ (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}

+ (NSDate *)fileModificationDateAtPath:(NSString*)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileModificationDate];
    }
    
    return nil;
}

+ (long long)folderSizeAtPath:(NSString *) folderPath{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if(![manager fileExistsAtPath:folderPath]){
        return 0;
    }
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath]
                                          objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    
    while((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        NSArray *pathArray = [self getAllFilesAtFolder:fileAbsolutePath];
        
        if ([pathArray count] == 0) {
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
    }
    
    return folderSize;
}

# pragma mark - FileHandle

+ (NSData *)readDataFromParentPath:(NSString *) parentPath fileName:(NSString *) fileName
{
    NSString *filePath = [self getFilePathWithParentPath:parentPath fileName:fileName];
    
    return [NSData dataWithContentsOfFile:filePath];
}

+ (NSData *)readDataFromPath:(NSString *) filePath
{
    return [NSData dataWithContentsOfFile:filePath];
}

+ (NSArray *)readArrayFromParentPath:(NSString *) parentPath fileName:(NSString *) fileName
{
    NSString *filePath = [self getFilePathWithParentPath:parentPath fileName:fileName];
    
    return [NSArray arrayWithContentsOfFile:filePath];
}

+ (NSArray *)readArrayFromPath:(NSString *) filePath
{
    return [NSArray arrayWithContentsOfFile:filePath];
}

+ (NSDictionary *)readDictionaryFromParentPath:(NSString *) parentPath fileName:(NSString *) fileName
{
    NSString *filePath = [self getFilePathWithParentPath:parentPath fileName:fileName];
    
    return [NSDictionary dictionaryWithContentsOfFile:filePath];
}

+ (NSDictionary *)readDictionaryFromPath:(NSString *) filePath
{
    return [NSDictionary dictionaryWithContentsOfFile:filePath];
}

+ (UIImage *)readUIImageFromParentPath:(NSString *) parentPath fileName:(NSString *) fileName
{
    NSString *filePath = [self getFilePathWithParentPath:parentPath fileName:fileName];
    
    return [UIImage imageWithContentsOfFile:filePath];
}

+ (UIImage *)readUIImageFromPath:(NSString *) filePath
{
    return [UIImage imageWithContentsOfFile:filePath];
}

+ (BOOL)writeData:(NSData *)data toParentPath:(NSString *)parentPath withFileName:(NSString *)fileName
{
    NSString *filePath = [self getFilePathWithParentPath:parentPath fileName:fileName];
    if (![self createFileAtPath:filePath]) {
        return NO;
    }
    return [data writeToFile:filePath atomically:YES];
}

+ (BOOL)writeData:(NSData *)data toPath:(NSString *)filePath
{
    if (![self createFileAtPath:filePath]) {
        return NO;
    }
    return [data writeToFile:filePath atomically:YES];
}

+ (BOOL)writeArray:(NSArray *)array toParentPath:(NSString *)parentPath withFileName:(NSString *)fileName
{
    NSString *filePath = [self getFilePathWithParentPath:parentPath fileName:fileName];
    if (![self createFileAtPath:filePath]) {
        return NO;
    }
    
    return [array writeToFile:filePath atomically:YES];
}

+ (BOOL)writeArray:(NSArray *)array toPath:(NSString *)filePath
{
    if (![self createFileAtPath:filePath]) {
        return NO;
    }
    
    return [array writeToFile:filePath atomically:YES];
}

+ (BOOL)writeDictionary:(NSDictionary *)dictionary toParentPath:(NSString *)parentPath withFileName:(NSString *)fileName
{
    NSString *filePath = [self getFilePathWithParentPath:parentPath fileName:fileName];
    if (![self createFileAtPath:filePath]) {
        return NO;
    }
    
    return [dictionary writeToFile:filePath atomically:YES];
}

+ (BOOL)writeDictionary:(NSDictionary *)dictionary toPath:(NSString *)filePath
{
    if (![self createFileAtPath:filePath]) {
        return NO;
    }
    
    return [dictionary writeToFile:filePath atomically:YES];
}

+ (BOOL)writeUIImage:(UIImage *)image toParentPath:(NSString *)parentPath withFileName:(NSString *)fileName
{
    NSString *filePath = [self getFilePathWithParentPath:parentPath fileName:fileName];
    if (![self createFileAtPath:filePath]) {
        return NO;
    }
    
    return [self writeData:UIImageJPEGRepresentation(image, 1.0) toParentPath:parentPath withFileName:fileName];
}

+ (BOOL)writeUIImage:(UIImage *)image toPath:(NSString *)filePath
{
    if (![self createFileAtPath:filePath]) {
        return NO;
    }
    
    return [self writeData:UIImageJPEGRepresentation(image, 1.0) toPath:filePath];
}

+ (BOOL)writeUIImage:(UIImage *)image toParentPath:(NSString *)parentPath withFileName:(NSString *)fileName compressionQuality:(CGFloat)compQuality
{
    NSString *filePath = [self getFilePathWithParentPath:parentPath fileName:fileName];
    if (![self createFileAtPath:filePath]) {
        return NO;
    }
    
    return [self writeData:UIImageJPEGRepresentation(image, compQuality) toParentPath:parentPath withFileName:fileName];
}

+ (BOOL)writeUIImage:(UIImage *)image toPath:(NSString *)filePath compressionQuality:(CGFloat)compQuality
{
    if (![self createFileAtPath:filePath]) {
        return NO;
    }
    
    return [self writeData:UIImageJPEGRepresentation(image, compQuality) toPath:filePath];
}

@end

