//
//  HBBaseNavigationController.m
//  LediKWB
//
//  Created by xijun on 15/12/17.
//  Copyright © 2015年 hxj. All rights reserved.
//

#import "HBBaseNavigationController.h"
#import "HBBaseViewController.h"

@interface HBBaseNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    
}

@end

@implementation HBBaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        
        if (self.isNoSupportPopGesture)
        {
            self.interactivePopGestureRecognizer.enabled = NO;
        }
        else
        {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.topViewController;
}


#pragma mark -UIGestureRecognizerDelegate

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(self.viewControllers.count > 1)
    {
        HBBaseViewController *viewC = [self.viewControllers lastObject];
        if (viewC && [viewC respondsToSelector:@selector(canDragBack)])
        {
            return [viewC canDragBack];
        }
        return YES;
    }
    else
    {
        return NO;
    }
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark -UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        if (!self.isNoSupportPopGesture)
        {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
