//
//  HBPayViewControllerMoneyCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/29.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBPayViewControllerMoneyCell.h"

#define KShowDiscount   0

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HBPayViewControllerMoneyCell ()

@property (strong, nonatomic) NSMutableArray *moneyBtnArr;
@property (strong, nonatomic) NSArray *timeArray;
@property (strong, nonatomic) NSArray *moneyArr;
@property (strong, nonatomic) NSArray *discountArr;
@property (strong, nonatomic) NSArray *discountCNArr;
@property (strong, nonatomic) UILabel *discountLabel;
@property (strong, nonatomic) UILabel *moneyLabel;

@end

@implementation HBPayViewControllerMoneyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.moneyBtnArr = [[NSMutableArray alloc] initWithCapacity:1];
        //@[@"10(不打折)", @"30(95折)", @"60(9折)", @"120(85折)", @"240(8折)", @"360(75折)"]
#if KShowDiscount
        self.timeArray = @[@"1月", @"1季", @"半年", @"1年", @"2年", @"3年"];
        self.moneyArr = @[@"12", @"30", @"60", @"118", @"240", @"360"];
        self.discountArr = @[@"1.0", @"0.95", @"0.9", @"0.85", @"0.8", @"0.75"];
        self.discountCNArr = @[@"", @"95折", @"9折", @"85折", @"8折", @"75折"];
#else
        self.timeArray = @[@"1月", @"1季", @"半年", @"1年"];
        self.moneyArr = @[@"12", @"30", @"60", @"118"];
#endif
        [self initUI];
    }
    return self;
}

- (void) initUI
{
    CGFloat width = 76;
    CGFloat height = 108;
    CGFloat marginY = 20;
    CGFloat controlY = marginY;
#if KShowDiscount
    CGFloat margin = (ScreenWidth-width*3) / 4;
#else
    CGFloat margin = (ScreenWidth-width*2) / 3;
#endif
    NSInteger count = [self.timeArray count];
    NSInteger flag = count/2;
    for (NSInteger index = 0; index < count; index++) {
        
        CGFloat controlX = index%flag*width + (index%flag+1)*margin;
        if (index > flag-1) {
            controlY = marginY*2 + height;
        }
        UIButton *moneyBtn = [self createMoneyBtn:CGRectMake(controlX, controlY, width, height) index:index];
        [self addSubview:moneyBtn];
        [self.moneyBtnArr addObject:moneyBtn];
    }
    
    controlY += height+marginY;
    UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, controlY, ScreenWidth, 1)];
    lineLbl.backgroundColor = RGBEQ(239);
    [self addSubview:lineLbl];
    
    controlY += 11;
    CGFloat controlX = margin;
    CGFloat controlH = 20;
    UILabel *paylabel = [[UILabel alloc] init];
    paylabel.frame = CGRectMake(controlX, controlY, 150, controlH);
    paylabel.text = @"应付金额";
    [self addSubview:paylabel];
    
#if KShowDiscount
    self.discountLabel = [[UILabel alloc] init];
    self.discountLabel.frame = CGRectMake(ScreenWidth-80-60, controlY, 60, controlH);
    self.discountLabel.text = @"";
    self.discountLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.discountLabel];
#endif
    
    self.moneyLabel = [[UILabel alloc] init];
    self.moneyLabel.frame = CGRectMake(ScreenWidth-80-20, controlY, 80, controlH);
    self.moneyLabel.text = @"10.0元";
    self.moneyLabel.textColor = KLeaderRGB;
    self.moneyLabel.textAlignment = NSTextAlignmentRight;
    self.moneyLabel.font = [UIFont boldSystemFontOfSize:20];
    [self addSubview:self.moneyLabel];
}

- (UIButton *)createMoneyBtn:(CGRect)frame index:(NSInteger)index
{
    UIButton *moneyBtn = [[UIButton alloc] initWithFrame:frame];
    [moneyBtn setBackgroundImage:[UIImage imageNamed:@"price-normal"] forState:UIControlStateNormal];
    [moneyBtn setBackgroundImage:[UIImage imageNamed:@"price-slected"] forState:UIControlStateSelected];
    [moneyBtn setTag:index];
    [moneyBtn addTarget:self action:@selector(selectMoney:) forControlEvents:UIControlEventTouchUpInside];
    if (0 == index) {
        moneyBtn.selected = YES;
    }
    
    float controlX = 0;
    float controlY = 10;
    float controlW = frame.size.width;
    float controlH = frame.size.height/2-10;
    UILabel *timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    timeLbl.text = self.timeArray[index];
    timeLbl.textColor = [UIColor blackColor];
    timeLbl.textAlignment = NSTextAlignmentCenter;
    [moneyBtn addSubview:timeLbl];
    
    controlY += controlH;
    UILabel *moneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    moneyLbl.text = self.moneyArr[index];
    moneyLbl.textColor = [UIColor blackColor];
    moneyLbl.textAlignment = NSTextAlignmentCenter;
    [moneyBtn addSubview:moneyLbl];
    
#if KShowDiscount
    NSString *text = self.discountCNArr[index];
    if ([text length] > 0) {
        controlW = 34;
        controlH = 20;
        controlX = frame.size.width-controlW/2;
        controlY = 0-controlH/2;
        UIImageView *imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
        imgBg.image = [UIImage imageNamed:@"pay-icn-onsale"];
        [moneyBtn addSubview:imgBg];
        
        UILabel *label = [[UILabel alloc] initWithFrame:imgBg.bounds];
        label.text = text;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [imgBg addSubview:label];
    }
#endif
    
    return moneyBtn;
}

-(void)selectMoney:(id)sender
{
    UIButton *moneyBtn = (UIButton *)sender;
    
    for (UIButton *btn in self.moneyBtnArr) {
        if (btn.tag == moneyBtn.tag) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    
    NSInteger index = moneyBtn.tag;
#if KShowDiscount
    self.discountLabel.text = [self.discountCNArr objectAtIndex:index];
#endif
    
    NSString *moneyStr = [self.moneyArr objectAtIndex:index];
    NSInteger money = [moneyStr integerValue];
    NSString *discountStr = [self.discountArr objectAtIndex:index];
    CGFloat discount = [discountStr floatValue];
    CGFloat result = 0;
    if (self.discountArr) {
        result = money * discount;
    } else {
        result = money;
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%.1f%@", result, @"元"];
    
    NSInteger months = money / 10;
    if (self.delegate) {
        [self.delegate HBPaySelectMonth:months money:result];
    }
}

@end
