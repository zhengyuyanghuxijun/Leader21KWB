//
//  HBStudentCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/13.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBStudentCell.h"
#import "HBStudentEntity.h"
#import "HBHeaderManager.h"

#define LABELFONTSIZE 14.0f
#define BUTTONFONTSIZE 15.0f

@implementation HBStudentCell

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
    //头像
    self.cellHeadImage = [[UIImageView alloc] init];
//    self.cellHeadImage.image = [UIImage imageNamed:@"menu_user_pohoto"];
    self.cellHeadImage.frame = CGRectMake(10, 10, 50, 70 - 10 - 10);
    [self addSubview:self.cellHeadImage];
    
    //姓名
    self.cellName = [[UILabel alloc] init];
    self.cellName.frame = CGRectMake(10 + 50 + 10, 10, 100, 70/2 - 10);
    self.cellName.textAlignment = NSTextAlignmentLeft;
    self.cellName.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self addSubview:self.cellName];
    
    //用户类型
    self.cellStuTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 + 50 + 10, 70/2, 60, 70/2 - 15)];
    self.cellStuTypeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.cellStuTypeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self addSubview:self.cellStuTypeBtn];
    
    //群组图标
    self.cellGroupImage = [[UIImageView alloc] init];
    self.cellGroupImage.image = [UIImage imageNamed:@"icn-group"];
    self.cellGroupImage.frame = CGRectMake(self.cellStuTypeBtn.frame.origin.x + 60 + 7, 70/2 + 3, 17, 14);
    [self addSubview:self.cellGroupImage];
    
    //用户所属分组
    self.cellGroup = [[UILabel alloc] init];
    self.cellGroup.frame = CGRectMake(self.cellGroupImage.frame.origin.x + self.cellGroupImage.frame.size.width + 7, 70/2 - 3, 150, 70/2 - 10);
    self.cellGroup.textAlignment = NSTextAlignmentLeft;
    self.cellGroup.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    self.cellGroup.textColor = HEXRGBCOLOR(0xff8903);
    [self addSubview:self.cellGroup];
    
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
    seperatorLine.backgroundColor = HEXRGBCOLOR(0xff8903);
    [self addSubview:seperatorLine];
}

-(void)updateFormData:(id)sender
{
    HBStudentEntity *studentEntity = (HBStudentEntity *)sender;

    if (studentEntity) {
        
        NSString *headFile = [[HBHeaderManager defaultManager] getAvatarFileByUser:studentEntity.name];
        
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
        
        self.cellName.text = studentEntity.displayName;
        
        //1：普通用户 2：VIP用户 3：VIP过期用户
        if(1 == studentEntity.accountStatus){
            [self.cellStuTypeBtn setTitle:@"普通用户" forState:UIControlStateNormal];
            [self.cellStuTypeBtn setBackgroundImage:[UIImage imageNamed:@"studentmanage-bg-normal-user"] forState:UIControlStateNormal];
        }else if (2 == studentEntity.accountStatus){
            [self.cellStuTypeBtn setTitle:@"VIP会员" forState:UIControlStateNormal];
            [self.cellStuTypeBtn setBackgroundImage:[UIImage imageNamed:@"studentmanage-bg-vip-user"] forState:UIControlStateNormal];
        }else{
            [self.cellStuTypeBtn setTitle:@"VIP过期" forState:UIControlStateNormal];
            [self.cellStuTypeBtn setBackgroundImage:[UIImage imageNamed:@"studentmanage-bg-vipover-user"] forState:UIControlStateNormal];
        }
        
        if ([studentEntity.className isEqualToString:@""]) {
            self.cellGroup.text = @"无";
        }else{
            self.cellGroup.text = studentEntity.className;
        }
        self.studentID = studentEntity.studentId;
    }
}

- (void)unbundlingBtnPressed
{
    [self.delegate unbundlingBtnPressed:self.studentID];
}

@end
