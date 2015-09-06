//
//  Navigator.m
//  magicEnglish
//
//  Created by libin.tian on 1/3/14.
//  Copyright (c) 2014 ilovedev.com. All rights reserved.
//

#import "Navigator.h"
#import "AppDelegate.h"
#import "HBGradeViewController.h"

@implementation Navigator


#pragma mark - common method
+ (void)pushController:(UIViewController*)viewController
{
    [self pushController:viewController animated:YES];
}

+ (void)pushController:(UIViewController*)viewController
              animated:(BOOL)animated
{
    [self pushController:viewController
           useNavigation:[AppDelegate delegate].globalNavi
                animated:animated];
}

+ (void)pushController:(UIViewController*)viewController
         useNavigation:(UINavigationController*)navigationController
              animated:(BOOL)animated
{
    if (navigationController == nil) {
        navigationController = [AppDelegate delegate].globalNavi;
    }
    [navigationController pushViewController:viewController animated:animated];
}

+ (void)presentController:(UIViewController*)viewController
{
    [self presentController:viewController animated:YES];
}

+ (void)presentController:(UIViewController*)viewController
                 animated:(BOOL)animated
{
    [self presentController:viewController
               onController:[AppDelegate delegate].globalNavi
                   animated:animated];
}

+ (void)presentController:(UIViewController*)viewController
             onController:(UIViewController*)parentController
                 animated:(BOOL)animated
{
    if (parentController == nil) {
        parentController = [AppDelegate delegate].globalNavi;
    }
    
    [parentController presentViewController:viewController
                                   animated:animated
                                 completion:^{
                                     ;
                                 }];
}

+ (void)popToRootController
{
    [[AppDelegate delegate].globalNavi popToRootViewControllerAnimated:YES];
}

+ (void)popController
{
    [[AppDelegate delegate].globalNavi popViewControllerAnimated:YES];
}

// 个别界面
+ (void)showRootController
{
    HBGradeViewController* vc = [[HBGradeViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBarHidden = YES;
    [AppDelegate delegate].window.rootViewController = nav;
}

+ (void)pushLoginController
{
    [[AppDelegate delegate] showLoginVC];
}

@end
