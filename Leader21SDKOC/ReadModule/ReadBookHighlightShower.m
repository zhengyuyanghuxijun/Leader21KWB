//
//  ReadBookHighlightShower.m
//  magicEnglish
//
//  Created by 振超 王 on 14-4-7.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookHighlightShower.h"
#import "ReadBookLocationConverter.h"

@interface ReadBookHighlightShower()

@property (nonatomic, strong) NSMutableArray *highlightViewArray;
@property (nonatomic, assign) NSInteger curIdx;
@property (nonatomic, assign) BlockObject * curBlkObj;
@end

@implementation ReadBookHighlightShower

DEF_SINGLETON(ReadBookHighlightShower);

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.highlightViewArray = [[NSMutableArray alloc] init];
        self.curIdx = -1;
        self.curBlkObj = nil;
    }
    
    return self;
}

- (void)setView:(UIView *)view blockObject:(BlockObject *)blockObj
{
    for (WordsObject *wordsObj in blockObj.wordsArray) {
        CGPoint locPoint = [ReadBookLocationConverter locationConverterPoint:CGPointMake(wordsObj.xMin, wordsObj.yMin) targetView:view];
        
        CGSize targetSize = [ReadBookLocationConverter normalSizeConvert:CGSizeMake(wordsObj.xMax - wordsObj.xMin, wordsObj.yMax - wordsObj.yMin) targetView:view];
        
        UIView *highlightView = [[UIView alloc] init];
        highlightView.backgroundColor = [UIColor yellowColor];
        highlightView.alpha = 0.5f;
        highlightView.userInteractionEnabled = NO;
        highlightView.frame = CGRectMake(locPoint.x, locPoint.y, targetSize.width, targetSize.height);
        [view addSubview:highlightView];
        [self.highlightViewArray addObject:highlightView];
    }
}

- (void)setView:(UIView *)view flowObject:(FlowObject *)flowObject currentPlayTime:(NSTimeInterval)currentTime
{
    NSTimeInterval converTime = currentTime * 1000;
    for (NSInteger idx = 0; idx < [[flowObject clip] blocksArray].count; idx++) {
        BlockObject *blockObj = [flowObject.clip.blocksArray objectAtIndex:idx];
        WordsObject *firstWordsObj = [blockObj.wordsArray firstObject];
        WordsObject *lastWordsObj = [blockObj.wordsArray lastObject];
        
        if (converTime >= firstWordsObj.start && converTime <= lastWordsObj.end)
        {
            
            if (self.curIdx == idx && self.curBlkObj == blockObj) {
                return;
            }
            else
            {
                if ([self highlightViewArray].count > 0) {
                    for (UIView *v in self.highlightViewArray) {
                        [v removeFromSuperview];
                    }
                    [self.highlightViewArray removeAllObjects];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_clearPageHightLight object:self];

                }
                self.curIdx = idx;
                self.curBlkObj = blockObj;
            }
            
            for (WordsObject *wordsObj in blockObj.wordsArray) {
                CGPoint locPoint = [ReadBookLocationConverter locationConverterPoint:CGPointMake(wordsObj.xMin, wordsObj.yMin) targetView:view];
                
                CGSize targetSize = [ReadBookLocationConverter normalSizeConvert:CGSizeMake(wordsObj.xMax - wordsObj.xMin, wordsObj.yMax - wordsObj.yMin) targetView:view];
                
                UIView *highlightView = [[UIView alloc] init];
                highlightView.backgroundColor = [UIColor yellowColor];
                highlightView.alpha = 0.5f;
                highlightView.userInteractionEnabled = NO;
                highlightView.frame = CGRectMake(locPoint.x, locPoint.y, targetSize.width, targetSize.height);
                [view addSubview:highlightView];
                [self.highlightViewArray addObject:highlightView];

            }
            
        }
    }
}

- (void)cleanHighlightView
{
    if ([self highlightViewArray].count > 0) {
        for (UIView *v in self.highlightViewArray) {
            [v removeFromSuperview];
        }
        [self.highlightViewArray removeAllObjects];
        
    }
}
@end
