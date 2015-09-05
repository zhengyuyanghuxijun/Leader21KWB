//
//  CustomNavView.h
//  PaipaiGou
//
//  Created by libin.tian on 12-7-23.
//  Copyright (c) 2012年 ilovedev.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavView : UIView


@property (strong, nonatomic) UIView         *titleView;




- (void)setTitleLabel:(UILabel*)label;
/*
 *  设置button的title 以及title的位置。
 */
- (void)setText:(NSString*)text onBackButton:(UIButton*)backButton leftCapWidth:(CGFloat)capWidth;

/*
 *  设置label的title 以及title的位置。
 */
- (void)setText:(NSString*)text onLabel:(UILabel*)label leftCapWidth:(CGFloat)capWidth;

/*
 *  设置CustomNavView背景图。
 */
- (void) setBackgroundImageView:(UIImage *)bgImage;

/*
 *  设置CustomNavView,左边的自定义View。
 */
- (void) setLeftCustomView:(UIView *)view;

/*
 *  设置CustomNavView,左边的自定义Views。
 */
- (void) setLeftCustomViews:(NSArray *)views;

/*
 *  获取已经设置过的CustomNavView左边的自定义View，如果没有设置过，返回nil。
 */
- (UIView *)getLeftCustomView;

/*
 *  获取已经设置过的CustomNavView左边的自定义Views，如果没有设置过，返回nil。
 */
- (NSArray *)getLeftCustomViews;

/*
 *  移除已经设置过的CustomNavView左边的自定义Views。
 */
- (void) removeAllLeftCustomViews;

/*
 *  设置CustomNavView,右边的自定义View。
 */
- (void) setRightCustomView:(UIView *)view;

/*
 *  设置CustomNavView,右边的自定义Views。
 */
- (void) setRightCustomViews:(NSArray *)views;

/*
 *  获取已经设置过的CustomNavView右边的自定义View，如果没有设置过，返回nil。
 */
- (UIView *)getRightCustomView;

/*
 *  获取已经设置过的CustomNavView右边的自定义Views，如果没有设置过，返回nil。
 */
- (NSArray *)getRightCustomViews;

/*
 *  移除已经设置过的CustomNavView右边的自定义View。
 */
- (void) removeRightCustomView:(UIView *)view;

/*
 *  移除已经设置过的CustomNavView右边的自定义Views。
 */
- (void) removeAllRightCustomViews;

/*
 *  设置CustomNavView的title。
 */
- (void) setTitleCustomView:(UIView *)view;

/*
 *  清空CustomNavView的title。
 */
- (void) clearTitleCustomView;

/*
 *  清空CustomNavView所有的View。
 */
- (void) removeAllCustomNavView;

// 隐藏背影
- (void)hideBg:(BOOL)hide animated:(BOOL)animated;

- (void)resetBackgroundColor:(UIColor*)color;

@end
