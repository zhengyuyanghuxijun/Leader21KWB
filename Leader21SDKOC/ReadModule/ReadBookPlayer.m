//
//  ReadBookPlayer.m
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-15.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookPlayer.h"
#import <AVFoundation/AVFoundation.h>

typedef void (^AudioPlayerFinishBlock)(BOOL successflag);

@interface AudioPlayer : AVAudioPlayer<AVAudioPlayerDelegate>

@property (nonatomic, copy) AudioPlayerFinishBlock audioPlayerFinishBlock;

@end

@implementation AudioPlayer

- (instancetype)initWithData:(NSData *)data error:(NSError *__autoreleasing *)outError
{
    self = [super initWithData:data error:outError];
    if (self) {
        [self setDelegate:self];
    }
    return self;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self.audioPlayerFinishBlock) {
        self.audioPlayerFinishBlock(flag);
    }
}

@end

@interface VoiceObject : NSObject

@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) FlowObject *flowObject;
@property (nonatomic, strong) UIImageView *contentImageView;

@end

@implementation VoiceObject

@end


@interface ReadBookPlayer()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AudioPlayer *audioPlayer;
@property (nonatomic, strong) NSMutableArray *voiceDataList;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic, strong) VoiceObject *curVoiceObject;
@property (nonatomic, assign) NSInteger delayToPlay;

@end

@implementation ReadBookPlayer

DEF_SINGLETON(ReadBookPlayer);

- (id)init
{
    self = [super init];
    if (self) {
        self.voiceDataList = [[NSMutableArray alloc] init];
        self.delayToPlay = 0;
    }
    return self;
}

- (void)addVoiceDataInList:(NSData *)voiceData
                flowObject:(FlowObject *)flowObject
                  voiceTag:(NSInteger)tag
          contentImageView:(UIImageView *)contentImageView
{
    VoiceObject *lastVoiceObj = [self.voiceDataList lastObject];
    if (lastVoiceObj && lastVoiceObj.tag != tag) {
        [self.audioPlayer stop];
        [self.voiceDataList removeAllObjects];
    }
    
    VoiceObject *voiceObj = [[VoiceObject alloc] init];
    voiceObj.tag = tag;
    voiceObj.data = voiceData;
    voiceObj.flowObject = flowObject;
    voiceObj.contentImageView = contentImageView;
    [self.voiceDataList addObject:voiceObj];
}

- (void)playVoiceDataInList
{
    [self playVoiceDataInList:0];
}

- (void)playVoiceDataInList:(NSTimeInterval)startTime
{
    if (self.audioPlayer.isPlaying) {
        return;
    }
    
    self.delayToPlay = startTime;
    
    __weak ReadBookPlayer *wSelf = self;
    
    VoiceObject *voiceObj = [self.voiceDataList firstObject];
    if (voiceObj) {
        self.curVoiceObject = voiceObj;
        NSError *error = nil;
        self.audioPlayer = [[AudioPlayer alloc] initWithData:voiceObj.data error:&error];
        self.audioPlayer.currentTime = self.delayToPlay;
        [self.audioPlayer setAudioPlayerFinishBlock:^(BOOL Successflag){
            wSelf.delayToPlay = 0;
            [wSelf.voiceDataList removeObject:voiceObj];
            [wSelf playVoiceDataInList];
        }];
        
        if (self.updateTimer) {
            [self.updateTimer invalidate];
            self.updateTimer = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_clearPageHightLight object:self];
        }
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                            target:self
                                                          selector:@selector(progressUpdate:)
                                                          userInfo:nil
                                                           repeats:YES];
        if (!error) {
            [self.audioPlayer play];
        }
        else
        {
            NSLog(@"AVAudioPlayer ERROR is %@",error);
        }
    }
    else
    {
        if (self.updateTimer) {
            [self.updateTimer invalidate];
            self.updateTimer = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_clearPageHightLight object:self];

        }
        if (self.curVoiceObject) {
            self.curVoiceObject = nil;
        }
        if (self.voicePlayingBlock) {
            self.voicePlayingBlock(self.curVoiceObject.flowObject ,self.audioPlayer.currentTime ,YES, self.curVoiceObject.contentImageView);
        }
    }
}

- (void)playReadBookVoice:(NSData *)voiceData
{
    [self playReadBookVoice:voiceData atTime:0];
}

- (void)playReadBookVoice:(NSData *)voiceData atTime:(NSTimeInterval)startTime
{
    NSLog(@"voice play");
    NSError *error = nil;
    ReadBookPlayer *wSelf = self;
    self.delayToPlay = startTime;
    self.audioPlayer = [[AudioPlayer alloc] initWithData:voiceData error:&error];
    self.audioPlayer.currentTime = self.delayToPlay;
    [self.audioPlayer setAudioPlayerFinishBlock:^(BOOL successflag){
        if (successflag) {
            if (wSelf.timeUpdateBlock) {
                wSelf.timeUpdateBlock(wSelf.audioPlayer.currentTime, YES);
            }
        }
    }];
    if (!error) {
        [self.audioPlayer play];
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                            target:self
                                                          selector:@selector(progressUpdate:)
                                                          userInfo:nil
                                                           repeats:YES];
    }
    else
    {
        NSLog(@"AVAudioPlayer ERROR is %@",error);
    }
}

- (void)stopRead
{
    if (self.updateTimer) {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_clearPageHightLight object:self];
    }
    _voicePlayingBlock = nil;
    _timeUpdateBlock = nil;

    
    if ([self.voiceDataList count] > 0) {
        [self.voiceDataList removeAllObjects];
    }
    
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer stop];
    }
}

- (void)setTimeUpdateBlock:(ReadBookPlayingTimeBlock)timeUpdateBlock
{
    if (_timeUpdateBlock != timeUpdateBlock) {
        _timeUpdateBlock = [timeUpdateBlock copy];
    }
    _voicePlayingBlock = nil;
}

- (void)setVoicePlayingBlock:(ReadBookVoicePlayingBlock)voicePlayingBlock
{
    if (_voicePlayingBlock != voicePlayingBlock) {
        _voicePlayingBlock = voicePlayingBlock;
    }
    _timeUpdateBlock = nil;
}

- (void)progressUpdate:(id)sender
{
    if (self.voicePlayingBlock) {
        self.voicePlayingBlock(self.curVoiceObject.flowObject ,self.audioPlayer.currentTime ,NO , self.curVoiceObject.contentImageView);
    }
    if (self.timeUpdateBlock) {
        self.timeUpdateBlock(self.audioPlayer.currentTime, NO);
    }
}

@end
