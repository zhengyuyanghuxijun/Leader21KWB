//
//  HBSetStuGroupCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/16.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBSetStuGroupCell : UITableViewCell

@property (strong, nonatomic) UIImageView * cellBgImage;
@property (strong, nonatomic) UILabel *     cellName;
@property (strong, nonatomic) UIButton *    cellQuitGroupBtn;

-(void)updateFormData:(NSString *)stuName;

@end
