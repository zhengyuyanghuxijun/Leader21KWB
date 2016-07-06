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
    
    //contentStuNumLabel
    self.contentStuNumLabel = [[UILabel alloc] init];
    self.contentStuNumLabel.frame = CGRectMake(195, 0, 30, 50);
    self.contentStuNumLabel.text = @"0";
    self.contentStuNumLabel.textAlignment = NSTextAlignmentRight;
    self.contentStuNumLabel.textColor = HEXRGBCOLOR(0x1E90FF);
    self.contentStuNumLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [self addSubview:self.contentStuNumLabel];
    
    //contentAllNumLabel
    self.contentAllNumLabel = [[UILabel alloc] init];
    self.contentAllNumLabel.frame = CGRectMake(225, 0, 150, 50);
    self.contentAllNumLabel.text = @" / 0";
    self.contentAllNumLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [self addSubview:self.contentAllNumLabel];
    
    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    seperatorLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:seperatorLine];
}

@end
