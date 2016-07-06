//
//  HBBillViewControllerCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/12.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBBillViewControllerCell.h"
#import "HBBillEntity.h"

#define LABELFONTSIZE   14.0f
#define KCellHeight     80

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation HBBillViewControllerCell

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
    //支付种类图标
    self.iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, (KCellHeight - 30)/2, 30, 30)];
    [self addSubview:self.iconImg];
    
    //标题
    self.subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + 30 + 10, 5, 200, KCellHeight/2)];
    [self addSubview:self.subjectLabel];
    
    //支付状态
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 100, 5, 100 - 10, KCellHeight/2)];
    self.statusLabel.textAlignment = NSTextAlignmentRight;
    self.statusLabel.textColor = HEXRGBCOLOR(0xff8903);
    [self addSubview:self.statusLabel];
    
    //内容
    self.bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + 30 + 10, KCellHeight/2-10, 250, KCellHeight/2)];
    self.bodyLabel.font = [UIFont systemFontOfSize:LABELFONTSIZE];
    self.bodyLabel.numberOfLines = 0;
    [self addSubview:self.bodyLabel];
    
    //时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 100, KCellHeight/2 + 35/2, 100 - 10, 35/2)];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self addSubview:self.timeLabel];
    
    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, KCellHeight - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    seperatorLine.backgroundColor = HEXRGBCOLOR(0xff8903);
    [self addSubview:seperatorLine];
}

-(void)updateFormData:(id)sender
{
    HBBillEntity *billEntity = (HBBillEntity *)sender;
    
    if (billEntity) {
        self.subjectLabel.text = billEntity.subject;
        self.timeLabel.text = billEntity.created_time;
        
        //0-未支付；1-已支付
        if ([billEntity.status isEqualToString:@"1"]) {
            self.statusLabel.text = @"已支付";
        }else{
            self.statusLabel.text = @"未支付";
        }

        //1-支付宝；2-微信支付；3-VIP码支付
        NSInteger type = [billEntity.type integerValue];
        if (type == 1) {
            self.bodyLabel.text = [NSString stringWithFormat:@"%@，共需支付%@元", [self getBillBody:billEntity.body], billEntity.total_fee];
            self.iconImg.image = [UIImage imageNamed:@"pay-icn-alipay"];
        } else if (type == 2){
            self.bodyLabel.text = [NSString stringWithFormat:@"%@，共需支付%@元", [self getBillBody:billEntity.body], billEntity.total_fee];
            self.iconImg.image = [UIImage imageNamed:@"pay-icn-wechat"];
        } else if (type == 3) {
            self.subjectLabel.text = @"VIP充值";
            self.bodyLabel.text = [NSString stringWithFormat:@"使用VIP充值码获得VIP权限，共需支付0元"];
            self.iconImg.image = [UIImage imageNamed:@"pay-icn-voucher"];
        } else {
            self.bodyLabel.text = [NSString stringWithFormat:@"共需支付%@元", billEntity.total_fee];
            self.iconImg.image = [UIImage imageNamed:@"pay-normal"];
        }
    }
}

- (NSString *)getBillBody:(NSString *)body
{
    NSRange range = [body rangeOfString:@","];
    if (range.length > 0) {
        return [body substringToIndex:range.location];
    } else {
        return body;
    }
}

@end
