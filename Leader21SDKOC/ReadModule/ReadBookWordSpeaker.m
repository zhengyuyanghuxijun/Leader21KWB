//
//  ReadBookWordSpeaker.m
//  magicEnglish
//
//  Created by 振超 王 on 14-4-2.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookWordSpeaker.h"
#import "ReadBookLocationConverter.h"

@interface WordButton : UIButton

@property (nonatomic, strong) WordsObject *wordsObject;
@property (nonatomic, strong) BlockObject *blockObject;

@end

@implementation WordButton

@end

@implementation ReadBookWordSpeaker

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setView:(UIView *)view blocksArr:(NSArray *)blocksArr wordSpeakerTapBlock:(WordSpeakerTapBlock)wordSpeakerTapBlock
{
    for (BlockObject *blockObj in blocksArr) {
        for (WordsObject *wordsObject in blockObj.wordsArray) {
            WordButton *wordButton = [[WordButton alloc] init];
            CGPoint locPoint = [ReadBookLocationConverter locationConverterPoint:CGPointMake(wordsObject.xMin, wordsObject.yMin) targetView:view];
            wordButton.frame = CGRectMake(locPoint.x, locPoint.y, wordsObject.xMax - wordsObject.xMin, wordsObject.yMax - wordsObject.yMin);
            wordButton.wordsObject = wordsObject;
            wordButton.blockObject = blockObj;
            self.wordSpeakerTapBlock = wordSpeakerTapBlock;
            [wordButton addTarget:self action:@selector(tapHandle:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:wordButton];
        }
    }
}

- (void)tapHandle:(id)sender
{
    WordButton *wordButton = (WordButton *)sender;
    if (self.wordSpeakerTapBlock) {
        self.wordSpeakerTapBlock(wordButton.wordsObject.start,wordButton.wordsObject.end,wordButton.blockObject);
    }
}
@end
