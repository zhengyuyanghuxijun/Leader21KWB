//
//  HBPayViewControllerMoneyCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/29.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBPayViewControllerMoneyCell.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation HBPayViewControllerMoneyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.moneyBtnArr = [[NSMutableArray alloc] initWithCapacity:1];
        //@[@"10(不打折)", @"30(95折)", @"60(9折)", @"120(85折)", @"240(8折)", @"360(75折)"]
        self.moneyArr = @[@"10", @"30", @"60", @"120", @"240", @"360"];
        self.discountArr = @[@"1.0", @"0.95", @"0.9", @"0.85", @"0.8", @"0.75"];
        self.discountCNArr = @[@"", @"95折", @"9折", @"85折", @"8折", @"75折"];
        [self initUI];
    }
    return self;
}

- (void) initUI
{
    for (NSInteger index = 0; index < 6; index++) {
        
        CGFloat y = 0;
        if (index > 2) {
            y += 200/2;
        }
        
        UIButton *moneyBtn = [[UIButton alloc] initWithFrame:CGRectMake(index%3 * ScreenWidth/3, y, ScreenWidth/3, 200/2)];
        [moneyBtn setTitle:[self.moneyArr objectAtIndex:index] forState:UIControlStateNormal];
        [moneyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [moneyBtn setBackgroundImage:[UIImage imageNamed:@"test-line-chooseimg-press"] forState:UIControlStateNormal];
        [moneyBtn setTag:index];
        [moneyBtn addTarget:self action:@selector(selectMoney:) forControlEvents:UIControlEventTouchUpInside];
        
        if (0 == index) {
            [moneyBtn setBackgroundColor:[UIColor lightGrayColor]];
        }else{
            [moneyBtn setBackgroundColor:[UIColor whiteColor]];
        }
        
        [self addSubview:moneyBtn];
        
        [self.moneyBtnArr addObject:moneyBtn];
        
    }
    
    UILabel *paylabel = [[UILabel alloc] init];
    paylabel.frame = CGRectMake(10, 200, 150, 50);
    paylabel.text = @"应付金额";
    [self addSubview:paylabel];
    
    self.discountLabel = [[UILabel alloc] init];
    self.discountLabel.frame = CGRectMake(ScreenWidth - 70 - 45, 200, 60, 50);
    self.discountLabel.text = @"";
    
    [self addSubview:self.discountLabel];
    
    self.moneyLabel = [[UILabel alloc] init];
    self.moneyLabel.frame = CGRectMake(ScreenWidth - 70, 200, 60, 50);
    self.moneyLabel.text = @"10.0元";
    [self addSubview:self.moneyLabel];
}

-(void)selectMoney:(id)sender
{
    UIButton *moneyBtn = (UIButton *)sender;
    
    for (UIButton *btn in self.moneyBtnArr) {
        if (btn.tag == moneyBtn.tag) {
            [btn setBackgroundColor:[UIColor lightGrayColor]];
        }else{
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
    }
    
    self.discountLabel.text = [self.discountCNArr objectAtIndex:moneyBtn.tag];
    
    NSString *moneyStr = [self.moneyArr objectAtIndex:moneyBtn.tag];
    NSString *discountStr = [self.discountArr objectAtIndex:moneyBtn.tag];
    NSInteger money = [moneyStr integerValue];
    CGFloat discount = [discountStr floatValue];

    CGFloat result = money * discount;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%.1f%@", result, @"元"];
}

@end
