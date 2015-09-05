//
//  SCRefreshControl.h
//  SCRefreshControl
//
//  Created by Singro on 12/29/13.
//  Copyright (c) 2013 Singro. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const kTableViewBeginLoadingHeight = 60.0f;

@interface SCRefreshControlView : UIView

@property (nonatomic, copy) UIColor *tintColor;

@property (nonatomic, assign) CGFloat timeOffset;  // 0.0 ~ 1.0

- (void)beginRefreshing;
- (void)endRefreshing;
- (void)setPullProgress:(float)progress;

@end
