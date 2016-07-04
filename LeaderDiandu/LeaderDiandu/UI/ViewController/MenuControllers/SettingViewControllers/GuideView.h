//
//  GuideView.h
//  djApp
//
//  Created by tianlibin on 4/17/14.
//  Copyright (c) 2014 dajie.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

@interface GuideView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIImageView* imageView1;
@property (nonatomic, strong) UIImageView* imageView2;
@property (nonatomic, strong) UIImageView* imageView3;
@property (nonatomic, strong) UIButton* enterButton;

@property (nonatomic, strong) UIPageControl* pageControl;

+ (BOOL)needNotShowGuideView;
+ (void)showGuideViewAnimated:(BOOL)animated;
+ (void)hideGuideView:(UIView*)view;

@end
