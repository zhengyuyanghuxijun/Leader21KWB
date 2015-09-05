//
//  ReadBookResource.h
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-15.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScreenReaderObject.h"
#import "OCXMLObject.h"
#import "PRXMLObject.h"

@interface ReadBookResourceModel : NSObject

@property (nonatomic, copy) NSString *bookIndexName;

- (id)initWithBookIndexName:(NSString *)bookIndexName;

- (NSArray *)screenReaderIndexList;
- (UIImage *)screenReaderImage:(NSString *)imageName;
- (void)screenReaderObject:(NSString *)imageName completionBlock:(void (^)(ScreenReaderObject *obj))completionBlock;
- (NSData *)screenReaderVoiceData:(NSString *)imageName flowObject:(FlowObject *)flowObject;
- (BOOL)isPageOCModelEnable:(NSString *)imageName;
- (BOOL)isPagePRModelEnable:(NSString *)imageName;

- (void)screenReaderOCObject:(NSString *)imageName completionBlock:(void (^)(OCXMLObject *obj))completionBlock;
- (void)screenReaderPRObject:(NSString *)imageName completionBlock:(void (^)(PRXMLObject  *obj))completionBlock;
@end
