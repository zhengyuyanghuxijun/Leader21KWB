//
//  ScrollLayoutViewController.h
//  magicEnglish
//
//  Created by dajie on 2/8/14.
//  Copyright (c) 2014 wangliang. All rights reserved.
//

#import "BaseViewController.h"


@interface ScrollLayoutViewController : BaseViewController<UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat whiteSpace;
@property (nonatomic, assign) CGFloat topSpace;
@property (nonatomic, assign) CGFloat leftSpace;

@property (nonatomic, strong) UIScrollView* mainScrollView;

// 把需要排版的view务必同时加到这个数组中，目前只支持纵向排版
@property (nonatomic, strong) NSMutableArray* layoutViewArray;


//////////////////////////////////////////
// 子类一定要重写的方法
- (void)createLayoutViews;


//////////////////////////////////////////
// 供子类调用，子类一般不用重写，特殊需求再重写的方法
- (void)layoutCustomViews;

- (void)addToLayoutView:(UIView*)view;
- (void)addEmptyViewWithHeight:(CGFloat)height;

@end
