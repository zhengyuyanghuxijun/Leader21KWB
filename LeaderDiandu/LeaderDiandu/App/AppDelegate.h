//
//  AppDelegate.h
//  LeaderDiandu
//
//  Created by xijun on 15/8/22.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBNLoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UINavigationController* globalNavi;
@property (nonatomic, strong) HBNLoginViewController *loginVC;

+ (AppDelegate *)delegate;

- (void)initDHSlideMenu;

- (void)showLoginVC;

@end

