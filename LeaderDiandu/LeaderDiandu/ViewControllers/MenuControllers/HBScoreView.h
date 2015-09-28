//
//  HBScoreView.h
//  LeaderDiandu
//
//  Created by xijun on 15/9/28.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBScoreView : UIView

- (id)initWithFrame:(CGRect)frame score:(NSInteger)score;

@property (nonatomic, assign)NSInteger score;
@property (nonatomic, strong)UIButton *finishBtn;

@end
