//
//  HBTableView.m
//  LeaderDiandu
//
//  Created by xijun on 15/11/13.
//  Copyright © 2015年 hxj. All rights reserved.
//

#import "HBTableView.h"

@interface HBTableView ()
{
    UIView *_emptyView;
}

@end

@implementation HBTableView

- (void)reloadData
{
    if (_emptyView) {
        [self hideEmptyView];
        self.scrollEnabled = YES;
    }
    [super reloadData];
}

- (void)showEmptyView:(NSString *)icon tips:(NSString *)tips
{
    if (_emptyView) {
        [self addSubview:_emptyView];
        return;
    }
    
    self.scrollEnabled = NO;
    
    _emptyView = [[UIView alloc] initWithFrame:self.bounds];
    _emptyView.backgroundColor = [UIColor clearColor];
    [self addSubview:_emptyView];
    
    CGSize viewSize = self.frame.size;
    float imgSide = 80;
    float controlX = (viewSize.width-imgSide) / 2;
    float controlY = viewSize.height / 4;
    if (icon) {
        UIImageView *emptyImg = [[UIImageView alloc] initWithFrame:CGRectMake(controlX, controlY, imgSide, imgSide)];
        emptyImg.image = [UIImage imageNamed:icon];
        [_emptyView addSubview:emptyImg];
        controlY += imgSide + 20;
    }
    
    controlX = 0;
    UILabel *emptyLbl = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, viewSize.width, 30)];
    emptyLbl.backgroundColor = [UIColor clearColor];
    emptyLbl.textColor = [UIColor lightGrayColor];
    emptyLbl.text = tips;
    if (myAppDelegate.isPad) {
        emptyLbl.font = [UIFont systemFontOfSize:30];
    }
    emptyLbl.textAlignment = NSTextAlignmentCenter;
    [_emptyView addSubview:emptyLbl];
}

- (void)hideEmptyView
{
    if (_emptyView) {
        [_emptyView removeFromSuperview];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
