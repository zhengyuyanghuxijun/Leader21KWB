//
//  ScreenReaderObject.m
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-11.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ScreenReaderObject.h"

@implementation FlowObject


@end

@implementation ClipObject

- (id)init
{
    self = [super init];
    if (self) {
        self.blocksArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

@implementation WordsObject

@end

@implementation BlockObject

- (id)init
{
    self = [super init];
    if (self) {
        self.wordsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

@implementation ScreenReaderObject

+ (ScreenReaderObject *)createScreenReaderObject:(id)parseData
{
    ScreenReaderObject *readerObject = [[ScreenReaderObject alloc] initWithParseData:parseData];
    return readerObject;
}

- (id)initWithParseData:(id)parseData
{
    self = [super init];
    if (self) {
        self.flowArray = [[NSMutableArray alloc] init];
        [self parseDataFunc:parseData];
    }
    return self;
}

- (void)parseDataFunc:(id)parseData
{
    NSDictionary *pageDic = [parseData objectForKey:@"page"];
    
    NSArray *flowsArray = [pageDic objectForKey:@"flowsArray"];
    if (flowsArray) {
        for (NSDictionary *flow in flowsArray) {
            [self flowParse:flow];
        }
    }
    else
    {
        NSDictionary *flowDic = [pageDic objectForKey:@"flow"];
        [self flowParse:flowDic];
    }
}

- (void)flowParse:(NSDictionary *)flowDic
{
    FlowObject *flowObject = [[FlowObject alloc] init];
    flowObject.iconxy = [flowDic objectForKey:@"iconxy"];
    flowObject.label = [flowDic objectForKey:@"label"];
    
    NSDictionary *clipDic = [flowDic objectForKey:@"clip"];
    
    ClipObject *clipObject = [[ClipObject alloc] init];
    clipObject.src = [clipDic objectForKey:@"src"];
    
    NSArray *blocksArr = [clipDic objectForKey:@"blocksArray"];
    
    if (blocksArr == nil) {
        blocksArr = [NSArray arrayWithObjects:[clipDic objectForKey:@"block"], nil];
    }
    
    for (NSDictionary *dic in blocksArr) {
        if ([dic count] > 0) {
            BlockObject *blockObject = [[BlockObject alloc] init];
            NSArray *wordsArr = [dic objectForKey:@"wordsArray"];
            
            if (wordsArr == nil) {
                wordsArr = [NSArray arrayWithObjects:[dic objectForKey:@"word"], nil];
            }
            
            for (NSDictionary *wDic in wordsArr) {
                if ([wDic count] > 0) {
                    WordsObject *wordsObject = [[WordsObject alloc] init];
                    wordsObject.content = [wDic objectForKey:@"content"];
                    wordsObject.start = ((NSString *)[wDic objectForKey:@"start"]).doubleValue;
                    wordsObject.end  = ((NSString *)[wDic objectForKey:@"end"]).doubleValue;
                    wordsObject.xMax = ((NSString *)[wDic objectForKey:@"xMax"]).doubleValue;
                    wordsObject.xMin = ((NSString *)[wDic objectForKey:@"xMin"]).doubleValue;
                    wordsObject.yMax = ((NSString *)[wDic objectForKey:@"yMax"]).doubleValue;
                    wordsObject.yMin = ((NSString *)[wDic objectForKey:@"yMin"]).doubleValue;
                    [blockObject.wordsArray addObject:wordsObject];
                }
            }
            
            [clipObject.blocksArray addObject:blockObject];
        }
    }
    
    flowObject.clip = clipObject;
    
    [self.flowArray addObject:flowObject];
}
@end
