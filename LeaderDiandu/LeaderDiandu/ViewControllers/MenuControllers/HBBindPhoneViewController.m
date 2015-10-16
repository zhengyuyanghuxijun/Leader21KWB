//
//  HBBindPhoneViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/4.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBBindPhoneViewController.h"

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
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"绑定手机号";
    
    float screenW = self.view.frame.size.width;
    float controlX = 0;
    float controlY = KHBNaviBarHeight + 50;
    float controlW = screenW;
    float controlH = 45;
    UIView *editBg = [[UIView alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH*2+1)];
    editBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:editBg];
    
    controlX = 20;
    controlY = 0;
    controlW = screenW-controlX;
    _phoneEdit = [[UITextField alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _phoneEdit.placeholder = @"请输入手机号";
    [editBg addSubview:_phoneEdit];
    
    controlY += controlH;
    UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, 1)];
    lineLbl.backgroundColor = RGBEQ(239);
    [editBg addSubview:lineLbl];
    
    float buttonW = 100;
    controlY += 1;
    controlW -= buttonW;
    _codeEdit = [[UITextField alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _codeEdit.placeholder = @"验证码";
    [editBg addSubview:_codeEdit];
    
    controlX = screenW - buttonW;
    controlH = 25;
    controlY += 10;
    lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, 1, controlH)];
    lineLbl.backgroundColor = RGBEQ(239);
    [editBg addSubview:lineLbl];
    
    controlX += 5;
    buttonW -= 10;
    UIButton *codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, buttonW, controlH)];
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn setTitleColor:KLeaderRGB forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(codeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [editBg addSubview:codeBtn];
    
    controlX = 20;
    controlY = CGRectGetMaxY(editBg.frame) + 30;
    controlW = screenW - controlX*2;
    controlH = 45;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    [button setBackgroundImage:[UIImage imageNamed:@"yellow-normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"yellow-press"] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"确认修改" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(modifyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHideKeyboard:)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapToHideKeyboard:(id)sender
{
    [_phoneEdit resignFirstResponder];
    [_codeEdit resignFirstResponder];
}

- (void)codeBtnAction:(id)sender
{
    [self.view endEditing:YES];
}

- (void)modifyButtonAction:(id)sender
{
    [self.view endEditing:YES];
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
