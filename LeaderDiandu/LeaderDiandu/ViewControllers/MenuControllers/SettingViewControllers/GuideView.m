//
//  GuideView.m
//  djApp
//
//  Created by tianlibin on 4/17/14.
//  Copyright (c) 2014 dajie.com. All rights reserved.
//

#import "GuideView.h"

#import "ViewCreatorHelper.h"
#import "LocalSettings.h"
//#import "ExamLevelViewController.h"
#import "Navigator.h"

#import "LDProgressHUD.h"


static NSString* kNeedNotShow = @"kNeedNotShowGuideViewFor_V1_0_0";

static NSInteger pageCount = 3;

@implementation GuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        UIImage* image1 = nil;
        UIImage* image2 = nil;
        UIImage* image3 = nil;

//        if (frame.size.height > 480.0f) {
//            // 4寸手机
//            image1 = [UIImage imageNamed:@"splash_1h.png"];
//            image2 = [UIImage imageNamed:@"splash_2h.png"];
//            image3 = [UIImage imageNamed:@"splash_3h.png"];
//        }
//        else {
//            image1 = [UIImage imageNamed:@"splash_1.png"];
//            image2 = [UIImage imageNamed:@"splash_2.png"];
//            image3 = [UIImage imageNamed:@"splash_3.png"];
//        }
        image1 = [UIImage imageNamed:@"study_guide_1"];
        image2 = [UIImage imageNamed:@"study_guide_2"];
        image3 = [UIImage imageNamed:@"study_guide_3"];

        _imageView1 = [[UIImageView alloc] initWithImage:image1];
        _imageView2 = [[UIImageView alloc] initWithImage:image2];
        _imageView3 = [[UIImageView alloc] initWithImage:image3];
//        _imageView1.contentMode = UIViewContentModeCenter;
//        _imageView2.contentMode = UIViewContentModeCenter;
//        _imageView3.contentMode = UIViewContentModeCenter;
        _imageView1.backgroundColor = RGBCOLOR(28, 158, 201);
        _imageView2.backgroundColor = RGBCOLOR(28, 158, 201);
        _imageView3.backgroundColor = RGBCOLOR(28, 158, 201);
        [_scrollView addSubview:_imageView1];
        [_scrollView addSubview:_imageView2];
        [_scrollView addSubview:_imageView3];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 10.0f)];
        _pageControl.numberOfPages = pageCount;
        [_pageControl setCurrentPage:0];
        _pageControl.enabled = NO;
        _pageControl.hidden = YES;
        [self addSubview:_pageControl];
        
        _enterButton = [[UIButton alloc] init];
//        [_enterButton setBackgroundImage:[UIImage imageNamed:@"user_button"] forState:UIControlStateNormal];
//        [_enterButton setTitle:@"立即体验" forState:UIControlStateNormal];
        [_enterButton addTarget:self action:@selector(enterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.enterButton.hidden = YES;
        [self addSubview:_enterButton];
    }
    return self;
}

- (void)enterButtonPressed:(id)sender
{
    [GuideView hideGuideView:self];
}
//
- (void)layoutSubviews
{
    [super layoutSubviews];
 
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(w *(pageCount + 1), self.frame.size.height);
    CGRect rc = self.bounds;
    self.imageView1.frame = rc;
    rc.origin.x += rc.size.width;
    self.imageView2.frame = rc;
    rc.origin.x += rc.size.width;
    self.imageView3.frame = rc;
    
    self.pageControl.center = CGPointMake(w * 0.5, h - 20);
    self.pageControl.bounds = CGRectMake(0, 0, 150, 50);
    
    self.enterButton.center = CGPointMake(w * 0.5, h - 90);
    self.enterButton.bounds = CGRectMake(0, 0, 220, 50);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < 0.0f) {
        scrollView.contentOffset = CGPointZero;
    }
//    else if (scrollView.contentOffset.x > scrollView.frame.size.width * (pageCount-1)) {
//        self.pageControl.hidden = YES;
//    }
//    else {
//        self.pageControl.hidden = NO;
//    }
    
    self.enterButton.hidden = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.x > self.frame.size.width * (pageCount-1)) {
        [GuideView hideGuideView:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    NSInteger idx = x / scrollView.frame.size.width;
    [self.pageControl setCurrentPage:idx];
    
    if (2 == idx) {
        self.enterButton.hidden = NO;
    }
}

+ (BOOL)needNotShowGuideView
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kNeedNotShow];
}


+ (void)showGuideViewAnimated:(BOOL)animated
{
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    GuideView* view = [[GuideView alloc] initWithFrame:delegate.window.bounds];
    [delegate.window addSubview:view];
    
    if (animated) {
        
        CGRect frame = view.frame;
        frame.origin.x = delegate.window.frame.size.width;
        view.frame = frame;
        
        [UIView animateWithDuration:0.2f
                         animations:
         ^{
             CGRect frame = view.frame;
             frame.origin.x = 0.0f;
             view.frame = frame;
         }];
    }
}

+ (void)hideGuideView:(GuideView*)view
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedNotShow];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:0.2f
                     animations:^{
                         view.alpha = 0.0f;
//                         view.scrollView.contentOffset = CGPointMake(view.frame.size.width*(pageCount+1), 0.0f);
                     }
                     completion:^(BOOL finished) {
                         [view removeFromSuperview];
                     }];
}

@end
