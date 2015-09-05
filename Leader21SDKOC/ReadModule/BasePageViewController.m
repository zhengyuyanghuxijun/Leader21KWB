//
//  BasePageViewController.m
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-11.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "BasePageViewController.h"
#import "ReadBookLoudSpeaker.h"

@interface BasePageViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, retain) NSMutableArray *grArray;

@end

@implementation BasePageViewController

- (id)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options
{
    self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];
    if (self) {
        self.grArray = [NSMutableArray array];
        for (UIGestureRecognizer *gr in self.view.gestureRecognizers)
        {
            gr.delegate = self;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if ([touch.view isKindOfClass:[UIButton class]]) {
            return NO;
        }
        else
        {
            CGPoint touchPoint = [touch locationInView:self.view];
            [self.aDelegate pageViewControllerTap:touchPoint];
            return NO;
        }
    }
    return YES;
}

@end
