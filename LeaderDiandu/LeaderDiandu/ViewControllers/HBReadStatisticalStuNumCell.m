//
//  HBReadStatisticalStuNumCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/18.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBReadStatisticalStuNumCell.h"

@implementation HBReadStatisticalStuNumCell

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
    //titleLabel
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(18, 0, 150, 50);
    self.titleLabel.text = @"阅读人数";
    [self addSubview:self.titleLabel];
    
    //contentLabel
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.frame = CGRectMake(215, 0, 150, 50);
    self.contentLabel.text = @"0 / 0";
    self.contentLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [self addSubview:self.contentLabel];
    
    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    seperatorLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:seperatorLine];
}

@end
