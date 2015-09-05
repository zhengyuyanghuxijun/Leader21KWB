//
//  Navigator.h
//  magicEnglish
//
//  Created by libin.tian on 1/3/14.
//  Copyright (c) 2014 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Navigator : NSObject

// 通用
+ (void)pushController:(UIViewController*)viewController;
+ (void)pushController:(UIViewController*)viewController
                  animated:(BOOL)animated;
+ (void)pushController:(UIViewController*)viewController
         useNavigation:(UINavigationController*)navigationController
              animated:(BOOL)animated;

+ (void)presentController:(UIViewController*)viewController;
+ (void)presentController:(UIViewController*)viewController
                 animated:(BOOL)animated;
+ (void)presentController:(UIViewController*)viewController
             onController:(UIViewController*)parentController
                 animated:(BOOL)animated;

+ (void)popToRootController;
+ (void)popController;

// 个别界面
+ (void)showRootController;

+ (void)pushLoginController;

@end
