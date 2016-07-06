//
//  HBBaseViewController.h
//  LediKWB
//
//  Created by xijun on 15/12/17.
//  Copyright © 2015年 hxj. All rights reserved.
//
#import "HBToastHud.h"

@interface HBBaseViewController : UIViewController


//Right Button
- (void)initNavBarRightBtnWithNormalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action;

- (void)initNavBarRightBtnWithNormalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action rect:(CGRect)rect;

- (void)initNavBarRightBtnWithNormalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage badgeValue:(NSString *)badgeValue target:(id)target action:(SEL)action;

- (void)initNavBarRightBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)initNavBarRightBtnWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action;

- (void)setNavBarRightBtnEnabled:(BOOL)enabled;
- (void)setNavBarRightBtnNil;

//Left Button
- (void)initNavBarLeftBtnWithNormalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action;

- (void)initNavBarLeftBtnWithNormalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action rect:(CGRect)rect;

- (void)initNavBarLeftBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)initNavBarLeftBtnWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action;

- (void)setNavBarLeftBtnEnabled:(BOOL)enabled;
- (void)setNavBarLeftBtnNil;

- (void)createNoLoginLabel:(NSString *)text;

/**
 *  导航标题，默认白色，子类需要自定义重写该方法
 *
 *  @param title 标题
 *  @param color 标题颜色
 */
- (void)setNavBarTitle:(NSString *)title color:(UIColor *)color;

/**
 *	@brief	显示等待视图
 *
 *	@param 	title 	提示文字
 */
- (void)showLoadingHUDView:(NSString *)title;

/**
 *	@brief	隐藏等待视图
 */
- (void)hideLoadingHUDView;

/**
 *	@brief	显示完成视图
 *
 *	@param 	title 	提示文字
 */
- (void)showCompleteHUDView:(NSString *)title;

/**
 *  @brief tip提示 蓝底白字，正常提示信息
 *
 *  @param msg 提示文字
 */
- (void)showTipNormal:(NSString *)msg;

/**
 *  @brief tip提示 黄底白字，提示警告信息
 *
 *  @param msg  提示文字
 *  @param code 错误码
 */
- (void)showTipWarn:(NSString *)msg code:(NSString *)code;

/**
 *  @brief tip提示 黄底白字，提示错误信息
 *
 *  @param errorCode 错误码
 */
- (void)showTipError:(NSInteger)errorCode;

/**
 *	@brief	显示只有一个button的Alert，用于提示警告
 */
- (void)showHintAlert:(NSString *)message buttonTitle:(NSString *)buttonTitle;

/**
 *  是否可左滑返回
 *
 *  @return
 */
- (BOOL)canDragBack;

@end
