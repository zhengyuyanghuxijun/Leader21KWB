//
//  ModelBaseObject.h
//  magicEnglish
//
//  Created by 振超 王 on 14-4-13.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconObject : NSObject

@property (nonatomic, copy) NSString *x;
@property (nonatomic, copy) NSString *scale;
@property (nonatomic, copy) NSString *end;
@property (nonatomic, copy) NSString *y;
@property (nonatomic, copy) NSString *muted;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *rotation;
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *url;

@end

@interface HighlightObject : NSObject

@property (nonatomic, copy) NSString *x;
@property (nonatomic, copy) NSString *end;
@property (nonatomic, copy) NSString *y;
@property (nonatomic, copy) NSString *muted;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *rotation;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *url;

@end

@interface ModelBaseObject : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pages;
@property (nonatomic, retain) NSMutableArray *iconsArray;
@property (nonatomic, retain) NSMutableArray *highlightsArray;
@property (nonatomic, copy) NSString *content;

- (void)beginParseData:(id)parseData;

@end
