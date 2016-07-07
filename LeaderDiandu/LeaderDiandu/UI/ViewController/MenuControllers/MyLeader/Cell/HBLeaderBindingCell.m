//
//  HBLeaderBindingCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/8.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBLeaderBindingCell.h"

#define LABELFONTSIZE 14.0f
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation HBLeaderBindingCell

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
    //标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(10, 10, ScreenWidth, 35);
    self.titleLabel.textColor = HEXRGBCOLOR(0xff8903);
    [self addSubview:self.titleLabel];
    
    //内容
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, ScreenWidth, 35)];
    self.contentLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self addSubview:self.contentLabel];
    
    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 70 - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    seperatorLine.backgroundColor = HEXRGBCOLOR(0xff8903);
    [self addSubview:seperatorLine];
}

-(void)updateFormData:(NSMutableDictionary *)dic
{
    if ([dic objectForKey:@"title"]) {
        self.titleLabel.text = [dic objectForKey:@"title"];
    }
    
    if ([dic objectForKey:@"content"]) {
        self.contentLabel.text = [dic objectForKey:@"content"];
    }
}

@end
