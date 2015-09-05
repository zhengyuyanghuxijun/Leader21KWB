//
//  SegmentViewController.h
//  magicEnglish
//
//  Created by libin.tian on 9/17/13.
//  Copyright (c) 2013 ilovedev.com. All rights reserved.
//

#import "BaseViewController.h"

#import "SegmentControlView.h"

@interface SegmentViewController : BaseViewController
<SegmentControlViewDelegate,
UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSMutableArray* controllerArray;

@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) SegmentControlView* tabView;
@property (nonatomic, strong) UIScrollView* mainScrollView;


// 初始化self.headerView，并添加到view上 
- (void)createHeaderView;


@end
