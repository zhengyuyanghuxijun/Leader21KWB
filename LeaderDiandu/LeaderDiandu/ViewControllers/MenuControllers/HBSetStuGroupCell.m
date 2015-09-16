//
//  HBSetStuGroupCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/16.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBSetStuGroupCell.h"

@implementation HBSetStuGroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (void) initUI
{
    //背景图片
    self.cellBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width - 10 - 10, 70 - 5 - 5)];
    self.cellBgImage.image = [UIImage imageNamed:@"StuGroupCell_Bg"];
    [self addSubview:self.cellBgImage];
    
    //学生姓名
    self.cellName = [[UILabel alloc] init];
    self.cellName.frame = CGRectMake(20, 10, 200, 50);
    [self addSubview:self.cellName];
    
    //退群组按钮
    self.cellQuitGroupBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 110, (70 - 30)/2, 90, 30)];
    [self.cellQuitGroupBtn setBackgroundImage:[UIImage imageNamed:@"user_button"] forState:UIControlStateNormal];
    [self.cellQuitGroupBtn setTitle:@"退群组" forState:UIControlStateNormal];
    [self.cellQuitGroupBtn addTarget:self action:@selector(quitGroupBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cellQuitGroupBtn];
}

-(void)updateFormData:(id)stuName
{
    self.cellName.text = stuName;
}

-(void)quitGroupBtnPressed
{
    
}

@end
