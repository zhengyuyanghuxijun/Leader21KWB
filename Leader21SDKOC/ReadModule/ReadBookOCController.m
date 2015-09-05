//
//  ReadBookOCAnimationHelper.m
//  magicEnglish
//
//  Created by 振超 王 on 14-4-12.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookOCController.h"
#import "ReadBookResourceFactory.h"
#import "ReadBookPlayer.h"
#import "ReadBookLocationConverter.h"

@implementation ReadBookOCController

- (void)setOCObj:(OCXMLObject *)ocXMLObj indexName:(NSString *)indexName contentViewVC:(ReadBookContentViewController *)contentViewVC
{
    [super setModelBaseObj:ocXMLObj indexName:indexName contentViewVC:contentViewVC];
}

- (NSData *)prepareVoiceData:(NSString *)xmlObjName indexName:(NSString *)indexName
{
    return [ReadBookResourceFactory screenReaderOCVoiceData:indexName resourceName:xmlObjName];
}

- (void)voicePlayFinish
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OCModelFinish" object:nil];
}

@end
