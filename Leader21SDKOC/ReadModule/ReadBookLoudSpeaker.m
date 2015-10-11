//
//  ReadBookLoudSpeaker.m
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-15.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookLoudSpeaker.h"

@implementation ReadBookLoudSpeaker

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setView:(UIView *)view iconLocation:(CGPoint)point loudSpeakerTapBlock:(LoudSpeakerTapBlock)loudSpeakerTapBlock
{
    UIImage *btnImage = [UIImage imageNamed:@"sprite_20001"];
    UIButton *louderButton = [[UIButton alloc] init];
    louderButton.frame = CGRectMake(point.x - 10, point.y, btnImage.size.width - 5, btnImage.size.height - 5);
    [louderButton setBackgroundImage:btnImage forState:UIControlStateNormal];
    [louderButton addTarget:self action:@selector(tapHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.loudSpeakerTapBlock = loudSpeakerTapBlock;
    [view addSubview:louderButton];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.2;
    animation.repeatCount = 1;
    animation.autoreverses = YES;
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:1.5];
    [louderButton.layer addAnimation:animation forKey:@"scale-layer"];
}

- (void)tapHandle:(id)sender
{
    if (self.loudSpeakerTapBlock) {
        self.loudSpeakerTapBlock();
    }
}

@end
