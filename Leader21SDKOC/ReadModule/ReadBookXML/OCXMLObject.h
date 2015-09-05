//
//  OCXMLObject.h
//  magicEnglish
//
//  Created by 振超 王 on 14-4-12.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelBaseObject.h"

@interface OCXMLObject : ModelBaseObject

+ (OCXMLObject *)createScreenOCObject:(id)parseData;
- (id)initWithParseData:(id)parseData;

@end
