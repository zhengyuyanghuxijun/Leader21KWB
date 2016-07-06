//
//  HBModifyPwdViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/10/16.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBModifyPwdViewController.h"
#import "HBServiceManager.h"

@interface HBModifyPwdViewController ()
{
    UITextField     *_oldPwdEdit;
    UITextField     *_newPwdEdit;
    UITextField     *_againPwdEdit;
}

@end

@implementation HBModifyPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"修改密码";
    
    float screenW = self.view.frame.size.width;
    float controlX = 0;
    float controlY = HBNavBarHeight + 50;
    float controlW = screenW;
    float controlH = 45;
    UIView *editBg = [[UIView alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH*3+2)];
    editBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:editBg];
    
    controlX = 20;
    controlY = 0;
    controlW = screenW-controlX;
    _oldPwdEdit = [[UITextField alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _oldPwdEdit.secureTextEntry = YES;
    _oldPwdEdit.placeholder = @"旧密码";
    [editBg addSubview:_oldPwdEdit];
    
    controlY += controlH;
    UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, 1)];
    lineLbl.backgroundColor = RGBEQ(239);
    [editBg addSubview:lineLbl];
    
    controlY += 1;
    _newPwdEdit = [[UITextField alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _newPwdEdit.secureTextEntry = YES;
    _newPwdEdit.placeholder = @"新密码";
    [editBg addSubview:_newPwdEdit];
    
    controlY += controlH;
    lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, 1)];
    lineLbl.backgroundColor = RGBEQ(239);
    [editBg addSubview:lineLbl];
    
    controlY += 1;
    _againPwdEdit = [[UITextField alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _againPwdEdit.secureTextEntry = YES;
    _againPwdEdit.placeholder = @"再次输入新密码";
    [editBg addSubview:_againPwdEdit];
    
    controlX = 20;
    controlY = CGRectGetMaxY(editBg.frame) + 30;
    controlW = screenW - controlX*2;
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
    [_oldPwdEdit resignFirstResponder];
    [_newPwdEdit resignFirstResponder];
    [_againPwdEdit resignFirstResponder];
}

- (void)modifyButtonAction:(id)sender
{
    [self.view endEditing:YES];
    
    NSString *oldPwdText = _oldPwdEdit.text;
    NSString *newPwdText = _newPwdEdit.text;
    NSString *againText = _againPwdEdit.text;

    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    NSString *pldPwdMd5 = [oldPwdText md5];
    
    if ([oldPwdText length] == 0) {
        [MBHudUtil showTextView:@"请输入旧密码" inView:nil];
        return;
    } else if ([newPwdText length] == 0) {
        [MBHudUtil showTextView:@"请输入新密码" inView:nil];
        return;
    } else if ([againText length] == 0) {
        [MBHudUtil showTextView:@"请确认新密码" inView:nil];
        return;
    } else if ([newPwdText isEqualToString:againText] == NO) {
        [MBHudUtil showTextView:@"输入的密码不一致" inView:nil];
        return;
    } else if ([pldPwdMd5 isEqualToString:userEntity.pwd] == NO) {
        [MBHudUtil showTextView:@"旧密码错误，修改密码失败，请重试" inView:nil];
        return;
    }
    
    [MBHudUtil showActivityView:nil inView:nil];
    [[HBServiceManager defaultManager] requestModifyPwd:userEntity.name old_password:oldPwdText new_password:newPwdText completion:^(id responseObject, NSError *error) {
        [MBHudUtil hideActivityView:nil];
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            [MBHudUtil showTextViewAfter:@"修改密码成功"];

            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBHudUtil showTextViewAfter:@"修改密码失败"];
        }
    }];
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
