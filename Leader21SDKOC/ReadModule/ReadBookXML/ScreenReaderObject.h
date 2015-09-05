//
//  ScreenReaderObject.h
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-11.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ClipObject : NSObject

@property (nonatomic, copy) NSString *src;
@property (nonatomic, strong) NSMutableArray *blocksArray;

@end

@interface FlowObject : NSObject

@property (nonatomic, copy) NSString *iconxy;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, strong) ClipObject *clip;

@end

@interface BlockObject : NSObject

@property (nonatomic, strong) NSMutableArray *wordsArray;

@end

@interface WordsObject : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) CGFloat end;
@property (nonatomic, assign) CGFloat start;
@property (nonatomic, assign) CGFloat xMax;
@property (nonatomic, assign) CGFloat xMin;
@property (nonatomic, assign) CGFloat yMax;
@property (nonatomic, assign) CGFloat yMin;

@end

@interface ScreenReaderObject : NSObject

@property (nonatomic, strong) NSMutableArray *flowArray;

+ (ScreenReaderObject *)createScreenReaderObject:(id)parseData;
- (id)initWithParseData:(id)parseData;

@end
