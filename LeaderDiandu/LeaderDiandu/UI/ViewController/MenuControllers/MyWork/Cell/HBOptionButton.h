//
//  HBOptionButton.h
//  LeaderDiandu
//
//  Created by xijun on 15/10/12.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HBOptionButtonDelegate <NSObject>

- (void)setOptionButtonSelected:(id)sender;

@end

@interface HBOptionButton : UIButton

@property (nonatomic, assign)id<HBOptionButtonDelegate> delegate;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
