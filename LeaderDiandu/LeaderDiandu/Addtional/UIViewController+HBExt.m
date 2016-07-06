//
//  UIViewController+HBExt.m
//  LediKWB
//
//  Created by ChunGuo on 15/12/11.
//  Copyright © 2016年 huxijun. All rights reserved.
//

#import "UIViewController+HBExt.h"

@implementation UIViewController (DismissKeyboard)

- (void)setupForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    
    __weak UIViewController *weakSelf = self;
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [weakSelf.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [weakSelf.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

@end


@implementation UIViewController (AddBackBtn)


- (void)addBackButton
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(8, 20, 44, 44)];
    [button setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"back_press"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIScreenEdgePanGestureRecognizer *left2rightSwipe = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [left2rightSwipe setDelegate:self];
    [left2rightSwipe setEdges:UIRectEdgeLeft];
    [self.view addGestureRecognizer:left2rightSwipe];
}

- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

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
