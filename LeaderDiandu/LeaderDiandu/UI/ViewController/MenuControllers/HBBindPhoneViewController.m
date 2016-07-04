//
//  HBBindPhoneViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/4.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBBindPhoneViewController.h"
#import "NSString+Verify.h"
#import "HBServiceManager.h"

@interface HBBindPhoneViewController ()
{
    UITextField     *_phoneEdit;
    UITextField     *_codeEdit;
}

@property (nonatomic, strong) UIButton *getCodeButton;

@property (nonatomic, assign) int countDownNum;
@property (nonatomic, strong) NSTimer *mtimer;
@property (nonatomic, strong) NSDictionary *smsDict;

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
    self.getCodeButton = codeBtn;
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
    
    NSString *phoneNum = _phoneEdit.text;
    if ( [NSString checkTextNULL:phoneNum] || ![phoneNum isPhoneNumInput]) {
        [MBHudUtil showTextView:@"请输入正确的手机号" inView:nil];
        return;
    }
    HBRequestSmsType smsType = HBRequestSmsByBindPhone;
    
    //绑定手机的短信下发
    [MBHudUtil showActivityView:nil inView:nil];
    [[HBServiceManager defaultManager] requestSmsCode:nil phone:phoneNum service_type:smsType completion:^(id responseObject, NSError *error) {
        [MBHudUtil hideActivityView:nil];
        if (error.code == 0) {
            self.smsDict = responseObject;
            //发送了 验证码 进入倒计时
            self.countDownNum = 60;
            [self beginCountDow];
            if ([_mtimer isValid]) {
                NSLog(@"再次倒计时");
                return ;
            }
            self.mtimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(beginCountDow) userInfo:nil repeats:YES];
        } else if (error.code == -1011) {
            NSString *errMsg = [NSString stringWithFormat:@"手机号%@已经被注册过课外宝账号了，不能重复绑定。", phoneNum];
            [MBHudUtil showTextViewAfter:errMsg];
        } else {
            [MBHudUtil showTextViewAfter:@"获取验证码失败"];
        }
    }];
}

- (void)modifyButtonAction:(id)sender
{
    [self.view endEditing:YES];
    
    NSString *phoneNum = _phoneEdit.text;
    NSString *codeNum = _codeEdit.text;
    if ( [NSString checkTextNULL:phoneNum] || ![phoneNum isPhoneNumInput]) {
        [MBHudUtil showTextView:@"请输入正确的手机号" inView:nil];
        return;
    } else if ([codeNum length] == 0) {
        [MBHudUtil showTextView:@"请输入验证码" inView:nil];
        return;
    }

    [MBHudUtil showActivityView:nil inView:nil];
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBServiceManager defaultManager] requestUpdatePhone:userEntity.name phone:phoneNum sms_code:codeNum code_id:self.smsDict[@"code_id"] completion:^(id responseObject, NSError *error) {
        [MBHudUtil hideActivityView:nil];
        if (error == nil) {
            NSString *phone = [responseObject objectForKey:@"phone"];
            if (phone) {
                [[HBDataSaveManager defaultManager] updatePhoneByStr:phone];
                [MBHudUtil showTextViewAfter:@"绑定手机成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [MBHudUtil showTextViewAfter:@"绑定手机失败"];
            }
        } else {
            [MBHudUtil showTextViewAfter:@"绑定手机失败"];
        }
    }];
}

#pragma mark -  验证码按钮
- (void)beginCountDow
{
    if (_countDownNum <= 0) {
        self.getCodeButton.userInteractionEnabled = YES;
        [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.mtimer invalidate];
        self.mtimer = nil;
        
    }else{
        self.getCodeButton.userInteractionEnabled = NO;
        [self.getCodeButton setTitle:[NSString stringWithFormat:@"%d秒后重试", _countDownNum] forState:UIControlStateNormal];
    }
    self.countDownNum--;
}

- (BOOL)checkIfNeedReturn
{
    BOOL needReturn = NO;
    if (![_phoneEdit.text isPhoneNumInput]) {
        [MBHudUtil showTextView:@"请输入手机号码" inView:nil];
        needReturn = YES;
    }
    else if ([NSString checkTextNULL:_codeEdit.text]) {
        [MBHudUtil showTextView:@"请输入验证码" inView:nil];
        needReturn = YES;
    }
    return needReturn;
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
