//
//  ReadBookWordSpeaker.h
//  magicEnglish
//
//  Created by 振超 王 on 14-4-2.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScreenReaderObject.h"

typedef void (^WordSpeakerTapBlock)(float startTime,float endTime,BlockObject *blockObject);

@interface ReadBookWordSpeaker : NSObject

@property (nonatomic, copy) WordSpeakerTapBlock wordSpeakerTapBlock;

- (void)setView:(UIView *)view blocksArr:(NSArray *)blocksArr wordSpeakerTapBlock:(WordSpeakerTapBlock)wordSpeakerTapBlock;

@end
