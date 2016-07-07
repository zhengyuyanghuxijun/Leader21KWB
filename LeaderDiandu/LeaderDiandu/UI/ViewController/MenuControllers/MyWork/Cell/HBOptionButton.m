//
//  HBOptionButton.m
//  LeaderDiandu
//
//  Created by xijun on 15/10/12.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBOptionButton.h"

@implementation HBOptionButton

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI:title];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [singleTap setNumberOfTapsRequired:1];
        [singleTap setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)initUI:(NSString *)title
{
    [self setBackgroundImage:[UIImage imageNamed:@"test-btn-choose-normal"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"test-btn-choose-press"] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageNamed:@"test-btn-choose-selected"] forState:UIControlStateSelected];
    [self setTitleColor:HEXRGBCOLOR(0xff8903) forState:UIControlStateNormal];
    
    CGSize size = self.frame.size;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(2, 2, size.width-4, size.height-4)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:scrollView];
    
    CGSize strSize = [title boundingRectWithSize:CGSizeMake(scrollView.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    scrollView.contentSize = strSize;
    if (strSize.height < size.height) {
        scrollView.scrollEnabled = NO;
        strSize = size;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, strSize.width, strSize.height)];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [scrollView addSubview:label];
}

- (void)handleTap:(UIPanGestureRecognizer *)recognizer
{
    if (self.delegate) {
        [self.delegate setOptionButtonSelected:self];
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
