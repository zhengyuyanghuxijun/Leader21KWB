//
//  HBTitleView.m
//  LeaderDiandu
//
//  Created by hxj on 15/8/2.
//

#import "HBTitleView.h"

@implementation HBTitleView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.font = [UIFont boldSystemFontOfSize:20];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor whiteColor];
        self.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.shadowOffset = CGSizeMake(0, 1);
    }
    return self;
}

+ (instancetype)titleViewWithTitle:(NSString *)t onView:(UIView *)superView
{
    HBTitleView *titleView = [[HBTitleView alloc] initWithFrame:CGRectMake(80, 20+10, CGRectGetWidth(superView.frame)-80*2, 20) title:t];
    return titleView;
}

+ (HBTitleView *)titleView
{
    HBTitleView *titleView = [[HBTitleView alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
    return titleView;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)t
{
    self = [self initWithFrame:frame];
    if (self) {
        self.text = t;
    }
    return self;
}

@end
