//
//  HBWeekWorkCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/11/7.
//  Copyright © 2015年 hxj. All rights reserved.
//

#import "HBWeekWorkCell.h"
#import "HBExamEntity.h"
#import "HBHeaderManager.h"

#define LABELFONTSIZE 14.0f
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation HBWeekWorkCell

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
    self.display_nameLabel.frame = CGRectMake(10 + 50 + 10, 10, 70, 70 - 10 - 10);
    self.display_nameLabel.textAlignment = NSTextAlignmentLeft;
    self.display_nameLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self addSubview:self.display_nameLabel];
    
    //完成标题
    self.submitted_countTitleLabel = [[UILabel alloc] init];
    self.submitted_countTitleLabel.text = @"完成";
    self.submitted_countTitleLabel.frame = CGRectMake(ScreenWidth - 110, 10, 50, 70/2 - 10);
    [self.submitted_countTitleLabel setTextAlignment:NSTextAlignmentCenter];
    self.submitted_countTitleLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self addSubview:self.submitted_countTitleLabel];
    
    //完成内容
    self.submitted_countLabel = [[UILabel alloc] init];
    self.submitted_countLabel.frame = CGRectMake(ScreenWidth - 110, 70/2, 50, 70/2 - 10);
    [self.submitted_countLabel setTextAlignment:NSTextAlignmentCenter];
    self.submitted_countLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self.submitted_countLabel setTextColor:HEXRGBCOLOR(0xff8903)];
    [self addSubview:self.submitted_countLabel];
    
    //总数标题
    self.totalTitleLabel = [[UILabel alloc] init];
    self.totalTitleLabel.text = @"总数";
    self.totalTitleLabel.frame = CGRectMake(ScreenWidth - 70, 10, 50, 70/2 - 10);
    [self.totalTitleLabel setTextAlignment:NSTextAlignmentCenter];
    self.totalTitleLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self addSubview:self.totalTitleLabel];
    
    //总数内容
    self.totalLabel = [[UILabel alloc] init];
    self.totalLabel.frame = CGRectMake(ScreenWidth - 70, 70/2, 50, 70/2 - 10);
    [self.totalLabel setTextAlignment:NSTextAlignmentCenter];
    self.totalLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self.totalLabel setTextColor:HEXRGBCOLOR(0xff8903)];
    [self addSubview:self.totalLabel];
    
    //未布置作业
    self.nonExamLabel = [[UILabel alloc] init];
    self.nonExamLabel.text = @"未布置作业";
    self.nonExamLabel.frame = CGRectMake(ScreenWidth - 110, 10, 100, 70 - 10 - 10);
    [self.nonExamLabel setTextAlignment:NSTextAlignmentCenter];
    self.nonExamLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self.nonExamLabel setTextColor:HEXRGBCOLOR(0xff8903)];
    [self addSubview:self.nonExamLabel];
    
    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 70 - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    seperatorLine.backgroundColor = HEXRGBCOLOR(0xff8903);
    [self addSubview:seperatorLine];
}

-(void)updateFormData:(id)sender
{
    HBExamEntity *examEntity = (HBExamEntity *)sender;
    
    if (examEntity) {
        NSString *headFile = [[HBHeaderManager defaultManager] getAvatarFileByUser:examEntity.name];
        
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
        
        self.display_nameLabel.text = examEntity.display_name;
        
        if (examEntity.total_count > 0) {
            self.nonExamLabel.hidden = YES;
            self.submitted_countTitleLabel.hidden = NO;
            self.submitted_countLabel.hidden = NO;
            self.totalTitleLabel.hidden = NO;
            self.totalLabel.hidden = NO;
            
            self.submitted_countLabel.text = [NSString stringWithFormat:@"%ld", examEntity.submitted_count];
            self.totalLabel.text = [NSString stringWithFormat:@"%ld", examEntity.total_count];
        }else{
            self.nonExamLabel.hidden = NO;
            self.submitted_countTitleLabel.hidden = YES;
            self.submitted_countLabel.hidden = YES;
            self.totalTitleLabel.hidden = YES;
            self.totalLabel.hidden = YES;
        }
    }
}

@end
