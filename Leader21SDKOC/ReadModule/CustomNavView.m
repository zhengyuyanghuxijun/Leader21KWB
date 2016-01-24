//
//  CustomNavView.m
//  PaipaiGou
//
//  Created by libin.tian on 12-7-23.
//  Copyright (c) 2012年 ilovedev.com. All rights reserved.
//

#import "CustomNavView.h"

#define MAX_BACK_BUTTON_WIDTH 160.0

typedef enum {
    ReLayoutViewsType_All = 100,
    ReLayoutViewsType_onlyTitle
} ReLayoutViewsType;

static const CGFloat detalHeightForIos7 = 20.0f;
static const CGFloat navBarBgAlpha = 1.0f;

@interface CustomNavView ()

@property (strong, nonatomic) NSMutableArray *leftViews;
@property (strong, nonatomic) NSMutableArray *rightViews;
@property (strong, nonatomic) UIImageView    *bgImageView;

- (void)reLayoutViews:(ReLayoutViewsType )reLayoutViewsType;

@end


#define VIEWSPACE 10

@implementation CustomNavView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        // Initialization code
        _leftViews = [[NSMutableArray alloc] initWithCapacity:0];
        _rightViews = [[NSMutableArray alloc] initWithCapacity:0];
        
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        _bgImageView.backgroundColor = CUSTOM_NAVBAR_COLOR;
//        _bgImageView.image = [UIImage resizebleImageNamed:@"titlebar.png"];
        _bgImageView.alpha = navBarBgAlpha;
        [self addSubview:_bgImageView];
    }
    return self;
}

- (void)resetBackgroundColor:(UIColor*)color
{
    self.bgImageView.backgroundColor = color;
}


// 隐藏背影
- (void)hideBg:(BOOL)hide animated:(BOOL)animated
{
    if (hide) {
        if (!self.bgImageView.isHidden) {
            if (animated) {
                [UIView animateWithDuration:0.1f
                                 animations:^{
                                     self.bgImageView.alpha = navBarBgAlpha;
                                     self.bgImageView.hidden = YES;
                                 }];
            }
            else {
                self.bgImageView.hidden = YES;
            }
        }
    }
    else {
        if (self.bgImageView.isHidden) {
            self.bgImageView.hidden = NO;
            if (animated) {
                self.bgImageView.alpha = 0.0f;
                [UIView animateWithDuration:0.1f
                                 animations:^{
                                     self.bgImageView.alpha = navBarBgAlpha;
                                 }];
            }
            else {
                self.bgImageView.alpha = navBarBgAlpha;
            }
        }
    }
}

- (void)setTitleLabel:(UILabel*)label
{
    if (self.titleView) {
        [self.titleView removeFromSuperview];
    }
    
    self.titleView = label;
    if (label == nil) {
        return;
    }
    CGFloat offset = 0.0;
    int count = 0;
    count = self.leftViews.count > self.rightViews.count ? self.leftViews.count : self.rightViews.count;
    offset = count * 45 + 10;
    
    label.frame = CGRectMake(offset, 0, self.frame.size.width - offset * 2, 44 );
    
    
    [self addSubview:label];
}

- (void)setText:(NSString*)text onBackButton:(UIButton*)backButton leftCapWidth:(CGFloat)capWidth
{
    // Measure the width of the text
    CGSize textSize = [text sizeWithFont:backButton.titleLabel.font];
    textSize.width = ((NSInteger)(textSize.width / 2)) * 2;
    textSize.height = ((NSInteger)(textSize.height / 2)) * 2;
    // Change the button's frame. The width is either the width of the new text or the max width
    backButton.frame = CGRectMake(backButton.frame.origin.x, backButton.frame.origin.y, (textSize.width + (capWidth * 2.0)) > MAX_BACK_BUTTON_WIDTH ? MAX_BACK_BUTTON_WIDTH : (textSize.width + (capWidth * 2.0)), backButton.frame.size.height);
    
    // Set the text on the button
    [backButton setTitle:text forState:UIControlStateNormal];
}

- (void)setText:(NSString*)text onLabel:(UILabel*)label leftCapWidth:(CGFloat)capWidth
{
    // Measure the width of the text
    CGSize textSize = [text sizeWithFont:label.font];
    textSize.width = ((NSInteger)(textSize.width / 2)) * 2;
    textSize.height = ((NSInteger)(textSize.height / 2)) * 2;
    // Change the button's frame. The width is either the width of the new text or the max width
    CGRect rect = label.frame;
    rect.size.width = textSize.width + (capWidth * 2);
    rect.origin.x = (self.frame.size.width - rect.size.width) / 2;
    label.frame = rect;
    
    // Set the text on the button
}


- (void)reLayoutViews:(ReLayoutViewsType )reLayoutViewsType
{
    if (reLayoutViewsType == ReLayoutViewsType_All) {
        //
    }else if (reLayoutViewsType == ReLayoutViewsType_onlyTitle) {
        
        if (self.titleView && [self.subviews containsObject:self.titleView]) {
//            CGSize titleSize = self.titleView.frame.size;
            float  leftViewsWidth = 0;
//            float   defaultTitleX = (self.frame.size.width - titleSize.width) / 2;
            
            if (self.leftViews.count > 0) {
                UIView *view = [self.leftViews objectAtIndex:(self.leftViews.count - 1)];
                leftViewsWidth = CGRectGetMaxX(view.frame);
                leftViewsWidth += VIEWSPACE;
            }
            
//            if (leftViewsWidth > defaultTitleX) {
//                [self.titleView setFrame:CGRectMake(leftViewsWidth + VIEWSPACE, self.titleView.frame.origin.y, leftViewsWidth, titleSize.height)];
//            }else {
//                [self.titleView setFrame:CGRectMake(defaultTitleX, self.titleView.frame.origin.y, titleSize.width, titleSize.height)];
//            }
        }
    }
}

- (void) setBackgroundImageView:(UIImage *)bgImage
{
    if (bgImage == nil) {
        return;
    }
    if ([self.subviews containsObject:self.bgImageView]) {
        [self.bgImageView removeFromSuperview];
    }
    self.bgImageView.height = self.height;
    [self.bgImageView setImage:bgImage];
    [self addSubview:self.bgImageView];
    [self sendSubviewToBack:self.bgImageView];
}

- (void)setLeftCustomView:(UIView *)view
{
    for (UIView *leftView in self.leftViews) {
        [leftView removeFromSuperview];
    }
    [self.leftViews removeAllObjects];
    
    [self.leftViews addObject:view];
    [self addSubview:view];
    
    float leftViewWidth = 0;
    
    if (self.leftViews.count > 1) {
        UIView *view = [self.leftViews objectAtIndex:(self.leftViews.count - 1 - 1)];
        leftViewWidth = CGRectGetMaxX(view.frame);
        leftViewWidth += VIEWSPACE;
    }
    [view setFrame:CGRectMake(leftViewWidth, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
    
    [self reLayoutViews:ReLayoutViewsType_onlyTitle];
}

- (void)setLeftCustomViews:(NSArray *)views
{
    for (UIView *view in self.leftViews) {
        [view removeFromSuperview];
    }
    [self.leftViews removeAllObjects];
    [self.leftViews addObjectsFromArray:views];
    
    float leftViewsWidth = 0;
    int count = 0;
    for (UIView *view in views) {
//        if (count > 0) {
            leftViewsWidth += VIEWSPACE;
//        }
        [self addSubview:view];
        [view setFrame:CGRectMake(leftViewsWidth, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
        leftViewsWidth += view.frame.size.width;
        count++;
    }
    
    [self reLayoutViews:ReLayoutViewsType_onlyTitle];
}

- (void)removeAllLeftCustomViews
{
    for (UIView *view in self.leftViews) {
        [view removeFromSuperview];
    }
    [self.leftViews removeAllObjects];
    
    [self reLayoutViews:ReLayoutViewsType_onlyTitle];
}

- (void)setRightCustomView:(UIView *)view;
{
    for (UIView *rightView in self.rightViews) {
        [rightView removeFromSuperview];
    }
    [self.rightViews addObject:view];
    [self addSubview:view];
    
    float rightViewWidth = self.frame.size.width;
    
    if (self.rightViews.count > 1) {
        UIView *view = [self.rightViews objectAtIndex:(self.rightViews.count - 1 - 1)];
        rightViewWidth = view.frame.origin.x ;
        rightViewWidth -= VIEWSPACE;
    }
    [view setFrame:CGRectMake((rightViewWidth - view.frame.size.width), view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
}

- (void)setRightCustomViews:(NSArray *)views
{
    for (UIView *view in self.rightViews) {
        [view removeFromSuperview];
    }
    [self.rightViews removeAllObjects];
    [self.rightViews addObjectsFromArray:views];
    
    float  rightViewsWidth = self.frame.size.width;
    
    CGFloat detalX = 0.0f;
//    if ([[UIDevice currentDevice] systemVersionNotLowerThan:@"7.0"]) {
//        detalX = detalHeightForIos7;
//    }
    for (int index = [self.rightViews count] -1; index >= 0; index --) {
        UIView *view = [self.rightViews objectAtIndex:index];
        if (index <=  [self.rightViews count] -1) {
            rightViewsWidth -= VIEWSPACE;
        }
        [self addSubview:view];
        [view setFrame:CGRectMake((rightViewsWidth - view.frame.size.width), view.frame.origin.y+detalX, view.frame.size.width, view.frame.size.height-detalX)];
        rightViewsWidth -= view.frame.size.width;
    }
}

- (void)removeRightCustomView:(UIView *)view
{
    if (![self.rightViews containsObject:view]) {
        return;
    }
    [view removeFromSuperview];
    [self.rightViews removeObject:view];
    
    float  rightViewWidth = 0;
    int count = 0;
    CGFloat detalX = 0.0f;
//    if ([[UIDevice currentDevice] systemVersionNotLowerThan:@"7.0"]) {
//        detalX = detalHeightForIos7;
//    }
    for (UIView *view in self.rightViews) {
        if (count > 0) {
            rightViewWidth -= VIEWSPACE;
        }
        [view setFrame:CGRectMake((rightViewWidth - view.frame.size.width), view.frame.origin.y+detalX, view.frame.size.width, view.frame.size.height-detalX)];
        rightViewWidth -= view.frame.size.width;
        count++;
    }
}

- (void)removeAllRightCustomViews
{
    for (UIView *view in self.rightViews) {
        [view removeFromSuperview];
    }
    [self.rightViews removeAllObjects];
}

- (void) setTitleCustomView:(UIView *)view
{
    
    if (self.titleView) {
        [self.titleView removeFromSuperview];
    }

    self.titleView = view;
    if (view == nil) {
        return;
    }
    [self addSubview:view];
    CGSize titleSize = view.frame.size;
    float  leftViewsWidth = 0;
    int count = 0;
    float   defaultTitleX = (self.frame.size.width - titleSize.width) / 2;
    for (UIView *leftView in self.leftViews) {
        if (count > 0) {
            leftViewsWidth += VIEWSPACE;
        }
        leftViewsWidth += leftView.frame.origin.x + leftView.frame.size.width;
        count++;
    }
    
    CGFloat detalX = 0.0f;
    if (IOS7_Later) {
        detalX = detalHeightForIos7;
    }

    if (leftViewsWidth > defaultTitleX) {
        [view setFrame:CGRectMake(leftViewsWidth + VIEWSPACE, view.frame.origin.y+detalX, (self.width-(leftViewsWidth+VIEWSPACE)*2), titleSize.height-detalX)];
    }
    else {
        [view setFrame:CGRectMake(defaultTitleX, view.frame.origin.y+detalX, (self.width-defaultTitleX*2), titleSize.height-detalX)];
    } 
}

- (void) clearTitleCustomView
{
    if (self.titleView && [self.subviews containsObject:self.titleView]) {
        [self.titleView removeFromSuperview];
    }
    self.titleView = nil;
}

- (void) removeAllCustomNavView
{
    for (UIView *leftView in self.leftViews) {
        [leftView removeFromSuperview];
    }
    [self.leftViews removeAllObjects];
    
    for (UIView *rightView in self.rightViews) {
        [rightView removeFromSuperview];
    }
    
    [self.rightViews removeAllObjects];
    
    if (self.titleView) {
        [self.titleView removeFromSuperview];
        self.titleView = nil;
    }
}

- (UIView *)getLeftCustomView
{
    if (self.leftViews && self.leftViews.count > 0) {
        return [self.leftViews objectAtIndex:0];
    }
    return nil;
}

- (NSArray *)getLeftCustomViews
{
    return self.leftViews;
}

- (UIView *)getRightCustomView
{
    if (self.rightViews && self.rightViews.count > 0) {
        return [self.rightViews objectAtIndex:0];
    }
    return nil;
}

- (NSArray *)getRightCustomViews
{
    return self.rightViews;
}


@end
