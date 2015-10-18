//
//  HBReadStatisticalContentCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/18.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBReadStatisticalContentCell.h"

#define LABELFONTSIZE 22.0f
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation HBReadStatisticalContentCell

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
    //阅读总量
    UILabel *totalReadCountTitleLabel = [[UILabel alloc] init];
    totalReadCountTitleLabel = [[UILabel alloc] init];
    totalReadCountTitleLabel.frame = CGRectMake(0, 20, ScreenWidth/2, 50);
    totalReadCountTitleLabel.text = @"阅读总量";
    totalReadCountTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:totalReadCountTitleLabel];
    
    //阅读总量具体内容
    self.totalReadCountLabel = [[UILabel alloc] init];
    self.totalReadCountLabel.frame = CGRectMake(0, 50, ScreenWidth/2, 50);
    self.totalReadCountLabel.text = @"          0     次";
    self.totalReadCountLabel.textColor = [UIColor colorWithHex:0x1E90FF];
    self.totalReadCountLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    self.totalReadCountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.totalReadCountLabel];
    
    //阅读总时长
    UILabel *totalReadTimeLabel = [[UILabel alloc] init];
    totalReadTimeLabel = [[UILabel alloc] init];
    totalReadTimeLabel.frame = CGRectMake(ScreenWidth/2, 20, ScreenWidth/2, 50);
    totalReadTimeLabel.text = @"阅读总时长";
    totalReadTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:totalReadTimeLabel];
    
    //阅读总时长具体内容
    self.totalReadTimeLabel = [[UILabel alloc] init];
    self.totalReadTimeLabel.frame = CGRectMake(ScreenWidth/2, 50, ScreenWidth/2, 50);
    self.totalReadTimeLabel.text = @"          0     分钟";
    self.totalReadTimeLabel.textColor = [UIColor colorWithHex:0x1E90FF];
    self.totalReadTimeLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    self.totalReadTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.totalReadTimeLabel];
    
    //人均阅读量
    UILabel *perReadCountLabel = [[UILabel alloc] init];
    perReadCountLabel = [[UILabel alloc] init];
    perReadCountLabel.frame = CGRectMake(0, 20 + 100, ScreenWidth/2, 50);
    perReadCountLabel.text = @"人均阅读量";
    perReadCountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:perReadCountLabel];
    
    //人均阅读量具体内容
    self.perReadCountLabel = [[UILabel alloc] init];
    self.perReadCountLabel.frame = CGRectMake(0, 50 + 100, ScreenWidth/2, 50);
    self.perReadCountLabel.text = @"          0     次";
    self.perReadCountLabel.textColor = [UIColor colorWithHex:0x1E90FF];
    self.perReadCountLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    self.perReadCountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.perReadCountLabel];
    
    //人均阅读时长
    UILabel *perReadTimeLabel = [[UILabel alloc] init];
    perReadTimeLabel = [[UILabel alloc] init];
    perReadTimeLabel.frame = CGRectMake(ScreenWidth/2, 20 + 100, ScreenWidth/2, 50);
    perReadTimeLabel.text = @"人均阅读时长";
    perReadTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:perReadTimeLabel];
    
    //人均阅读时长具体内容
    self.perReadTimeLabel = [[UILabel alloc] init];
    self.perReadTimeLabel.frame = CGRectMake(ScreenWidth/2, 50 + 100, ScreenWidth/2, 50);
    self.perReadTimeLabel.text = @"          0     分钟";
    self.perReadTimeLabel.textColor = [UIColor colorWithHex:0x1E90FF];
    self.perReadTimeLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    self.perReadTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.perReadTimeLabel];
    
    //单书阅读频度
    UILabel *perBookReadLabel = [[UILabel alloc] init];
    perBookReadLabel = [[UILabel alloc] init];
    perBookReadLabel.frame = CGRectMake(0, 20 + 200, ScreenWidth/2, 50);
    perBookReadLabel.text = @"单书阅读频度";
    perBookReadLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:perBookReadLabel];
    
    //单书阅读频度具体内容
    self.perBookReadLabel = [[UILabel alloc] init];
    self.perBookReadLabel.frame = CGRectMake(0, 50 + 200, ScreenWidth/2, 50);
    self.perBookReadLabel.text = @"          0     次";
    self.perBookReadLabel.textColor = [UIColor colorWithHex:0x1E90FF];
    self.perBookReadLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    self.perBookReadLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.perBookReadLabel];
}

@end
