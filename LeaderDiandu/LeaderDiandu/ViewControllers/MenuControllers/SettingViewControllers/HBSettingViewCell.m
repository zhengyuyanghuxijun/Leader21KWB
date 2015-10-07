//
//  HBSettingViewCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/7.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBSettingViewCell.h"

#define LABELFONTSIZE 14.0f

@implementation HBSettingViewCell

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
    //标题内容
    self.mainLabel = [[UILabel alloc] init];
    self.mainLabel.frame = CGRectMake(15, 10, 200, 60/2);
    [self addSubview:self.mainLabel];
    
    //描述内容
    self.describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 60/2 + 5, 300, 70/2 - 5)];
    self.describeLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    self.describeLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.describeLabel];
    
//    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 70 - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
//    seperatorLine.backgroundColor = [UIColor colorWithHex:0xff8903];
//    [self addSubview:seperatorLine];
}

@end
