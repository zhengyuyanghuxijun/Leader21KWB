//
//  UITabBar+HBExt.h
//  LediKWB
//
//  Created by ChunGuo on 16/1/20.
//  Copyright © 2016年 MERI. All rights reserved.
//

@interface UITabBar (badge)

//显示小红点
- (void)showBadgeOnItemIndex:(NSUInteger)index;

//隐藏小红点
- (void)hideBadgeOnItemIndex:(NSUInteger)index;

//是否有显示的小红点
- (BOOL)isHadShowBadge:(NSUInteger)index;

@end
