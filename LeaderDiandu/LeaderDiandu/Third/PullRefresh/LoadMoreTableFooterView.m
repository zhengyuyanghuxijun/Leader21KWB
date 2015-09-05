//
//  LoadMoreTableFooterView.h
//
//  Created by Ye Dingding on 10-12-24.
//  Copyright 2010 Intridea, Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


#import "LoadMoreTableFooterView.h"
#import "ViewCreatorHelper.h"

#define FLIP_ANIMATION_DURATION 0.18f
#define Arrow_Image_Tag         1010

@interface LoadMoreTableFooterView (Private)
- (void)setState:(LoadMoreState)aState;
@end

@implementation LoadMoreTableFooterView

@synthesize delegate=_delegate;
@synthesize loadMorePullingString;
@synthesize loadMoreNormalString;
@synthesize loadMoreLoadingString;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
        
        //self.backgroundColor = [UIColor whiteColor];
        UIImageView *bgImageView   = [[UIImageView alloc]initWithFrame:self.bounds];
        CGRect size = bgImageView.frame;
        size.origin.x += 5;
        size.size.width -= 10;
        bgImageView.frame = size;
        bgImageView.image = [UIImage imageWithName:@"white_bg.png" size:bgImageView.frame.size];
        
        //[self addSubview:bgImageView];
        //[self sendSubviewToBack:bgImageView];
				
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(55.0f, 20.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;

		self.hidden = YES;
        _loadMoreHeight = 60.0f;
		
		[self setState:LoadMoreNormal];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleSingleTapGesture:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapRecognizer];
        
        self.loadMorePullingString  = LoadMorePullingString_Default;
        self.loadMoreNormalString   = LoadMoreNormalString_Default;
        self.loadMoreLoadingString  = LoadMoreLoadingString_Default;
    }
	
    return self;	
}


- (void)setLoadMoreHeight:(CGFloat)loadMoreHeight
{
    if (_loadMoreHeight != loadMoreHeight) {
        _loadMoreHeight = loadMoreHeight;
        [_activityView setFrame:CGRectMake(CGRectGetMinX(_activityView.frame), (_loadMoreHeight - 20.0f)/2, CGRectGetWidth(_activityView.frame), 20.0f)];
        [_statusLabel setFrame:CGRectMake(CGRectGetMinX(_statusLabel.frame), (_loadMoreHeight - 20.0f)/2, CGRectGetWidth(_statusLabel.frame), 20.0f)];
    }
}

#pragma mark -
#pragma mark Setters

- (void)setState:(LoadMoreState)aState{	
	switch (aState) {
		case LoadMorePulling:
        {
			_statusLabel.text = NSLocalizedString(self.loadMorePullingString, @"");
            _statusLabel.frame = CGRectMake(0.0f, (_loadMoreHeight - 20.0f)/2, self.frame.size.width, 20.0f);
            
            UIImageView *imageArrow = (UIImageView*)[self viewWithTag:Arrow_Image_Tag];
            if (imageArrow)
            {
                imageArrow.hidden = NO;
                [imageArrow setImage:[UIImage imageNamed:@"content_arrow_up.png"]];
            }
            
			break;
        }
		case LoadMoreNormal:
        {
			_statusLabel.text = NSLocalizedString(self.loadMoreNormalString, @"");
            _statusLabel.frame = CGRectMake(0.0f, (_loadMoreHeight - 20.0f)/2, self.frame.size.width, 20.0f);
			[_activityView stopAnimating];
            
            UIImageView *imageArrow = (UIImageView*)[self viewWithTag:Arrow_Image_Tag];
            if (imageArrow)
            {
                imageArrow.hidden = NO;
                [imageArrow setImage:[UIImage imageNamed:@"content_arrow_down.png"]];
            }
			break;
        }
		case LoadMoreLoading:
        {
            _statusLabel.text = NSLocalizedString(self.loadMoreLoadingString, @"");
            _statusLabel.frame = CGRectMake(0.0f, (_loadMoreHeight - 20.0f)/2, self.frame.size.width, 20.0f);
			[_activityView startAnimating];
            
            if ([self viewWithTag:Arrow_Image_Tag])
            {
                [(UIImageView*)[self viewWithTag:Arrow_Image_Tag] setImage:nil];
            }
			break;
        }
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollView = scrollView;
	if (_state == LoadMoreLoading) {
		scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top, 0.0f, _loadMoreHeight, 0.0f);
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
			_loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
		}
		
		if (_state == LoadMoreNormal && scrollView.contentOffset.y < (scrollView.contentSize.height - (scrollView.frame.size.height - _loadMoreHeight)) && scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height) && !_loading) {
			self.frame = CGRectMake(0, scrollView.contentSize.height, self.frame.size.width, self.frame.size.height);
			self.hidden = NO;
		} else if (_state == LoadMoreNormal && scrollView.contentOffset.y > (scrollView.contentSize.height - (scrollView.frame.size.height - _loadMoreHeight)) && !_loading) {
			[self setState:LoadMorePulling];
		} else if (_state == LoadMorePulling && scrollView.contentOffset.y < (scrollView.contentSize.height - (scrollView.frame.size.height - _loadMoreHeight)) && scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height) && !_loading) {
			[self setState:LoadMoreNormal];
		} 		
		if (scrollView.contentInset.bottom != _loadMoreHeight - _loadMoreHeight/10) {
			scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top, 0.0f, _loadMoreHeight - _loadMoreHeight/10, 0.0f);
		}
        
//        CGFloat offset = scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height) - scrollView.contentInset.bottom;
//        if (offset <= 20.0f && offset >= 0) {
//            _statusLabel.frame = CGRectMake(0.0f, 10.0f + offset / 2, self.frame.size.width, 20.0f);
//        }
	}
}

- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView {
	self.scrollView = scrollView;
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
		_loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y > (scrollView.contentSize.height - (scrollView.frame.size.height - _loadMoreHeight)) && !_loading) {		
		if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerRefresh:)]) {
			[_delegate loadMoreTableFooterDidTriggerRefresh:self];
		}
		
		[self setState:LoadMoreLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top, 0.0f, _loadMoreHeight, 0.0f);
		[UIView commitAnimations];
	}
}

- (void)loadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[self setState:LoadMoreNormal];
	self.hidden = YES;
}

- (void)loadMoreSCrollViewWithFailNet:(UIScrollView *)scrollView
{
    [self setState:LoadMoreNormal];
}

- (void)handleSingleTapGesture:(UITapGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
            _loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
            if (!_loading) {
                if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerRefresh:)]) {
                    [_delegate loadMoreTableFooterDidTriggerRefresh:self];
                }
                
                [self setState:LoadMoreLoading];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.2];
                _scrollView.contentInset = UIEdgeInsetsMake(_scrollView.contentInset.top, 0.0f, _loadMoreHeight, 0.0f);
                [UIView commitAnimations];
            }
        }
    }
}

-(void)addArrowPic:(BOOL)isAdd
{
    if (isAdd)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"content_arrow_down.png"]];
        
        CGFloat     labelTextWidth = 0.0f;
        if (loadMoreNormalString)
        {
            CGSize		textSize = { 1000.0f, 20};		// width and height of text area
            CGSize		size = [loadMoreNormalString sizeWithFont: [UIFont systemFontOfSize:13]
                                           constrainedToSize:textSize
                                               lineBreakMode:NSLineBreakByWordWrapping];
            labelTextWidth = size.width;
        }
        
        imageView.frame = CGRectMake((320-labelTextWidth)/2 - 20, _statusLabel.frame.origin.y+6, 10, 10);
        imageView.tag = Arrow_Image_Tag;
        imageView.hidden = YES;
        
        
        [self addSubview:imageView];
    }
    else
    {
        if ([self viewWithTag:Arrow_Image_Tag])
        {
            [[self viewWithTag:Arrow_Image_Tag] removeFromSuperview];
        }
    }
}

-(BOOL)isNeedLoadMoreHeightWithScrollView:(UIScrollView*)scrollViewT
{
    if (scrollViewT.contentOffset.y > (scrollViewT.contentSize.height - (scrollViewT.frame.size.height - _loadMoreHeight))) {
        return YES;
    }
    else
        return NO;
}

@end
