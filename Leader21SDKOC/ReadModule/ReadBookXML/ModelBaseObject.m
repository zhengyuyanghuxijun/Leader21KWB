//
//  ModelBaseObject.m
//  magicEnglish
//
//  Created by 振超 王 on 14-4-13.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ModelBaseObject.h"

@implementation IconObject

@end

@implementation HighlightObject

@end


@implementation ModelBaseObject

- (void)beginParseData:(id)parseData
{
    if (parseData == nil) {
        return;
    }
    
    parseData = [parseData objectForKey:@"page"];
    
    self.name = [parseData objectForKey:@"name"];
    self.pages = [parseData objectForKey:@"pages"];
    self.content = [parseData objectForKey:@"content"];
    
    NSArray *iconsArray = [parseData objectForKey:@"iconsArray"];
    if (iconsArray) {
        for (NSDictionary *dic in iconsArray) {
            IconObject *iconObj = [self createIconObjectWithDic:dic];
            [self.iconsArray addObject:iconObj];
        }
    }
    else
    {
        NSDictionary *dic = [parseData objectForKey:@"icon"];
        if (dic) {
            IconObject *iconObj = [self createIconObjectWithDic:dic];
            [self.iconsArray addObject:iconObj];
        }
    }
    
    NSArray *highlightsArray = [parseData objectForKey:@"highlightsArray"];
    if (highlightsArray) {
        for (NSDictionary *dic in highlightsArray) {
            HighlightObject *highlightObj = [self createHighlightsObjectWithDic:dic];
            [self.highlightsArray addObject:highlightObj];
        }
    }
    else
    {
        NSDictionary *dic = [parseData objectForKey:@"highlight"];
        if (dic) {
            HighlightObject *highlightObj = [self createHighlightsObjectWithDic:dic];
            [self.highlightsArray addObject:highlightObj];
        }
    }
}

- (IconObject *)createIconObjectWithDic:(NSDictionary *)dic
{
    IconObject *iconObj = [[IconObject alloc] init];
    
    iconObj.x = [dic objectForKey:@"x"];
    iconObj.scale = [dic objectForKey:@"scale"];
    iconObj.end = [dic objectForKey:@"end"];
    iconObj.y = [dic objectForKey:@"y"];
    iconObj.muted = [dic objectForKey:@"muted"];
    iconObj.content = [dic objectForKey:@"content"];
    iconObj.rotation = [dic objectForKey:@"rotation"];
    iconObj.start = [dic objectForKey:@"start"];
    iconObj.url = [dic objectForKey:@"url"];
    
    return iconObj;
}

- (HighlightObject *)createHighlightsObjectWithDic:(NSDictionary *)dic
{
    HighlightObject *highlightObj = [[HighlightObject alloc] init];
    
    highlightObj.x = [dic objectForKey:@"x"];
    highlightObj.end = [dic objectForKey:@"end"];
    highlightObj.y = [dic objectForKey:@"y"];
    highlightObj.muted = [dic objectForKey:@"muted"];
    highlightObj.content = [dic objectForKey:@"content"];
    highlightObj.rotation = [dic objectForKey:@"rotation"];
    highlightObj.width = [dic objectForKey:@"width"];
    highlightObj.height = [dic objectForKey:@"height"];
    highlightObj.start = [dic objectForKey:@"start"];
    highlightObj.url = [dic objectForKey:@"url"];
    
    return highlightObj;
}

@end
