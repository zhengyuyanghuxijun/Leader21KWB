//
//  HBToastHud.m
//  LediKWB
//
//  Created by wangxiao on 15/12/31.
//  Copyright © 2016年 huxijun. All rights reserved.
//

#import "HBToastHud.h"
#import "MBProgressHUD.h"

#define HEXColor(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

static CGFloat const TipViewHeight = 32.0;

@interface HBToastHud()<MBProgressHUDDelegate>

@property(nonatomic,strong)MBProgressHUD           *HUD;
@property(nonatomic,strong)UIImageView             *loadingView;
@property(nonatomic,strong)UIButton                *currentTipView;

@end

@implementation HBToastHud

+ (instancetype)shared
{
    static HBToastHud *hud = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        hud = [[[self class] alloc] init];
    });
    
    return hud;
}

- (void)showLoadingViewWithText:(NSString *)text inView:(UIView *)inView
{
    _loadingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toast_loading"]];
    
    _HUD = [[MBProgressHUD alloc] initWithView:inView];
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.labelText = text;
    _HUD.delegate = self;
    _HUD.labelFont = [UIFont boldSystemFontOfSize:16.0];
    _HUD.customView = _loadingView;
    _HUD.opacity = 0.7;
    _HUD.margin = 33.0;
    _HUD.layer.cornerRadius = 15.0;
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.duration = 1.2;
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [_HUD.customView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [inView addSubview:_HUD];
    
    [_HUD show:YES];
}

- (void)hideLoadingView
{
    if (_HUD)
    {
        [_HUD.customView.layer removeAnimationForKey:@"rotationAnimation"];
        [_HUD hide:YES];
    }
}

- (void)showCompleteViewWithText:(NSString *)text inView:(UIView *)inView
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:inView];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = text;
    HUD.labelFont = [UIFont boldSystemFontOfSize:16.0];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toast_success"]];
    HUD.delegate = self;
    HUD.opacity = 0.7;
    HUD.margin = 33.0;
    HUD.layer.cornerRadius = 15.0;
    [inView addSubview:HUD];
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:1.0];
}

- (void)showTipViewWithText:(NSString *)text
                     inView:(UIView *)inView
                    tipType:(MRTipType)tipType
{
    [_currentTipView.layer removeAllAnimations];
    [_currentTipView removeFromSuperview];
    _currentTipView = nil;
    
    //设置展示UIView
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _currentTipView = [UIButton buttonWithType:UIButtonTypeCustom];
        _currentTipView.frame = CGRectMake(0, -TipViewHeight + 64, [UIScreen mainScreen].bounds.size.width, TipViewHeight);
        _currentTipView.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_currentTipView setTitle:text forState:UIControlStateNormal];
        [_currentTipView setTitleColor:HEXRGBCOLOR(0xffffff) forState:UIControlStateNormal];
        
        if (tipType == ETipType_Normal) {
            
            _currentTipView.backgroundColor = [self getUIColor:0x339de8 alpha:0.9];
            
        }else if (tipType == ETipType_Warn){
            
            _currentTipView.backgroundColor = [self getUIColor:0xffb422 alpha:0.9];
            
        }else{
            
            _currentTipView.backgroundColor = [self getUIColor:0x303030 alpha:0.9];
        }
        [inView addSubview:_currentTipView];
        
        //动画向下铺开
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            
            _currentTipView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, TipViewHeight);
            
        } completion:^(BOOL finished) {
            
            //动画向上收起
            [self flipOutTipView];
        }];
    });
}

- (void)flipOutTipView
{
    [UIView animateWithDuration:0.5 delay:2 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        
        _currentTipView.frame = CGRectMake(0, 64 - TipViewHeight, [UIScreen mainScreen].bounds.size.width, TipViewHeight);
        
    } completion:^(BOOL finished) {
        
        [_currentTipView removeFromSuperview];
    }];
}

- (UIColor *)getUIColor:(NSInteger)hex alpha:(CGFloat)alpha
{
   return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                          green:((float)((hex & 0xFF00) >> 8))/255.0
                           blue:((float)(hex & 0xFF))/255.0 alpha:alpha];
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}


@end
