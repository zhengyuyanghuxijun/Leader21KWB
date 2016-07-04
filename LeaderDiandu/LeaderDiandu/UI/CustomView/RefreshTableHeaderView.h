//
//  RefreshTableHeaderView.h
//  Fetion
//
//  Created by 闻 小叶 on 13-11-15.
//  Copyright (c) 2013年 xinrui.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FTRotatingCircle.h"

typedef enum{
	PullRefreshPulling = 0,
	PullRefreshNormal,
	PullRefreshLoading,
    PullRefreshFinish,
} PullRefreshState;

@protocol RefreshTableHeaderDelegate;
@interface RefreshTableHeaderView : UIView
{
	
	PullRefreshState _state;
    
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	FTRotatingCircle *_activityView;
}

@property(strong,nonatomic)NSString *sourceType;//刷新类型来源 只有好友列表请求刷新数据需要设置 解决ios7 好友列表下拉刷新闪过竖线bug

@property(nonatomic,weak) id <RefreshTableHeaderDelegate> delegate;

- (void)setState:(PullRefreshState)aState;
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoadingWithState:(UIScrollView *)scrollView;

@end


@protocol RefreshTableHeaderDelegate <NSObject>
- (void)refreshTableHeaderDidTriggerRefresh:(RefreshTableHeaderView*)view;
- (BOOL)refreshTableHeaderDataSourceIsLoading:(RefreshTableHeaderView*)view;
@end
