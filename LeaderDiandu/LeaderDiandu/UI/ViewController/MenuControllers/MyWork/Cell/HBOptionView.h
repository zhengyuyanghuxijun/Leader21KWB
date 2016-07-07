//
//  HBOptionView.h
//  LeaderDiandu
//
//  Created by xijun on 15/9/25.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBOptionView;

@protocol HBOptionViewDelegate <NSObject>

- (void)setOptionViewSelected:(HBOptionView *)optionView;

@end

@interface HBOptionView : UIView

@property (nonatomic, assign)id<HBOptionViewDelegate> delegate;
@property (nonatomic, getter=isSelected)BOOL selected;
@property (nonatomic, strong)UIImageView *cover;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image;

@end
