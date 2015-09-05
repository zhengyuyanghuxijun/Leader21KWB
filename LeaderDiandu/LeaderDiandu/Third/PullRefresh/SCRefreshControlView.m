//
//  SCRefreshControlView.m
//  SCRefreshControlView
//
//  Created by Singro on 12/29/13.
//  Copyright (c) 2013 Singro. All rights reserved.
//

#import "SCRefreshControlView.h"

static NSString* const kRotationAnimation = @"RotationAnimation";

@interface SCRefreshControlView ()

@property (nonatomic, strong) CALayer *standbyLayer;
@property (nonatomic, strong) CALayer *animationLayer;

@property (nonatomic, strong) NSMutableArray *standbyLayersArray;
@property (nonatomic, strong) NSMutableArray *animationLayersArray;

@property (nonatomic, assign) BOOL isRotating;

@end

@implementation SCRefreshControlView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.animationLayersArray = [[NSMutableArray alloc] init];
        self.standbyLayersArray = [[NSMutableArray alloc] init];
        
        self.isRotating = NO;
        
        self.standbyLayer = [[CALayer alloc] init];
        self.standbyLayer.frame = (CGRect){0, 0, 1, 3};
        self.standbyLayer.anchorPoint = (CGPoint){0, 0.0};
        [self.layer addSublayer:self.standbyLayer];
        
        self.animationLayer = [[CALayer alloc] init];
        self.animationLayer.frame = (CGRect){0, 0, 1, 3};
        self.animationLayer.anchorPoint = (CGPoint){0, 0.0};
        [self.layer addSublayer:self.animationLayer];

        self.tintColor = [UIColor orangeColor];
        
        [self createAnimationLayers];
        [self createStandbyLayers];
        
        self.animationLayer.hidden = YES;
    
    }
    return self;
}

#pragma mark - Public methods

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    
    for (CALayer *layer in self.standbyLayersArray) {
        layer.backgroundColor = tintColor.CGColor;
    }
    
    for (CALayer *layer in self.animationLayersArray) {
        layer.backgroundColor = tintColor.CGColor;
    }
    
}

- (void)setTimeOffset:(CGFloat)timeOffset {
    
    _timeOffset = timeOffset;
    
    if (self.isRotating) {
        return;
    }
    
    CGFloat showingOffset = timeOffset * 12.0-1;
    
    for (int i = 0; i < 12; i ++) {
        
        CALayer *layer = self.standbyLayersArray[i];
        
        if (i < showingOffset) {
            layer.hidden = NO;
        } else {
            layer.hidden = YES;
        }
        
    }
    
}

- (void)beginRefreshing {
    
    self.isRotating = YES;
    [self.standbyLayer addAnimation:[self createRotationAnimation] forKey:kRotationAnimation];
    
}

- (void)endRefreshing {
    
    [UIView animateWithDuration:0.01 animations:^{
        self.animationLayer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1);
        self.animationLayer.opacity = 0.8f;
    } completion:^(BOOL finished) {
        self.animationLayer.transform = CATransform3DIdentity;
        self.animationLayer.opacity = 1.0f;
        self.animationLayer.hidden = YES;
        self.standbyLayer.hidden = NO;
    }];
    
}

-(void)setPullProgress:(float)progress
{
     self.timeOffset = (progress / kTableViewBeginLoadingHeight);
}

#pragma mark - Private methods

- (void)createStandbyLayers {
    
    for (int i = 0; i < 12; i ++) {
        CALayer *layer = [self createLayer];
        
        layer.transform = CATransform3DMakeRotation(M_PI/6 * i, 0, 0, 1);
        
        layer.hidden = YES;
        
        [self.standbyLayer addSublayer:layer];
        [self.standbyLayersArray addObject:layer];
    }
    
}

- (void)createAnimationLayers {
    
    for (int i = 0; i < 12; i ++) {
        CALayer *layer = [self createLayer];
        
        layer.transform = CATransform3DMakeRotation(M_PI/6 * i, 0, 0, 1);
        
        CAAnimation *animation = [self createOpacityAnimationWithIndex:i];
        [layer addAnimation:animation forKey:[NSString stringWithFormat:@"key %d", i]];
        
        [self.animationLayer addSublayer:layer];
        [self.animationLayersArray addObject:layer];
    }
    
}

- (CALayer *)createLayer {
    
    CALayer *rectLayer = [[CALayer alloc] init];
    rectLayer.backgroundColor = self.tintColor.CGColor;
    rectLayer.frame = (CGRect){-1, -3, 2, 6};
    rectLayer.anchorPoint = (CGPoint){0.5, 2.0};
    rectLayer.allowsEdgeAntialiasing = YES;
    rectLayer.cornerRadius = 1.0f;
    
    return rectLayer;
}

- (CAAnimation *)createOpacityAnimationWithIndex:(NSInteger)index {
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0];
    opacityAnimation.duration = 1.0f;
    opacityAnimation.repeatCount = NSIntegerMax;
    opacityAnimation.speed = 1.0f;
    opacityAnimation.timeOffset = 1.0f - index/12.0f;
    
    return opacityAnimation;
}

- (CAAnimation *)createRotationAnimation {
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI_2];
    rotationAnimation.duration = 0.5f;
    rotationAnimation.repeatCount = 1;
    rotationAnimation.speed = 1.0f;
    rotationAnimation.delegate = self;
    rotationAnimation.removedOnCompletion = YES;
    
    return rotationAnimation;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

    self.isRotating = NO;
    
    self.standbyLayer.hidden = YES;
    self.animationLayer.hidden = NO;
    
}

@end
