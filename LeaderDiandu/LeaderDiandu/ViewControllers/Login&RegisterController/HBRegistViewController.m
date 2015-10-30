//
//  HBResignViewController.m
//  LeaderDiandu
//
//  Created by hxj on 15/8/12.
//
//

#import "HBRegistViewController.h"
#import "HBNTextField.h"
#import "NSString+Verify.h"
#import "HBServiceManager.h"

@interface HBRegistViewController ()

@property (nonatomic, strong) HBNTextField *inputPhoneNumber;
@property (nonatomic, strong) HBNTextField *inputVerifyCode;
@property (nonatomic, strong) HBNTextField *inputPassword;
@property (nonatomic, strong) HBNTextField *againPassword;
@property (nonatomic, strong) UIButton *getCodeButton;
@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic, assign) int countDownNum;
@property (nonatomic, strong) NSTimer *mtimer;

@property (nonatomic, strong) NSDictionary *smsDict;

@end

@implementation HBRegistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMainView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHideKeyboard:)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Method
- (void)initMainView
{
    self.title = @"注册";
    
    float margin = 10;
    float controlY = KHBNaviBarHeight + 50;
    float controlH = 45;
    float screenW = self.view.frame.size.width;
    UIView *accountView = [[UIView alloc] initWithFrame:CGRectMake(0, controlY, screenW, controlH*3+2)];
    accountView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:accountView];
    
    float controlX = 10;
    controlY = 0;
    float controlW = screenW - controlX*2;
    self.inputPhoneNumber = [[HBNTextField alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _inputPhoneNumber.placeholder = @"请输入手机号";
    [_inputPhoneNumber setupTextFieldWithType:HBNTextFieldTypeDefault withIconName:@"phone"];
    [accountView addSubview:_inputPhoneNumber];
    
    float buttonW = 90;
    controlY += controlH+margin;
    controlW -= buttonW+30;
    self.inputVerifyCode = [[HBNTextField alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _inputVerifyCode.placeholder = @"验证码";
    [self.inputVerifyCode setupTextFieldWithType:HBNTextFieldTypeDefault withIconName:@"phone"];
    [accountView addSubview:_inputVerifyCode];
    
    controlX = screenW - buttonW - 10;
    self.getCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, buttonW, controlH)];
    _getCodeButton.backgroundColor = [UIColor whiteColor];
    _getCodeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getCodeButton setTitleColor:KLeaderRGB forState:UIControlStateNormal];
    [_getCodeButton addTarget:self action:@selector(fetchVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    [accountView addSubview:_getCodeButton];
    
    controlX = 10;
    controlY += controlH+margin;
    controlW = screenW - controlX*2;
    self.inputPassword = [[HBNTextField alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _inputPassword.placeholder = @"请输入密码";
    [_inputPassword setupTextFieldWithType:HBNTextFieldTypePassword withIconName:@"lock"];
    [accountView addSubview:_inputPassword];
    
    controlY += controlH+margin;
    self.againPassword = [[HBNTextField alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _againPassword.placeholder = @"请重复输入密码";
    [_againPassword setupTextFieldWithType:HBNTextFieldTypePassword withIconName:@"lock"];
    [accountView addSubview:_againPassword];
}

- (void)tapToHideKeyboard:(id)sender
{
    [self.inputPassword resignFirstResponder];
    [self.inputPhoneNumber resignFirstResponder];
    [self.inputVerifyCode resignFirstResponder];
}

#pragma mark - Target Action

- (void)registerUser:(id)sender
{
    [self tapToHideKeyboard:nil];
    
    if ([self checkIfNeedReturn]) {
        return;
    }
    NSString *phone     = self.inputPhoneNumber.text;
    NSString *password  = self.inputPassword.text;
    NSString *smsCode   = self.inputVerifyCode.text;
    if (smsCode == nil) {
        smsCode = [self.smsDict objectForKey:@"sms_code"];
    }
    self.registerButton.enabled = NO;
    //注册
    [[HBServiceManager defaultManager] requestRegister:phone pwd:password type:@"1" smsCode:smsCode codeId:[self.smsDict objectForKey:@"code_id"] completion:^(id responseObject, NSError *error) {
        self.registerButton.enabled = YES;
        NSDictionary *dict = responseObject;
        if ([[dict objectForKey:@"result"] isEqualToString:@"OK"]) {
            //注册成功
        }
    }];
}

- (void)fetchVerifyCode:(id)sender
{
    [self tapToHideKeyboard:nil];

    [self.inputPhoneNumber resignFirstResponder];
    
    NSString *phoneNum = self.inputPhoneNumber.text;
    if (![phoneNum isPhoneNumInput]){
        [MBHudUtil showTextView:@"请输入正确的手机号" inView:nil];
        return;
    }
    
    [[HBServiceManager defaultManager] requestSmsCode:nil token:nil phone:phoneNum service_type:HBRequestSmsByRegister completion:^(id responseObject, NSError *error) {
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
        }
    }];
}

#pragma mark -  验证码按钮
- (void)beginCountDow
{
    if (_countDownNum <= 0) {
        _getCodeButton.userInteractionEnabled = YES;
//        [_getCodeButton setBackgroundImage:[UIImage imageNamed:@"user_captcha_input"] forState:UIControlStateNormal];
        [_getCodeButton setTitle:@"免费获取短信" forState:UIControlStateNormal];
        
        [self.mtimer invalidate];
        self.mtimer = nil;
    }else{
        _getCodeButton.userInteractionEnabled = NO;
//        [_getCodeButton setBackgroundImage:[UIImage imageNamed:@"user_captcha_input"] forState:UIControlStateNormal];
        [_getCodeButton setTitle:[NSString stringWithFormat:@"%d秒后重新获取", _countDownNum] forState:UIControlStateNormal];
    }
    self.countDownNum--;
}

- (BOOL)checkIfNeedReturn
{
    BOOL needReturn = NO;
    if (![self.inputPhoneNumber.text isPhoneNumInput]){
        [MBHudUtil showTextView:@"请输入正确的手机号" inView:nil];
        needReturn = YES;
    }
    if (![self.inputPassword.text isPasswordInput]){
        [MBHudUtil showTextView:@"密码长度只能在6-32位字符之间" inView:nil];
        needReturn = YES;
    }
    if ([NSString checkTextNULL:self.inputVerifyCode.text]){
        [MBHudUtil showTextView:@"验证码错误" inView:nil];
        needReturn = YES;
    }
    return needReturn;
}

#pragma mark - CheckPhone
- (void)loginCheckPhone:(NSString *)phone{
    //是否注册
    
}

#pragma mark - 注册
- (void)registerPhone:(NSString *)phone pw:(NSString *)pw code:(NSString *)code Nickname:nickname{
    //注册
    
}

@end
