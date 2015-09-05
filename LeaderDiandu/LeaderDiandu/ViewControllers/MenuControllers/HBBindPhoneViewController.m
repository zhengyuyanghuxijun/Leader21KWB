//
//  HBBindPhoneViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/4.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBBindPhoneViewController.h"
#import "UIViewController+AddBackBtn.h"
#import "HBTitleView.h"

@interface HBBindPhoneViewController ()
{
    UITextField     *_phoneEdit;
    UITextField     *_codeEdit;
}

@end

@implementation HBBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HBTitleView *labTitle = [HBTitleView titleViewWithTitle:@"绑定手机号" onView:self.view];
    [self.view addSubview:labTitle];
    
    [self addBackButton];
    
    CGRect frame = self.view.frame;
    float controlX = 20;
    float controlY = 20 + KHBNaviBarHeight;
    float width = frame.size.width - controlX*2;
    UIImageView *phoneEditBg = [[UIImageView alloc] initWithFrame:CGRectMake(controlX, controlY, width, 50)];
    phoneEditBg.userInteractionEnabled = YES;
    UIImage *image = [UIImage imageNamed:@"user_editbg"];
    phoneEditBg.image = image;
    [self.view addSubview:phoneEditBg];
    
    _phoneEdit = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, width-40, 40)];
    [phoneEditBg addSubview:_phoneEdit];
    
    controlY = CGRectGetMaxY(phoneEditBg.frame) + 20;
    UIImageView *codeEditBg = [[UIImageView alloc] initWithFrame:CGRectMake(controlX, controlY, width, 50)];
    codeEditBg.userInteractionEnabled = YES;
    image = [UIImage imageNamed:@"user_editbg"];
    codeEditBg.image = image;
    [self.view addSubview:codeEditBg];
    
    float codeBtnWid = 80;
    controlX = width - codeBtnWid - 10;
    UIButton *codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(controlX, 5, codeBtnWid, 40)];
    codeBtn.backgroundColor = [UIColor clearColor];
    [codeBtn setTitleColor:RGBCOLOR(249, 154, 11) forState:UIControlStateNormal];
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [codeBtn addTarget:self action:@selector(codeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [codeEditBg addSubview:codeBtn];
    
    _codeEdit = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, controlX-40, 40)];
    [codeEditBg addSubview:_codeEdit];
    
    float buttonHeight = 50;
    controlX = 20;
    controlY = CGRectGetMaxY(codeEditBg.frame) + 20;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, width, buttonHeight)];
    image = [UIImage imageNamed:@"user_button"];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"确认修改" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(modifyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)codeBtnAction:(id)sender
{
    
}

- (void)modifyButtonAction:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
