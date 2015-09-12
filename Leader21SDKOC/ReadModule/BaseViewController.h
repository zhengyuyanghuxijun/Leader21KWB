//
//  BaseViewController.h
//  magicEnglish
//
//  Created by jianjie.wu on 8/13/13.
//  Copyright (c) 2013 ilovedev.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewCreatorHelper.h"
//#import "Navigator.h"

@class CustomNavView;

@interface BaseViewController : UIViewController


@property (nonatomic, copy) NSString* navBarTitle;
@property (nonatomic, strong) CustomNavView* navBarView;

@property (nonatomic, assign) BOOL showNavBar;
@property (nonatomic, assign) CGRect leftBarButtonRect;
@property (nonatomic, assign) CGRect rightBarButtonRect;
@property (nonatomic, assign) CGRect contentViewRect;
@property (nonatomic, assign) CGRect contentViewRectWithStatusBar;

@property (nonatomic, assign) BOOL useAsRootController;
@property (nonatomic, strong) UIImageView* bgImageView;

@property (nonatomic, assign) long long userId;

@property (nonatomic, assign) BOOL isLastStatusLogin;

- (void)resetBackground;

- (void)setLeftCustomViews:(NSArray*)leftCustomArray;
- (void)setRightCustomViews:(NSArray*)rightCustomArray;
- (void)customNavBarSetTitleImage:(UIImage*)titleImage;

- (void)goBack:(id)sender;

- (void)doSomethingInFirstAppear;


// 内存不足时的处理，子类中去实现
- (void)handleMemoryWarning;


+ (CGFloat)navBarHeight;
+ (CGFloat)navBarHeight2;

@end
