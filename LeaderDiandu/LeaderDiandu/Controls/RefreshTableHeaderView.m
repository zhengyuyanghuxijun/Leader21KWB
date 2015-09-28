//
//  EGORefreshTableHeaderView.m
//  Fetion
//
//  Created by 闻 小叶 on 13-11-15.
//  Copyright (c) 2013年 xinrui.com. All rights reserved.
//

#import "RefreshTableHeaderView.h"

#define FLIP_ANIMATION_DURATION 0.18f
#define kScrollViewHeight self.frame.size.height - 113 //(113 为导航高度 + tablebar高度)
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//适用于RGB颜色相同的场景
#define RGBEQ(rgb) [UIColor colorWithRed:rgb/255.0 green:rgb/255.0 blue:rgb/255.0 alpha:1.0f]

@interface RefreshTableHeaderView (Private)

@end

@implementation RefreshTableHeaderView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]) != nil) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = RGBEQ(235);
		
		_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-17/*320===143.0f*/, frame.size.height - 40.0f, self.frame.size.width, 20.0f)];
		_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		_statusLabel.textColor = RGBEQ(117);
		_statusLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:_statusLabel];
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(ScreenWidth/2-52/*320===108.0f*/, frame.size.height - 40.0f, 20.0f, 20.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"dropmenu_refresh_down"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		FTRotatingCircle *view = [[FTRotatingCircle alloc] initWithFrame:CGRectMake(ScreenWidth/2-52/*320===108.0f*/, frame.size.height - 40.0f, 20.0f, 20.0f) imageName:@"msg_public_icon_SMS"];
		[self addSubview:view];
		_activityView = view;
		
		[self setState:PullRefreshNormal];
    }
	
    return self;
}

#pragma mark -
#pragma mark Setters

- (void)setState:(PullRefreshState)aState{
	
	switch (aState) {
		case PullRefreshPulling:
			
			_statusLabel.text = @"松开即可刷新";
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.contents = (id)[UIImage imageNamed:@"dropmenu_refresh_down"].CGImage;
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case PullRefreshNormal:
			
			if (_state == PullRefreshPulling)
            {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = @"下拉可以刷新";
			_activityView.hidden = YES;
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
            _arrowImage.contents = (id)[UIImage imageNamed:@"dropmenu_refresh_down"].CGImage;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
		case PullRefreshLoading:
			
			_statusLabel.text = @"正在刷新...";
			_activityView.hidden = NO;
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
        case PullRefreshFinish:
            _statusLabel.text = @"刷新完成";
			_activityView.hidden = YES;
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
            _arrowImage.contents = (id)[UIImage imageNamed:@"msg_icon_queding"].CGImage;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
	if(_state == PullRefreshFinish)
    {
        _state = PullRefreshNormal;
        [self setState:PullRefreshNormal];
    }
	if (_state == PullRefreshLoading)
    {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	}
    else if (scrollView.isDragging)
    {
		BOOL _loading = NO;
        
		if ([self.delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)])
        {
			_loading = [_delegate refreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == PullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading)
        {
			[self setState:PullRefreshNormal];
		}
        else if (_state == PullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading)
        {
			[self setState:PullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)])
    {
		_loading = [_delegate refreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading)
    {
		if ([_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate refreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:PullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:PullRefreshFinish];
}

- (void)refreshScrollViewDataSourceDidFinishedLoadingWithState:(UIScrollView *)scrollView
{
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	_state = PullRefreshFinish;
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_arrowImage = nil;
}

@end
