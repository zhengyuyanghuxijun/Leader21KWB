//
//  HBPayViewControllerMoneyCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/29.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBPayViewControllerMoneyCell : UITableViewCell

@property (strong, nonatomic) NSMutableArray *moneyBtnArr;
@property (strong, nonatomic) NSArray *moneyArr;
@property (strong, nonatomic) NSArray *discountArr;
@property (strong, nonatomic) NSArray *discountCNArr;
@property (strong, nonatomic) UILabel *discountLabel;
@property (strong, nonatomic) UILabel *moneyLabel;

@end
