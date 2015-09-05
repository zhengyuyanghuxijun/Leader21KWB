//
//  HBGridItemView.h
//  HBGridView
//  Description: 需要支持点击操作
//  Created by wxj wu on 12-7-23.
//  Copyright (c) 2012年 tt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBGridItemView : UIView
{
    id _target;
    SEL _action;
}

- (void)setTarget:(id)target action:(SEL)action;

@end
