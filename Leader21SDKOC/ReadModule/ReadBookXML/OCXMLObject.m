//
//  OCXMLObject.m
//  magicEnglish
//
//  Created by 振超 王 on 14-4-12.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "OCXMLObject.h"

@implementation OCXMLObject

+ (OCXMLObject *)createScreenOCObject:(id)parseData
{
    OCXMLObject *ocxmlObject = [[OCXMLObject alloc] initWithParseData:parseData];
    return ocxmlObject;
}

- (id)initWithParseData:(id)parseData
{
    self = [super init];
    if (self) {
        self.iconsArray = [[NSMutableArray alloc] init];
        self.highlightsArray = [[NSMutableArray alloc] init];
        [self beginParseData:parseData];
    }
    return self;
}

@end
