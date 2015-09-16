//
//  HBSetStuOtherCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/16.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBSetStuOtherCell.h"

@implementation HBSetStuOtherCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.checked = NO;
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
    
    //选择按钮
    self.cellselectedBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, (70 - 30)/2, 30, 30)];
    [self.cellselectedBtn setBackgroundImage:[UIImage imageNamed:@"selected_off"] forState:UIControlStateNormal];
    [self.cellselectedBtn addTarget:self action:@selector(selectedBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cellselectedBtn];
}

-(void)updateFormData:(HBStudentEntity *)aStudentEntity;
{
    self.studentEntity = aStudentEntity;
    self.cellName.text = self.studentEntity.displayName;
}

-(void)selectedBtnPressed
{
    if (self.checked) {
        self.checked = NO;
        [self.cellselectedBtn setBackgroundImage:[UIImage imageNamed:@"selected_off"] forState:UIControlStateNormal];
    }else{
        self.checked = YES;
        [self.cellselectedBtn setBackgroundImage:[UIImage imageNamed:@"selected_on"] forState:UIControlStateNormal];
    }
    
    [self.delegate joinGroupBtnPressed:self.studentEntity checked:self.checked];
}

@end
