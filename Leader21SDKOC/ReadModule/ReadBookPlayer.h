//
//  ReadBookPlayer.h
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-15.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScreenReaderObject.h"

typedef void (^ReadBookVoicePlayingBlock)(FlowObject *flowObject ,NSTimeInterval currentTime, BOOL isListFinish, UIImageView *contentImageView);
typedef void (^ReadBookPlayingTimeBlock)(NSTimeInterval currentTime, BOOL isPlayFinish);

@interface ReadBookPlayer : NSObject

DEC_SINGLETON(ReadBookPlayer);

@property (nonatomic, copy) ReadBookVoicePlayingBlock voicePlayingBlock;
@property (nonatomic, copy) ReadBookPlayingTimeBlock timeUpdateBlock;

- (void)addVoiceDataInList:(NSData *)voiceData
                flowObject:(FlowObject *)flowObject
                  voiceTag:(NSInteger)tag
          contentImageView:(UIImageView *)contentImageView;
- (void)playVoiceDataInList;
- (void)playVoiceDataInList:(NSTimeInterval)startTime;
- (void)playReadBookVoice:(NSData *)voiceData;
- (void)playReadBookVoice:(NSData *)voiceData atTime:(NSTimeInterval)startTime;
- (void)stopRead;

@end
