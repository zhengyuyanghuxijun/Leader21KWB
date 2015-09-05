//
//  ReadBookResourceFactory.m
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-15.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookResourceFactory.h"
#import "ReadBookResourceFileHelper.h"

typedef ReadBookResourceFileHelper RBHelper;

@implementation ReadBookResourceFactory

+ (NSArray *)screenReaderIndexList:(NSString *)bookIndexName
{
//    NSString *bookFolderPath = [NSString stringWithFormat:@"%@/%@",[RBHelper userDocumentPath],bookIndexName];
//    NSString *idxListFilePath = [NSString stringWithFormat:@"%@/%@_pagelist.txt",bookFolderPath,bookIndexName];
    NSString *indexName = [[bookIndexName componentsSeparatedByString:@"/"] lastObject];
    NSString *idxListFilePath = [NSString stringWithFormat:@"%@/%@_pagelist.txt",bookIndexName,indexName];
    NSString *idxListContent = [RBHelper readFile:idxListFilePath];
    //文件名里面有/r的全去掉
    idxListContent = [idxListContent stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    imageName = [imageName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (idxListContent) {
        NSArray *idxList = [idxListContent componentsSeparatedByString:@"\n"];
        return idxList;
    }
    else
    {
        return nil;
    }
}

+ (UIImage *)screenReaderImage:(NSString *)bookIndexName imageName:(NSString *)imageName
{
    NSString *imagePath = nil;
    NSString *indexName = [[bookIndexName componentsSeparatedByString:@"/"] lastObject];
    if (imageName && [imageName isEqualToString:@"blank"])
    {
        imagePath = [NSString stringWithFormat:@"%@/%@/%@/%@%@",bookIndexName,@"img",indexName,indexName,@"_0000"];
    }
    else
    {
        imagePath = [NSString stringWithFormat:@"%@/%@/%@/%@",bookIndexName,@"img",indexName,imageName];
    }
    
    NSString *rImagePath = nil;
    rImagePath = [NSString stringWithFormat:@"%@.jpg",imagePath];
    if (![RBHelper isExistFile:rImagePath]) {
        rImagePath = [NSString stringWithFormat:@"%@.png",imagePath];
    }
    
    UIImage *screenImage = [UIImage imageWithContentsOfFile:rImagePath];
    return screenImage;
}

+ (NSData *)screenReaderObjectXMLData:(NSString *)bookIndexName imageName:(NSString *)imageName
{
    NSString *indexName = [[bookIndexName componentsSeparatedByString:@"/"] lastObject];
    NSString *xmlPath = [NSString stringWithFormat:@"%@/%@/%@/%@/%@.xml",bookIndexName,@"screen_reader",indexName,@"xml",imageName];
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath];
    return xmlData;
}

+ (NSData *)screenReaderPRObjectXMLData:(NSString *)bookIndexName imageName:(NSString *)imageName
{
    NSString *indexName = [[bookIndexName componentsSeparatedByString:@"/"] lastObject];
    NSString *xmlPath = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@",bookIndexName,@"tplayer",indexName,@"xml",@"pr",imageName];
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath];
    return xmlData;
}

+ (NSData *)screenReaderOCObjectXMLData:(NSString *)bookIndexName imageName:(NSString *)imageName
{
    NSString *indexName = [[bookIndexName componentsSeparatedByString:@"/"] lastObject];
    NSString *xmlPath = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@",bookIndexName,@"tplayer",indexName,@"xml",@"oc",imageName];
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath];
    return xmlData;
}

+ (NSData *)screenReaderObjectVoiceData:(NSString *)bookIndexName
                              imageName:(NSString *)imageName
                                clipSrc:(NSString *)clipSrc
{
    NSString *indexName = [[bookIndexName componentsSeparatedByString:@"/"] lastObject];
    NSString *voicePath = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",bookIndexName,@"screen_reader",indexName,@"audio",clipSrc];
    NSData *xmlData = [NSData dataWithContentsOfFile:voicePath];
    return xmlData;
}

+ (NSArray *)allPlayListFilesInOCModel:(NSString *)bookIndexName
{
    NSString *indexName = [[bookIndexName componentsSeparatedByString:@"/"] lastObject];
    NSString *OCPath = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/",bookIndexName,@"tplayer",indexName,@"xml",@"oc"];
    NSArray *OCAllFiles = [RBHelper filesInDoc:OCPath];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF like %@)", @"playlist*"];
    NSArray *retArr = [OCAllFiles filteredArrayUsingPredicate:predicate];
    return retArr;
}

+ (NSArray *)allPlayListFilesInPRModel:(NSString *)bookIndexName
{
    NSString *indexName = [[bookIndexName componentsSeparatedByString:@"/"] lastObject];
    NSString *PRPath = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/",bookIndexName,@"tplayer",indexName,@"xml",@"pr"];
    NSArray *PRAllFiles = [RBHelper filesInDoc:PRPath];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF like %@)", @"playlist*"];
    NSArray *retArr = [PRAllFiles filteredArrayUsingPredicate:predicate];
    return retArr;
}

+ (NSData *)screenReaderOCVoiceData:(NSString *)bookIndexName
                       resourceName:(NSString *)resourceName
{
    NSString *indexName = [[bookIndexName componentsSeparatedByString:@"/"] lastObject];
    NSString *voicePath = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@.mp3",bookIndexName,@"tplayer",indexName,@"audio",@"oc",resourceName];
    NSData *voiceData = [NSData dataWithContentsOfFile:voicePath];
    return voiceData;
}

+ (NSData *)screenReaderPRVoiceData:(NSString *)bookIndexName
                       resourceName:(NSString *)resourceName
{
    NSString *indexName = [[bookIndexName componentsSeparatedByString:@"/"] lastObject];
    NSString *voicePath = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@.mp3",bookIndexName,@"tplayer",indexName,@"audio",@"pr",resourceName];
    NSData *voiceData = [NSData dataWithContentsOfFile:voicePath];
    return voiceData;
}
@end


