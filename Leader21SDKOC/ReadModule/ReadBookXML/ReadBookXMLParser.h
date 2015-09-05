//
//  ReadBookXMLParser.h
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-11.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadBookXMLParser : NSObject

+ (id)parseXML:(NSString *)fileName;

@end

@interface ScreenReaderXMLParser : ReadBookXMLParser



@end
