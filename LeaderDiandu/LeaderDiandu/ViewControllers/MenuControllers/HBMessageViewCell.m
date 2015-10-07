//
//  HBMessageViewCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/7.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBMessageViewCell.h"
#import "HBSystemMsgEntity.h"

#define LABELFONTSIZE 14.0f
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation HBMessageViewCell

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
    //图标
    self.msgIconImg = [[UIImageView alloc] init];
    self.msgIconImg.image = [UIImage imageNamed:@"menu_user_pohoto"];
    self.msgIconImg.frame = CGRectMake(10, 20, 30, 30);
    [self addSubview:self.msgIconImg];
    
    //内容
    self.bodyLabel = [[UILabel alloc] init];
    self.bodyLabel.frame = CGRectMake(10 + 30 + 10, (70 - 25)/2, ScreenWidth - 10 - 30 - 10, 25);
    self.bodyLabel.textAlignment = NSTextAlignmentLeft;
    self.bodyLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self addSubview:self.bodyLabel];
    
    //时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 100, 70/2 + 5, 90, 70/2)];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    self.timeLabel.textColor = [UIColor colorWithHex:0xff8903];
    [self addSubview:self.timeLabel];
    
    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 70 - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    seperatorLine.backgroundColor = [UIColor colorWithHex:0xff8903];
    [self addSubview:seperatorLine];
}

-(void)updateFormData:(id)sender
{
    HBSystemMsgEntity *msgEntity = (HBSystemMsgEntity *)sender;
    
    if (msgEntity) {
        self.bodyLabel.text = msgEntity.body;
        self.timeLabel.text = msgEntity.created_time;
    }
}

@end
