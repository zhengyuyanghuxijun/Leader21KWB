//
//  HBSetStuGroupCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/16.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBSetStuGroupCell.h"
#import "HBHeaderManager.h"

#define BUTTONFONTSIZE 15.0f

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
    //    [self addSubview:self.cellBgImage];
    
    //群组图标
    self.cellGroupImage = [[UIImageView alloc] init];
    self.cellGroupImage.image = [UIImage imageNamed:@"icn-group"];
    self.cellGroupImage.frame = CGRectMake(10, 10 + 18, 17, 14);
    [self addSubview:self.cellGroupImage];
    
    //头像
    self.cellHeadImage = [[UIImageView alloc] init];
    self.cellHeadImage.image = [UIImage imageNamed:@"menu_user_pohoto"];
    self.cellHeadImage.frame = CGRectMake(self.cellGroupImage.frame.origin.x + self.cellGroupImage.frame.size.width + 10, 10, 50, 50);
    [self addSubview:self.cellHeadImage];
    
    //学生姓名
    self.cellName = [[UILabel alloc] init];
    self.cellName.frame = CGRectMake(self.cellHeadImage.frame.origin.x + self.cellHeadImage.frame.size.width + 10, 10, 200, 50);
    [self addSubview:self.cellName];
    
    //退群组按钮
    self.cellQuitGroupBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, (70 - 30)/2, 40, 25)];
    [self.cellQuitGroupBtn setBackgroundImage:[UIImage imageNamed:@"test-btn-choose-normal"] forState:UIControlStateNormal];
    [self.cellQuitGroupBtn setTitle:@"退群" forState:UIControlStateNormal];
    [self.cellQuitGroupBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cellQuitGroupBtn addTarget:self action:@selector(quitGroupBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    self.cellQuitGroupBtn.titleLabel.font = [UIFont boldSystemFontOfSize:BUTTONFONTSIZE];
    [self addSubview:self.cellQuitGroupBtn];
    
    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 70 - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    seperatorLine.backgroundColor = [UIColor colorWithHex:0xff8903];
    [self addSubview:seperatorLine];
}

-(void)updateFormData:(HBStudentEntity *)aStudentEntity
{
    
    NSString *headFile = [[HBHeaderManager defaultManager] getAvatarFileByUser:aStudentEntity.name];
    
    if (headFile) {
        //设置显示圆形头像
        self.cellHeadImage.layer.cornerRadius = 50/2;
        self.cellHeadImage.clipsToBounds = YES;
        self.cellHeadImage.image = [UIImage imageWithContentsOfFile:headFile];
        if (self.cellHeadImage.image == nil) {
            self.cellHeadImage.image = [UIImage imageNamed:@"menu_user_pohoto"];
        }
    } else {
        self.cellHeadImage.image = [UIImage imageNamed:@"menu_user_pohoto"];
    }
    
    self.studentEntity = aStudentEntity;
    self.cellName.text = self.studentEntity.displayName;
}

-(void)quitGroupBtnPressed
{
    [self.delegate quitGroupBtnPressed:self.studentEntity];
}

@end
