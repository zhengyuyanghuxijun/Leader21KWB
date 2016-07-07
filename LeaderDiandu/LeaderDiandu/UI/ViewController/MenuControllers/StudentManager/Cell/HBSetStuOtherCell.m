//
//  HBSetStuOtherCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/16.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBSetStuOtherCell.h"
#import "HBHeaderManager.h"

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
    //    [self addSubview:self.cellBgImage];
    
    //群组图标
    self.cellGroupImage = [[UIImageView alloc] init];
    self.cellGroupImage.image = [UIImage imageNamed:@"studentmagage-icn-group"];
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
    
    //选择按钮
    self.cellselectedBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 70, 0, 70, 70)];
    [self.cellselectedBtn addTarget:self action:@selector(selectedBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cellselectedBtn];
    
    self.cellselectedImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected_off"]];
    self.cellselectedImgView.frame = CGRectMake((70-20)/2, (70-20)/2, 20, 20);
    [self.cellselectedBtn addSubview:self.cellselectedImgView];
    
    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 70 - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    seperatorLine.backgroundColor = HEXRGBCOLOR(0xff8903);
    [self addSubview:seperatorLine];
}

-(void)updateFormData:(HBStudentEntity *)aStudentEntity;
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

-(void)selectedBtnPressed
{
    if (self.checked) {
        self.checked = NO;
        self.cellselectedImgView.image = [UIImage imageNamed:@"selected_off"];
    }else{
        self.checked = YES;
        self.cellselectedImgView.image = [UIImage imageNamed:@"selected_on"];
    }
    
    [self.delegate joinGroupBtnPressed:self.studentEntity checked:self.checked];
}

@end
