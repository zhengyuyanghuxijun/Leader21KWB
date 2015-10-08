//
//  HBLeaderUnbindingCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/8.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBLeaderUnbindingCell.h"

#define LABELFONTSIZE 15.0f
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation HBLeaderUnbindingCell

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
    self.headImgView.image = [UIImage imageNamed:@"menu_user_pohoto"];
    self.headImgView.frame = CGRectMake(10, 10, 50, 50);
    [self addSubview:self.headImgView];
    
    //名字
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.frame = CGRectMake(10 + 50 + 10, 5, ScreenWidth, 35);
    self.nameLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self addSubview:self.nameLabel];
    
    //展示名字
    self.displayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + 50 + 10, 35 - 5, ScreenWidth, 35)];
    self.displayNameLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    self.displayNameLabel.textColor = [UIColor blackColor];
    [self addSubview:self.displayNameLabel];
    
    //选择按钮
    self.selectButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 50, (70 - 25)/2, 25, 25)];
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"danxuan-nomal"] forState:UIControlStateNormal];
    [self addSubview:self.selectButton];
    
    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 70 - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    seperatorLine.backgroundColor = [UIColor colorWithHex:0xff8903];
    [self addSubview:seperatorLine];
}

-(void)updateFormData:(NSDictionary *)dic
{
    if ([dic objectForKey:@"name"]) {
        self.nameLabel.text = [dic objectForKey:@"name"];
    }
    
    if ([dic objectForKey:@"display_name"]) {
        self.displayNameLabel.text = [dic objectForKey:@"display_name"];
    }
}

-(void)selectedBtnPressed:(NSString *)pressed
{
    if ([pressed isEqualToString:@"1"]) {
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"danxuan-slected"] forState:UIControlStateNormal];
    }else{
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"danxuan-nomal"] forState:UIControlStateNormal];
    }
}

@end
