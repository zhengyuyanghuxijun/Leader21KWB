//
//  HBForgetPasswordViewController.m
//  LeaderDiandu
//
//  Created by hxj on 15/8/12.
//
//

#import "HBForgetPwdViewController.h"
#import "HBNTextField.h"
#import "HBTitleView.h"
#import "NSString+Verify.h"

@interface HBForgetPwdViewController ()

@property (weak, nonatomic) IBOutlet HBNTextField *inputPhoneNumber;
@property (weak, nonatomic) IBOutlet HBNTextField *inputPassword;
@property (weak, nonatomic) IBOutlet HBNTextField *inputVerifyCode;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, assign) int countDownNum;
@property (nonatomic, strong) NSTimer *mtimer;

@end

@implementation HBForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
#pragma mark - init Method
- (void)initMainView
{
    HBTitleView *labTitle = [HBTitleView titleViewWithTitle:@"修改密码" onView:self.view];
    [self.view addSubview:labTitle];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHideKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    [self.inputPhoneNumber setupTextFieldWithType:HBNTextFieldTypeDefault withIconName:@"phone"];
    [self.inputPassword setupTextFieldWithType:HBNTextFieldTypePassword withIconName:@"lock"];
    [self.inputVerifyCode setupTextFieldWithType:HBNTextFieldTypeVerifyCode withIconName:@""];
}

- (void)tapToHideKeyboard:(id)sender {
    [self.inputPassword resignFirstResponder];
    [self.inputPhoneNumber resignFirstResponder];
    [self.inputVerifyCode resignFirstResponder];
}

#pragma mark - Target Action
- (IBAction)backToPreView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveUserPassword:(id)sender {
    [self tapToHideKeyboard:nil];

    if ([self checkIfNeedReturn]) {
        return;
    }
    NSString *mob   = self.inputPhoneNumber.text;
    NSString *pw    = self.inputPassword.text;
    NSString *code  = self.inputVerifyCode.text;
    self.saveButton.enabled = NO;
    //注册 //test
    //    [[MJLoginManager defaultManager] requestResignName:textID.text password:textPW.text code:textCode.text
    
}

- (IBAction)loginWithQQ:(id)sender {
//    [[MJLoginManager defaultManager] qqLogin];
}

- (IBAction)loginWithWeibo:(id)sender {
//    [[MJLoginManager defaultManager] weiboLogin];
}

- (IBAction)fetchVerifyCode:(id)sender {
    [self tapToHideKeyboard:nil];
    
    [self.inputPhoneNumber resignFirstResponder];
    
    NSString *curPhone = self.inputPhoneNumber.text;
    if ( [NSString checkTextNULL:curPhone]  || ![curPhone isPhoneNumInput]){
        [self.inputPhoneNumber showErrorMessage:@"请输入正确的手机号"];
        return;
    }
    //手机找回密码 的短信下发
}

#pragma mark -  验证码按钮
- (void)beginCountDow{
    if (_countDownNum <= 0) {
        self.getCodeButton.userInteractionEnabled = YES;
        [self.getCodeButton setTitle:@"免费获取短信" forState:UIControlStateNormal];
        [self.mtimer invalidate];
        self.mtimer = nil;
        
    }else{
        self.getCodeButton.userInteractionEnabled = NO;
        [self.getCodeButton setTitle:[NSString stringWithFormat:@"%d秒后重新获取", _countDownNum] forState:UIControlStateNormal];
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

@end
