//
//  HBPayViewControllerModeCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/30.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBPayViewControllerModeCell.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation HBPayViewControllerModeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier showModeText:(BOOL)showModeText
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.showModeText = showModeText;
        self.checked = NO;
        [self initUI];
    }
    return self;
}

- (void) initUI
{
    UIImage* bgImage = [UIImage imageNamed:@"pay-icn-alipay"];
    self.iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, (50 - 30)/2, 30, 30)];
    self.iconImg.image = bgImage;
    [self addSubview:self.iconImg];
    
    if (self.showModeText) {
        self.modeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + 30 + 10, 0, 150, 50)];
        [self addSubview:self.modeLabel];
    }else{
        UIImageView *editBg = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 30 + 10, 0, 250, 50)];
        editBg.userInteractionEnabled = YES;
        editBg.image = [UIImage imageNamed:@"user_editbg"];
        [self addSubview:editBg];
        
        self.VIPTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 250, 30)];
        self.VIPTextField.placeholder = @"VIP码";
        [editBg addSubview:self.VIPTextField];
    }
    
    //选择按钮
    self.selectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 40, (50 - 30)/2, 30, 30)];
    if (self.checked) {
        [self.selectedBtn setBackgroundImage:[UIImage imageNamed:@"duoxuan-slected"] forState:UIControlStateNormal];
    }else{
        [self.selectedBtn setBackgroundImage:[UIImage imageNamed:@"duoxuan-normal"] forState:UIControlStateNormal];
    }
    
    [self.selectedBtn addTarget:self action:@selector(selectedBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectedBtn];
}

-(void)updateFormData:(NSMutableDictionary *)dic checkedName:(NSString *)checkedName
{
    if ([dic objectForKey:@"iconImg"]) {
        self.iconImg.image = [UIImage imageNamed:[dic objectForKey:@"iconImg"]];
        self.checkedName = [dic objectForKey:@"iconImg"];
    }
    
    if ([dic objectForKey:@"modeLabel"]) {
        if (self.showModeText) {
            self.modeLabel.text = [dic objectForKey:@"modeLabel"];
        }
    }
    
    if ([dic objectForKey:@"iconImg"] && checkedName) {
        
        if ([[dic objectForKey:@"iconImg"] isEqualToString:checkedName]) {
            self.checked = YES;
            [self.selectedBtn setBackgroundImage:[UIImage imageNamed:@"duoxuan-slected"] forState:UIControlStateNormal];
        }else{
            self.checked = NO;
            [self.selectedBtn setBackgroundImage:[UIImage imageNamed:@"duoxuan-normal"] forState:UIControlStateNormal];
        }
    }
    
    if ([checkedName isEqualToString:@"pay-icn-voucher"]) {
        [self.VIPTextField setEnabled:YES];
    }else{
        [self.VIPTextField setEnabled:NO];
    }
}

-(void)selectedBtnPress
{
    [self.delegate payCellChecked:self.checkedName];
}

@end
