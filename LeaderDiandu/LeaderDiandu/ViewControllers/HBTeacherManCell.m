//
//  HBTeacherManCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/25.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBTeacherManCell.h"
#import "HBTeacherEntity.h"
#import "HBHeaderManager.h"

#define LABELFONTSIZE 14.0f
#define BUTTONFONTSIZE 15.0f

@implementation HBTeacherManCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    //头像
    self.headImgView = [[UIImageView alloc] init];
    self.headImgView.frame = CGRectMake(10, 10, 50, 70 - 10 - 10);
    [self addSubview:self.headImgView];
    
    //姓名
    self.display_nameLabel = [[UILabel alloc] init];
    self.display_nameLabel.frame = CGRectMake(10 + 50 + 10, 10, 70, 70/2 - 10);
    self.display_nameLabel.textAlignment = NSTextAlignmentLeft;
    self.display_nameLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self addSubview:self.display_nameLabel];
    
    //时间
    self.associate_timeLabel = [[UILabel alloc] init];
    self.associate_timeLabel.frame = CGRectMake(self.display_nameLabel.frame.origin.x + self.display_nameLabel.frame.size.width + 10, 10, 100, 70/2 - 10);
    self.associate_timeLabel.textAlignment = NSTextAlignmentLeft;
    self.associate_timeLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self.associate_timeLabel setTextColor:[UIColor colorWithHex:0xff8903]];
    [self addSubview:self.associate_timeLabel];
    
    //学生总数
    self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + 50 + 10, 70/2, 70, 70/2 - 10)];
    self.totalLabel.textAlignment = NSTextAlignmentCenter;
    self.totalLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self.totalLabel setTextColor:[UIColor colorWithHex:0xff8903]];
    [self addSubview:self.totalLabel];
    
    //VIP用户
    self.vipLabel = [[UILabel alloc] init];
    self.vipLabel.frame = CGRectMake(self.associate_timeLabel.frame.origin.x, 70/2, 100, 70/2 - 10);
    self.vipLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self.vipLabel setTextColor:[UIColor colorWithHex:0xff8903]];
    [self addSubview:self.vipLabel];
    
    //解绑按钮
    self.cellUnbundlingBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 80, (70 - 25)/2, 70, 25)];
    [self.cellUnbundlingBtn setBackgroundImage:[UIImage imageNamed:@"test-btn-choose-normal"] forState:UIControlStateNormal];
    [self.cellUnbundlingBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
    [self.cellUnbundlingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cellUnbundlingBtn addTarget:self action:@selector(unbundlingBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    self.cellUnbundlingBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.cellUnbundlingBtn.titleLabel.font = [UIFont boldSystemFontOfSize:BUTTONFONTSIZE];
    [self addSubview:self.cellUnbundlingBtn];
    
    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 70 - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    seperatorLine.backgroundColor = [UIColor colorWithHex:0xff8903];
    [self addSubview:seperatorLine];
}

-(void)unbundlingBtnPressed
{
    
}

-(void)updateFormData:(id)sender
{
    HBTeacherEntity *teacherEntity = (HBTeacherEntity *)sender;
    
    if (teacherEntity) {
        NSString *headFile = [[HBHeaderManager defaultManager] getAvatarFileByUser:teacherEntity.name];
        
        if (headFile) {
            //设置显示圆形头像
            self.headImgView.layer.cornerRadius = 50/2;
            self.headImgView.clipsToBounds = YES;
            self.headImgView.image = [UIImage imageWithContentsOfFile:headFile];
            if (self.headImgView.image == nil) {
                self.headImgView.image = [UIImage imageNamed:@"menu_user_pohoto"];
            }
        } else {
            self.headImgView.image = [UIImage imageNamed:@"menu_user_pohoto"];
        }
        
        self.display_nameLabel.text = teacherEntity.display_name;
        self.associate_timeLabel.text = teacherEntity.associate_time;
        self.totalLabel.text = [NSString stringWithFormat:@"%@%ld", @"学生总数:", teacherEntity.total];
        self.vipLabel.text = [NSString stringWithFormat:@"%@%ld", @"VIP用户:", teacherEntity.vip];
    }
}

@end
