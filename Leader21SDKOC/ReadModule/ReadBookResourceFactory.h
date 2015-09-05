//
//  ReadBookResourceFactory.h
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-15.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadBookResourceFactory : NSObject

+ (NSArray *)screenReaderIndexList:(NSString *)bookIndexName;
+ (UIImage *)screenReaderImage:(NSString *)bookIndexName imageName:(NSString *)imageName;

+ (NSData *)screenReaderObjectXMLData:(NSString *)bookIndexName imageName:(NSString *)imageName;
+ (NSData *)screenReaderObjectVoiceData:(NSString *)bookIndexName
                              imageName:(NSString *)imageName
                                clipSrc:(NSString *)clipSrc;

+ (NSData *)screenReaderPRObjectXMLData:(NSString *)bookIndexName imageName:(NSString *)imageName;
+ (NSData *)screenReaderOCObjectXMLData:(NSString *)bookIndexName imageName:(NSString *)imageName;
+ (NSArray *)allPlayListFilesInOCModel:(NSString *)bookIndexName;
+ (NSArray *)allPlayListFilesInPRModel:(NSString *)bookIndexName;
+ (NSData *)screenReaderOCVoiceData:(NSString *)bookIndexName
                       resourceName:(NSString *)resourceName;
+ (NSData *)screenReaderPRVoiceData:(NSString *)bookIndexName
                       resourceName:(NSString *)resourceName;
@end


