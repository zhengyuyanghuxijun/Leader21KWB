//
//  HBMyWorkView.h
//  LeaderDiandu
//
//  Created by xijun on 15/9/20.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBTestWorkManager;

@protocol HBMyWorkViewDelegate <NSObject>

- (void)onTouchFinishedButton;

@end

@interface HBMyWorkView : UIView

@property (nonatomic, strong)HBTestWorkManager *workManager;
@property (nonatomic) id<HBMyWorkViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;

- (void)updateData:(NSDictionary *)dict;

@end
