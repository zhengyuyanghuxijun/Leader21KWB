//
//  HBReadStatisticalLogoCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/18.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBReadStatisticalLogoCell.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation HBReadStatisticalLogoCell

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
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, ScreenWidth, 120);
    bgView.backgroundColor = [UIColor colorWithHex:0x1E90FF];
    [self addSubview:bgView];
    
    //图标
    self.LogoImg = [[UIImageView alloc] init];
    self.LogoImg.image = [UIImage imageNamed:@"flower"];
    self.LogoImg.frame = CGRectMake((ScreenWidth - 90)/2, (120 - 90)/2, 90, 90);
    [self addSubview:self.LogoImg];
    
    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 120 - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    seperatorLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:seperatorLine];
}

@end
