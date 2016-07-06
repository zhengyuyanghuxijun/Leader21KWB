//
//  UITabBar+HBExt.m
//  LediKWB
//
//  Created by ChunGuo on 16/1/20.
//  Copyright © 2016年 MERI. All rights reserved.
//

#import "UITabBar+HBExt.h"

@implementation UITabBar (badge)

//显示小红点
- (void)showBadgeOnItemIndex:(NSUInteger)index
{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc] init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5;   //圆形
    badgeView.backgroundColor = [UIColor redColor]; //颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    CGFloat x;
    
    BOOL isShow = NO;//[AppDelegate.switchInfoModel.tabBarBtn isEqualToString:@"1"]
    if (isShow)
    {
        if (index == 2 || index == 3)
        {
            x = ceilf((index + 1 + 0.6) * (tabFrame.size.width / 5.0));
        }
        else
        {
            x = ceilf((index + 0.6) * (tabFrame.size.width / 5.0));
        }
    }
    else
    {
        x = ceilf((index + 0.6) * (tabFrame.size.width / 4.0));
    }
    
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10); //圆形大小为10
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(NSUInteger)index
{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(NSUInteger)index
{
    //按照tag值进行移除
    for (UIView *subView in self.subviews)
    {
        if (subView.tag == 888+index)
        {
            [subView removeFromSuperview];
            break;
        }
    }
}

//是否有显示的小红点
- (BOOL)isHadShowBadge:(NSUInteger)index
{
    //按照tag值进行判断
    for (UIView *subView in self.subviews)
    {
        if (subView.tag == 888+index)
        {
            return YES;
        }
    }
    
    return NO;
}

@end

