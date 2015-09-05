//
//  ReadBookXMLParser.m
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-11.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookXMLParser.h"
#import "XMLParser.h"
#import "ScreenReaderObject.h"
#import "ReadBookResourceFileHelper.h"

@implementation ReadBookXMLParser

+ (id)parseXML:(NSString *)fileName
{
    id ret;
    return ret;
}

@end

@implementation ScreenReaderXMLParser

+ (id)parseXML:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:path];
    
    XMLParser *xmlParser = [[XMLParser alloc] init];
	
    __block ScreenReaderObject *obj = nil;
    
	[xmlParser parseData:xmlData
				 success:^(id parsedData) {
                     obj = [ScreenReaderObject createScreenReaderObject:parsedData];
				 }
				 failure:^(NSError *error) {
                     
				 }];
    return obj;
}

@end
