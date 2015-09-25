//
//  HBOptionView.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/25.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBOptionView.h"

@implementation HBOptionView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imgView.image = image;
        [self addSubview:imgView];
        
        self.cover = [[UIImageView alloc] initWithFrame:self.bounds];
        self.cover.hidden = YES;
        self.cover.image = [UIImage imageNamed:@"test-line-chooseimg-press"];
        [self addSubview:self.cover];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [singleTap setNumberOfTapsRequired:1];
        [singleTap setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (_cover) {
        _cover.hidden = !selected;
    }
}

- (void)handleTap:(UIPanGestureRecognizer *)recognizer
{
    if (self.delegate) {
        [self.delegate setOptionViewSelected:self];
    }
    
#if 0
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    CGRect sliderFrame = sliderView.frame;
    sliderFrame.origin.x = tappedViewX;
    sliderView.frame = sliderFrame;
    CGRect selFrame = selectedView.frame;
    selFrame.size.width = tappedViewX+spaceBetweenEachNo;
    selectedView.frame = selFrame;
    [UIView commitAnimations];
#endif
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
