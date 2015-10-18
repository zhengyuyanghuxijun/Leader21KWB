//
//  HBReadStatisticalContentCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/18.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBReadStatisticalContentCell : UITableViewCell

@property (strong, nonatomic) UILabel *totalReadCountLabel; //阅读总量
@property (strong, nonatomic) UILabel *perReadCountLabel;   //人均阅读量
@property (strong, nonatomic) UILabel *totalReadTimeLabel;  //阅读总时长
@property (strong, nonatomic) UILabel *perReadTimeLabel;    //人均阅读时长
@property (strong, nonatomic) UILabel *perBookReadLabel;    //单书阅读频度

@end
