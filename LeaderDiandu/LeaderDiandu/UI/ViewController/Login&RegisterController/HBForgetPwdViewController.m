//
//  HBForgetPasswordViewController.m
//  LeaderDiandu
//
//  Created by hxj on 15/8/12.
//
//

#import "HBForgetPwdViewController.h"
#import "NSString+Verify.h"
#import "HBServiceManager.h"

@interface HBForgetPwdViewController ()

@property (nonatomic, strong) UITextField *inputPhoneNumber;
@property (nonatomic, strong) UITextField *inputVerifyCode;
@property (nonatomic, strong) UIButton *getCodeButton;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, assign) int countDownNum;
@property (nonatomic, strong) NSTimer *mtimer;

@property (nonatomic, strong) NSDictionary *smsDict;

@end

@implementation HBForgetPwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMainView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHideKeyboard:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Method
- (void)initMainView
{
    if (self.viewType == KLeaderViewTypeRegister) {
        self.title = @"注册";
    } else if (self.viewType == KLeaderViewTypeForgetPwd) {
        self.title = @"忘记密码";
    }
    
    float controlY = KHBNaviBarHeight + 50;
    float controlH = 45;
    float screenW = self.view.frame.size.width;
    UIView *accountView = [[UIView alloc] initWithFrame:CGRectMake(0, controlY, screenW, controlH*2+1)];
    accountView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:accountView];
    
    float controlX = 20;
    controlY = 0;
    float controlW = screenW - controlX;
    self.inputPhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _inputPhoneNumber.placeholder = @"请输入手机号";
    _inputPhoneNumber.keyboardType = UIKeyboardTypePhonePad;
    [accountView addSubview:_inputPhoneNumber];
    
    controlY += controlH;
    UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, 1)];
    lineLbl.backgroundColor = RGBEQ(239);
    [accountView addSubview:lineLbl];
    
    float buttonW = 100;
    controlY += 1;
    controlW -= buttonW;
    self.inputVerifyCode = [[UITextField alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _inputVerifyCode.placeholder = @"验证码";
    [accountView addSubview:_inputVerifyCode];
    
    controlX = screenW - buttonW;
    controlH = 25;
    controlY += 10;
    lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, 1, controlH)];
    lineLbl.backgroundColor = RGBEQ(239);
    [accountView addSubview:lineLbl];
    
    controlX += 5;
    buttonW -= 10;
    self.getCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, buttonW, controlH)];
    _getCodeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getCodeButton setTitleColor:KLeaderRGB forState:UIControlStateNormal];
    [_getCodeButton addTarget:self action:@selector(fetchVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    [accountView addSubview:_getCodeButton];
    
    controlX = 20;
    controlY = CGRectGetMaxY(accountView.frame) + 30;
    controlW = screenW - controlX*2;
    controlH = 45;
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    _nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextButton setBackgroundImage:[UIImage imageNamed:@"yellow-normal"] forState:UIControlStateNormal];
    [_nextButton setBackgroundImage:[UIImage imageNamed:@"yellow-press"] forState:UIControlStateHighlighted];
    [_nextButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
}

- (void)tapToHideKeyboard:(id)sender
{
    [self.inputPhoneNumber resignFirstResponder];
    [self.inputVerifyCode resignFirstResponder];
}

- (void)registerUser:(NSString *)password
{
    NSString *phone     = self.inputPhoneNumber.text;
    NSString *smsCode   = self.inputVerifyCode.text;
    if ( [NSString checkTextNULL:phone] || ![phone isPhoneNumInput]) {
        [MBHudUtil showTextView:@"请输入正确的手机号" inView:nil];
        return;
    } else if ([smsCode length] == 0) {
        [MBHudUtil showTextView:@"请输入验证码" inView:nil];
        return;
    }
    if (smsCode == nil) {
        smsCode = [self.smsDict objectForKey:@"sms_code"];
    }
    //注册
    [MBHudUtil showActivityView:nil inView:nil];
    [[HBServiceManager defaultManager] requestRegister:phone pwd:password type:@"1" smsCode:smsCode codeId:[self.smsDict objectForKey:@"code_id"] completion:^(id responseObject, NSError *error) {
        [MBHudUtil hideActivityView:nil];
        NSDictionary *dict = responseObject;
        if ([[dict objectForKey:@"result"] isEqualToString:@"OK"]) {
            //注册成功
            [MBHudUtil showTextViewAfter:@"注册成功，请登录"];
            //返回登录界面
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBHudUtil showTextViewAfter:@"注册失败，请重试"];
        }
    }];
}

- (void)modifyPassword:(NSString *)password
{
    NSString *phone     = self.inputPhoneNumber.text;
    NSString *smsCode   = self.inputVerifyCode.text;
    if ( [NSString checkTextNULL:phone] || ![phone isPhoneNumInput]) {
        [MBHudUtil showTextView:@"请输入正确的手机号" inView:nil];
        return;
    } else if ([smsCode length] == 0) {
        [MBHudUtil showTextView:@"请输入验证码" inView:nil];
        return;
    }
    if (smsCode == nil) {
        smsCode = [self.smsDict objectForKey:@"sms_code"];
    }
    [MBHudUtil showActivityView:nil inView:nil];
    [[HBServiceManager defaultManager] requestUpdatePwd:phone password:password sms_code:smsCode code_id:self.smsDict[@"code_id"] completion:^(id responseObject, NSError *error) {
        [MBHudUtil hideActivityView:nil];
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            [MBHudUtil showTextViewAfter:@"修改密码成功，请登录"];
            //返回登录界面
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBHudUtil showTextViewAfter:@"修改密码失败，请重试"];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *tf1 = [alertView textFieldAtIndex:0];
        UITextField *tf2 = [alertView textFieldAtIndex:1];
        NSString *pwd1 = tf1.text;
        NSString *pwd2 = tf2.text;
        if ([self checkPassword:pwd1 pwd2:pwd2]) {
            return;
        }
        if (self.viewType == KLeaderViewTypeRegister) {
            [self registerUser:pwd1];
        } else if (self.viewType == KLeaderViewTypeForgetPwd) {
            [self modifyPassword:pwd1];
        }
    }
}

#pragma mark - Target Action

- (void)nextButtonPressed:(id)sender
{
    [self tapToHideKeyboard:nil];
    if ([self checkIfNeedReturn]) {
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"设置密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    UITextField *tf1 = [alertView textFieldAtIndex:0];
    UITextField *tf2 = [alertView textFieldAtIndex:1];
    tf1.secureTextEntry = YES;
    tf1.placeholder = @"输入密码";
    tf2.placeholder = @"再次输入密码";
    [alertView show];
}

- (void)fetchVerifyCode:(id)sender
{
    [self tapToHideKeyboard:nil];
    
    NSString *phoneNum = self.inputPhoneNumber.text;
    if ( [NSString checkTextNULL:phoneNum] || ![phoneNum isPhoneNumInput]) {
        [MBHudUtil showTextView:@"请输入正确的手机号" inView:nil];
        return;
    }
    HBRequestSmsType smsType = HBRequestSmsByRegister;
    if (self.viewType == KLeaderViewTypeForgetPwd) {
        smsType = HBRequestSmsByForgetPwd;
    }
    //手机找回密码 的短信下发
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
            NSString *errMsg = [NSString stringWithFormat:@"手机号%@已经被注册过课外宝账号了，不能重复注册。", phoneNum];
            [MBHudUtil showTextViewAfter:errMsg];
        } else {
            [MBHudUtil showTextViewAfter:@"获取验证码失败"];
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
    if (![self.inputPhoneNumber.text isPhoneNumInput]) {
        [MBHudUtil showTextView:@"请输入手机号码" inView:nil];
        needReturn = YES;
    }
    else if ([NSString checkTextNULL:self.inputVerifyCode.text]) {
        [MBHudUtil showTextView:@"请输入验证码" inView:nil];
        needReturn = YES;
    }
    return needReturn;
}

- (BOOL)checkPassword:(NSString *)pwd1 pwd2:(NSString *)pwd2
{
    BOOL needReturn = NO;
    if ([pwd1 length]==0 || [pwd2 length]==0) {
        [MBHudUtil showTextView:@"请填写完整的密码" inView:nil];
        needReturn = YES;
    } else if ([pwd1 isEqualToString:pwd2] == NO) {
        [MBHudUtil showTextView:@"输入的密码不一致" inView:nil];
        needReturn = YES;
    }
//    else if ([pwd1 isPasswordInput]) {
//        [MBHudUtil showTextView:@"密码长度只能在6-32位字符之间" inView:nil];
//        needReturn = YES;
//    }
    return needReturn;
}

@end
