//
//  HBToastHud.h
//  LediKWB
//
//  Created by wangxiao on 15/12/31.
//  Copyright © 2016年 huxijun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MRTipType){
    
    ETipType_Normal = 1,//蓝色背景
    ETipType_Warn   = 2,//黄色背景
    ETipType_Other  = 3,//黑色背景
};

@interface HBToastHud : UIView

/**
 *  创建单例
 *
 */
+ (instancetype)shared;

/**
 *  显示加载过程视图
 *
 *  @param text 显示的文本
 *  @param inView  添加到的视图
 */
- (void)showLoadingViewWithText:(NSString *)text inView:(UIView *)inView;

/**
 *  隐藏加载过程视图
 */
- (void)hideLoadingView;

/**
 *  显示加载完成视图，3秒消失
 *
 *  @param text   显示的文本
 *  @param inView 添加到的视图
 */
- (void)showCompleteViewWithText:(NSString *)text inView:(UIView *)inView;

/**
 *  文字提示条，3秒消失
 *
 *  @param text    提示文本
 *  @param inView  添加到的视图
 *  @param tipType 提示类型
 */
- (void)showTipViewWithText:(NSString *)text
                     inView:(UIView *)inView
                    tipType:(MRTipType)tipType;

@end
