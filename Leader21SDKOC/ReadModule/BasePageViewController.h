//
//  BasePageViewController.h
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-11.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BasePageViewControllerDelegate

- (void)pageViewControllerTap:(CGPoint)touchPoint;

@end

@interface BasePageViewController : UIPageViewController

@property (nonatomic, weak) NSObject<BasePageViewControllerDelegate> *aDelegate;

@end
