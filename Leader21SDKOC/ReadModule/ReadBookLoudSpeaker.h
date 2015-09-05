//
//  ReadBookLoudSpeaker.h
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-15.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LoudSpeakerTapBlock)();

@interface ReadBookLoudSpeaker : NSObject

@property (nonatomic, copy) LoudSpeakerTapBlock loudSpeakerTapBlock;

- (void)setView:(UIView *)view iconLocation:(CGPoint)point loudSpeakerTapBlock:(LoudSpeakerTapBlock)loudSpeakerTapBlock;

@end
