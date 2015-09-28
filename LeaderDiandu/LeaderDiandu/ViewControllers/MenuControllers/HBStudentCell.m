//
//  HBStudentCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/13.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBStudentCell.h"
#import "HBStudentEntity.h"

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
    self.cellHeadImage.image = [UIImage imageNamed:@"menu_user_pohoto"];
    self.cellHeadImage.frame = CGRectMake(10, 10, 50, 70 - 10 - 10);
    [self addSubview:self.cellHeadImage];
    
    //姓名
    self.cellName = [[UILabel alloc] init];
    self.cellName.frame = CGRectMake(10 + 50 + 10, 10, 70, 70/2 - 10);
    [self addSubview:self.cellName];
    
    //用户类型
    self.cellStuType = [[UILabel alloc] init];
    self.cellStuType.frame = CGRectMake(10 + 50 + 10 + 70 + 10, 10, 110, 70/2 - 10);
    [self addSubview:self.cellStuType];
    
    //用户所属分组
    self.cellGroup = [[UILabel alloc] init];
    self.cellGroup.frame = CGRectMake(10 + 50 + 10, 70/2, 150, 70/2 - 10);
    [self addSubview:self.cellGroup];
    
    //解绑按钮
    self.cellUnbundlingBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 100, (70 - 30)/2, 90, 30)];
    [self.cellUnbundlingBtn setBackgroundImage:[UIImage imageNamed:@"user_button"] forState:UIControlStateNormal];
    [self.cellUnbundlingBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
    [self.cellUnbundlingBtn addTarget:self action:@selector(unbundlingBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cellUnbundlingBtn];
}

-(void)updateFormData:(id)sender
{
    HBStudentEntity *studentEntity = (HBStudentEntity *)sender;

    if (studentEntity) {
        self.cellName.text = studentEntity.displayName;
        
        //1：普通用户 2：VIP用户 3：VIP过期用户
        if(1 == studentEntity.accountStatus){
            self.cellStuType.text = @"普通用户";
        }else if (2 == studentEntity.accountStatus){
            self.cellStuType.text = @"VIP用户";
        }else{
            self.cellStuType.text = @"VIP过期用户";
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
