//
//  ReadBookResource.m
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-15.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookResourceModel.h"
#import "ReadBookResourceFactory.h"
#import "ScreenReaderObject.h"
#import "XMLParser.h"
#import "ReadBookDecrypt.h"

@implementation ReadBookResourceModel

- (id)initWithBookIndexName:(NSString *)bookIndexName
{
    self = [super init];
    if (self) {
        self.bookIndexName = bookIndexName;
    }
    return self;
}

- (NSArray *)screenReaderIndexList
{
    return [ReadBookResourceFactory screenReaderIndexList:self.bookIndexName];
}

- (UIImage *)screenReaderImage:(NSString *)imageName
{
    return [ReadBookResourceFactory screenReaderImage:self.bookIndexName imageName:imageName];
}

- (void)screenReaderObject:(NSString *)imageName completionBlock:(void (^)(ScreenReaderObject *obj))completionBlock
{
    NSData *xmlData = [ReadBookResourceFactory screenReaderObjectXMLData:self.bookIndexName imageName:imageName];
    
    if (xmlData == nil) {
        completionBlock(nil);
    }
    else
    {
        XMLParser *xmlParser = [[XMLParser alloc] init];
        
        __block ScreenReaderObject *obj = nil;
        
        [xmlParser parseData:xmlData
                     success:^(id parsedData) {
                         obj = [ScreenReaderObject createScreenReaderObject:parsedData];
                         completionBlock(obj);
                     }
                     failure:^(NSError *error) {
                         completionBlock(nil);
                     }];
    }
}

- (void)screenReaderPRObject:(NSString *)imageName completionBlock:(void (^)(PRXMLObject *obj))completionBlock
{
    NSArray *PRFileArray = [ReadBookResourceFactory allPlayListFilesInPRModel:self.bookIndexName];
    NSString *fileName = nil;
    for (NSString *prFileName in PRFileArray) {
        if ([prFileName rangeOfString:imageName].location != NSNotFound) {
            fileName = [prFileName copy];
            break;
        }
    }
    
    if (fileName == nil) {
        completionBlock(nil);
        return;
    }

    
    NSData *xmlData = [ReadBookResourceFactory screenReaderPRObjectXMLData:self.bookIndexName imageName:fileName];
    if (xmlData == nil) {
        completionBlock(nil);
    }
    else
    {
        XMLParser *xmlParser = [[XMLParser alloc] init];
        
        __block PRXMLObject *obj = nil;
        
        [xmlParser parseData:xmlData
                     success:^(id parsedData) {
                         obj = [PRXMLObject createScreenPRObject:parsedData];
                         completionBlock(obj);
                     }
                     failure:^(NSError *error) {
                         completionBlock(nil);
                     }];
    }
}

- (void)screenReaderOCObject:(NSString *)imageName completionBlock:(void (^)(OCXMLObject *obj))completionBlock
{
    NSArray *OCFileArray = [ReadBookResourceFactory allPlayListFilesInOCModel:self.bookIndexName];
    NSString *fileName = nil;
    for (NSString *ocFileName in OCFileArray) {
        if ([ocFileName rangeOfString:imageName].location != NSNotFound) {
            fileName = [ocFileName copy];
            break;
        }
    }
    
    if (fileName == nil) {
        completionBlock(nil);
        return;
    }
    
    NSData *xmlData = [ReadBookResourceFactory screenReaderOCObjectXMLData:self.bookIndexName imageName:fileName];
    if (xmlData == nil) {
        completionBlock(nil);
    }
    else
    {
        XMLParser *xmlParser = [[XMLParser alloc] init];
        
        __block OCXMLObject *obj = nil;
        
        [xmlParser parseData:xmlData
                     success:^(id parsedData) {
                         obj = [OCXMLObject createScreenOCObject:parsedData];
                         completionBlock(obj);
                     }
                     failure:^(NSError *error) {
                         completionBlock(nil);
                     }];
    }
}

- (NSData *)screenReaderVoiceData:(NSString *)imageName flowObject:(FlowObject *)flowObject
{
    return  [ReadBookResourceFactory screenReaderObjectVoiceData:self.bookIndexName
                                                       imageName:imageName
                                                         clipSrc:flowObject.clip.src];
}

- (BOOL)isPageOCModelEnable:(NSString *)imageName
{
    NSArray *OCFileArray = [ReadBookResourceFactory allPlayListFilesInOCModel:self.bookIndexName];
    BOOL isEnable = NO;
    for (NSString *ocFileName in OCFileArray) {
        if ([ocFileName rangeOfString:imageName].location != NSNotFound) {
            isEnable = YES;
            break;
        }
    }
    return isEnable;
}

- (BOOL)isPagePRModelEnable:(NSString *)imageName
{
    NSArray *PRFileArray = [ReadBookResourceFactory allPlayListFilesInPRModel:self.bookIndexName];
    BOOL isEnable = NO;
    for (NSString *prFileName in PRFileArray) {
        if ([prFileName rangeOfString:imageName].location != NSNotFound) {
            isEnable = YES;
            break;
        }
    }
    return isEnable;
}
@end
