//
//  HBReadStatisticalDateCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/18.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HBPushMenuItemDelegate <NSObject>

- (void)pushMenuItem:(NSInteger)booksetId;

@end

@interface HBReadStatisticalDateCell : UITableViewCell

@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIButton *thisWeekButton;
@property (strong, nonatomic) UIButton *bookSetButton;

@property (weak, nonatomic) id<HBPushMenuItemDelegate> delegate;

@end
