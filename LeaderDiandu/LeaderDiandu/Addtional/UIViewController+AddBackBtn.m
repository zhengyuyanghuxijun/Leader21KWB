//
//  UIViewController+AddBackBtn.m
//  LeaderDiandu
//
//  Created by Lee on 14/12/2.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "UIViewController+AddBackBtn.h"

@implementation UIViewController (AddBackBtn)


- (void)addBackButton
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(8, 20, 44, 44)];
    [button setBackgroundImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"back_press"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIScreenEdgePanGestureRecognizer *left2rightSwipe = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [left2rightSwipe setDelegate:self];
    [left2rightSwipe setEdges:UIRectEdgeLeft];
    [self.view addGestureRecognizer:left2rightSwipe];

//    self.navigationItem.leftBarButtonItem =
//    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"account_head_icon"]
//                                     style:UIBarButtonItemStylePlain
//                                    target:self
//                                    action:@selector(backAction)];
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}


- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)backAction{
//        [self.navigationController popViewControllerAnimated:YES];
//}
//-(void)dealloc{
//    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
//}

-(NSUInteger)supportedInterfaceOrientations{
    //这里写你需要的方向
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -
- (void)handleSwipeGesture:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer
{
    [self backButtonPressed:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL result = NO;
    
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        result = YES;
    }
    return result;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

@end
