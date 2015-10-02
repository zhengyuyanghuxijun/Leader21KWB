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
    float controlX = 20;
    float controlY = 20 + KHBNaviBarHeight;
    float width = frame.size.width - controlX*2;
    UIImageView *editBg = [[UIImageView alloc] initWithFrame:CGRectMake(controlX, controlY, width, 50)];
    editBg.userInteractionEnabled = YES;
    UIImage *image = [UIImage imageNamed:@"user_editbg"];
    editBg.image = image;
    [self.view addSubview:editBg];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, width-40, 40)];
//    _textField.placeholder = @"请输入老师ID";
    [editBg addSubview:_textField];
    
    controlY = CGRectGetMaxY(editBg.frame) + 30;
    float buttonHeight = 50;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, width, buttonHeight)];
    image = [UIImage imageNamed:@"user_button"]; //resizableImageWithCapInsets:UIEdgeInsetsMake(13, 100, 13, 100) resizingMode:UIImageResizingModeStretch];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"确认修改" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(modifyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)modifyButtonAction:(id)sender
{
    NSString *text = _textField.text;
    if (text) {
        HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
        [[HBServiceManager defaultManager] requestUpdateUser:userEntity.name token:userEntity.token display_name:text gender:userEntity.gender completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                [[HBDataSaveManager defaultManager] updateDisplayName:responseObject];
                [Navigator popController];
            }
        }];
    }
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
