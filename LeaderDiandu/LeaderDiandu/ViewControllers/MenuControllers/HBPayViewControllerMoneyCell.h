//
//  HBPayViewControllerMoneyCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/29.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HBPayMoneyCellDelegate <NSObject>

- (void)HBPaySelectMonth:(NSInteger)months money:(CGFloat)money;

@end

@interface HBPayViewControllerMoneyCell : UITableViewCell

@property (nonatomic, assign)id<HBPayMoneyCellDelegate> delegate;

@end
