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
#import "HBTitleView.h" 

@interface HBRegistViewController ()

@property (weak, nonatomic) IBOutlet HBNTextField *inputPhoneNumber;
@property (weak, nonatomic) IBOutlet HBNTextField *inputPassword;
@property (weak, nonatomic) IBOutlet HBNTextField *inputVerifyCode;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (nonatomic, assign) int countDownNum;
@property (nonatomic, strong) NSTimer *mtimer;

@property (nonatomic, strong) NSDictionary *smsDict;

@end

@implementation HBRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Method
- (void)initMainView
{
    HBTitleView *labTitle = [HBTitleView titleViewWithTitle:@"注册" onView:self.view];
    [self.view addSubview:labTitle];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHideKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    [self.inputPhoneNumber setupTextFieldWithType:HBNTextFieldTypeDefault withIconName:@"phone"];
    [self.inputPassword setupTextFieldWithType:HBNTextFieldTypePassword withIconName:@"lock"];
    [self.inputVerifyCode setupTextFieldWithType:HBNTextFieldTypeVerifyCode withIconName:@""];
}

- (void)tapToHideKeyboard:(id)sender
{
    [self.inputPassword resignFirstResponder];
    [self.inputPhoneNumber resignFirstResponder];
    [self.inputVerifyCode resignFirstResponder];
}

#pragma mark - Target Action
- (IBAction)backToPreView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)registerUser:(id)sender {
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

- (IBAction)fetchVerifyCode:(id)sender {
    [self tapToHideKeyboard:nil];

    [self.inputPhoneNumber resignFirstResponder];
    
    NSString *phoneNum = self.inputPhoneNumber.text;
    if (![phoneNum isPhoneNumInput]){
        [self.inputPhoneNumber showErrorMessage:@"请输入正确的手机号"];
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
        [self.inputPhoneNumber showErrorMessage:@"请输入正确的手机号"];
        needReturn = YES;
    }
    if (![self.inputPassword.text isPasswordInput]){
        [self.inputPassword showErrorMessage:@"密码长度只能在6-32位字符之间"];
        needReturn = YES;
    }
    if ([NSString checkTextNULL:self.inputVerifyCode.text]){
        [self.inputVerifyCode showErrorMessage:@"验证码错误"];
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
