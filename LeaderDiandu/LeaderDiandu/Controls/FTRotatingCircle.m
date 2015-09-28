//
//  FTRotatingCircle.m
//  Fetion
//
//  Created by apple on 14-3-21.
//  Copyright (c) 2014年 chinasofti. All rights reserved.
//

#import "FTRotatingCircle.h"
//#import "API.h"
//#import "NSString+Utils.h"

#define KRotatingImage 10086
#define kAnimationkey @"transform.rotation"
@implementation FTRotatingCircle
//UIImageView * progessImage;

- (id)initWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupImageView:frame imageName:(NSString *)imageName];
        self.frame = frame;

    }
    return self;
}

/**
 self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02f
 target:self
 selector:@selector(startRotateAnimation:)
 userInfo:nil
 repeats:YES];
 [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
 */

- (void)setupImageView:(CGRect)frame  imageName:(NSString *)imageName{
    UIImageView *progessImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,frame.size.width, frame.size.height)];
    progessImage.tag = KRotatingImage;
    progessImage.image = [UIImage imageNamed:imageName];
    [self addAnimation:progessImage];
//    spinAnimation.delegate = self;
//    spinAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/2 , 0, 0, 1.0)];
//    spinAnimation.duration = 0.4;
//    spinAnimation.cumulative = YES;
//    spinAnimation.repeatCount = MAX_CANON;
//    [progessImage.layer addAnimation:spinAnimation forKey:nil];
    

    [self addSubview:progessImage];
}

- (void)setRotatingImageFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView *progessImage = (UIImageView *)[self viewWithTag:KRotatingImage];
    progessImage.image = [UIImage imageNamed:imageName];
    self.frame = frame;
    progessImage.frame = CGRectMake(0, 0,frame.size.width, frame.size.height);
    [self addAnimation:progessImage];
}

- (void)addAnimation:(UIImageView *)imageView
{
//    [imageView.layer removeAllAnimations];//移除所有的动画
    [imageView.layer removeAnimationForKey:kAnimationkey];//移除对应key的动画
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:kAnimationkey];
    spinAnimation.byValue = [NSNumber numberWithFloat:2*M_PI];
    spinAnimation.duration = 0.8;
    spinAnimation.delegate = self;
    spinAnimation.repeatCount = HUGE_VALF;
    spinAnimation.removedOnCompletion = NO;
//    [imageView.layer addAnimation:spinAnimation forKey:generateRandomCnOnce()];//设置成不同的key可以保证每个动画的起始状态不一样
    [imageView.layer addAnimation:spinAnimation forKey:kAnimationkey];//设置成相同的key动画轨迹都一样
}

@end
