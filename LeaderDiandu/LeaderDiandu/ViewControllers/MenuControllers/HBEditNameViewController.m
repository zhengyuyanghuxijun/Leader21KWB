//
//  HBEditNameViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/4.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBEditNameViewController.h"
#import "HBServiceManager.h"
#import "HBDataSaveManager.h"

@interface HBEditNameViewController ()
{
    UITextField *_textField;
}

@end

@implementation HBEditNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"修改名字";
    
    CGRect frame = self.view.frame;
    float controlX = 0;
    float controlY = KHBNaviBarHeight + 50;
    float width = frame.size.width - controlX*2;
    UIView *editBg = [[UIView alloc] initWithFrame:CGRectMake(controlX, controlY, width, 50)];
    editBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:editBg];
    
    controlX = 20;
    width -= controlX*2;
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(controlX, 5, width, 40)];
    _textField.placeholder = @"请输入名字";
    [editBg addSubview:_textField];
    
    controlY = CGRectGetMaxY(editBg.frame) + 30;
    float buttonHeight = 50;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, width, buttonHeight)];
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
    [_textField resignFirstResponder];
}

- (void)modifyButtonAction:(id)sender
{
    [self.view endEditing:YES];
    
    NSString *text = _textField.text;
    if ([text length] == 0) {
        [MBHudUtil showTextView:@"请输入名字" inView:nil];
        return;
    }
    [MBHudUtil showActivityView:nil inView:nil];
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBServiceManager defaultManager] requestUpdateUser:userEntity.name display_name:text gender:userEntity.gender age:12 completion:^(id responseObject, NSError *error) {
        [MBHudUtil hideActivityView:nil];
        if (error.code == 0) {
            [[HBDataSaveManager defaultManager] updateDisplayName:responseObject];
            [MBHudUtil showTextView:@"修改成功" inView:nil];
            [Navigator popController];
        } else {
            [MBHudUtil showTextView:@"修改失败" inView:nil];
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
