//
//  HBResignViewController.m
//  LeaderDiandu
//
//  Created by hxj on 15/8/12.
//
//

#import "HBRegistViewController.h"
#import "HBNLoginViewController.h"
#import "HBRegInfoViewController.h"
#import "HBNTextField.h"
#import "NSString+Verify.h"
#import "HBServiceManager.h"
#import "HBHyperlinksButton.h"

#import "UIButton+AFNetworking.h"

#define KVerifyImgApi   @"/api/auth/captcha"

@interface HBRegistViewController ()

@property (nonatomic, strong) HBNTextField *inputPhoneNumber;
@property (nonatomic, strong) HBNTextField *inputVerifyCode;
@property (nonatomic, strong) HBNTextField *inputPassword;
@property (nonatomic, strong) HBNTextField *againPassword;
@property (nonatomic, strong) UIButton *getCodeButton;
@property (nonatomic, strong) UIButton *finishButton;

@property (nonatomic, assign) int countDownNum;
@property (nonatomic, strong) NSTimer *mtimer;

@property (nonatomic, strong) NSDictionary *smsDict;
@property (nonatomic, strong) NSString *x_code_id;

@end

@implementation HBRegistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMainView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHideKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    if (self.viewType == KLeaderViewTypeRegister) {
        [self getVerifyImage];
    }
}

- (void)getVerifyImage
{
    NSString *imgUrl = [NSString stringWithFormat:@"%@%@", SERVICEAPI, KVerifyImgApi];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imgUrl]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [_getCodeButton setTitle:@"载入..." forState:UIControlStateNormal];
    __strong __typeof(self)strongSelf = self;
    [_getCodeButton setBackgroundImageForState:UIControlStateNormal withURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (image) {
            [strongSelf.getCodeButton setTitle:@"" forState:UIControlStateNormal];
            strongSelf.x_code_id = response.allHeaderFields[@"X-Code-Id"];
            [strongSelf.getCodeButton setBackgroundImage:image forState:UIControlStateNormal];
        } else {
            [strongSelf.getCodeButton setTitle:@"刷新" forState:UIControlStateNormal];
        }
    } failure:^(NSError *error) {
        [strongSelf.getCodeButton setTitle:@"刷新" forState:UIControlStateNormal];
    }];
//    [[HBServiceManager defaultManager] requestGetVerifyImg:^(id responseObject, NSError *error) {
//        
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Method
- (void)initMainView
{
    NSInteger editNum = 4;
    if (self.viewType == KLeaderViewTypeRegister) {
        self.title = @"注册";
    } else {
        self.title = @"忘记密码";
    }
    
    float margin = 10;
    float controlY = KHBNaviBarHeight + 50;
    float controlH = 45;
    float screenW = self.view.frame.size.width;
    UIView *accountView = [[UIView alloc] initWithFrame:CGRectMake(0, controlY, screenW, controlH*editNum+30)];
    accountView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:accountView];
    
    float controlX = 0;
    controlY = 0;
    float controlW = screenW - controlX*2;
    self.inputPhoneNumber = [[HBNTextField alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    if (self.viewType == KLeaderViewTypeRegister) {
        _inputPhoneNumber.placeholder = @"请输入昵称";
    } else {
        _inputPhoneNumber.placeholder = @"请输入手机号";
    }
    [_inputPhoneNumber setupTextFieldWithType:HBNTextFieldTypeDefault withIconName:@"phone"];
    [accountView addSubview:_inputPhoneNumber];
    
    float buttonW = 120;
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
    [_getCodeButton setTitleColor:KLeaderRGB forState:UIControlStateNormal];
    [_getCodeButton addTarget:self action:@selector(fetchVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    [accountView addSubview:_getCodeButton];
    if (self.viewType != KLeaderViewTypeRegister) {
        [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    
    controlX = 0;
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
    
    controlX = 20;
    controlY = CGRectGetMaxY(accountView.frame) + 30;
    controlW = screenW - controlX*2;
    controlH = 45;
    self.finishButton = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    [_finishButton setTitle:@"提交" forState:UIControlStateNormal];
    _finishButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [_finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_finishButton setBackgroundImage:[UIImage imageNamed:@"yellow-normal"] forState:UIControlStateNormal];
    [_finishButton setBackgroundImage:[UIImage imageNamed:@"yellow-press"] forState:UIControlStateHighlighted];
    [_finishButton addTarget:self action:@selector(finishButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_finishButton];
    
    if (self.viewType == KLeaderViewTypeRegister) {
        controlX = 0;
        controlY = CGRectGetMaxY(_finishButton.frame) + 30;
        controlW = screenW * 2/3;
        controlH = 20;
        UILabel *tipLbl = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
        tipLbl.backgroundColor = [UIColor clearColor];
        tipLbl.textColor = [UIColor lightGrayColor];
        tipLbl.text = @"如果您已拥有课外宝账户，则可在此";
        tipLbl.textAlignment = NSTextAlignmentRight;
        tipLbl.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:tipLbl];
        
        controlX += controlW;
        controlW = 40;
        HBHyperlinksButton *linkBtn = [[HBHyperlinksButton alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
        [linkBtn setTitle:@"登录" forState:UIControlStateNormal];
        [linkBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        linkBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [linkBtn addTarget:self action:@selector(linkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:linkBtn];
    }
}

- (void)tapToHideKeyboard:(id)sender
{
    [self.inputPhoneNumber resignFirstResponder];
    [self.inputVerifyCode resignFirstResponder];
    [self.inputPassword resignFirstResponder];
    [self.againPassword resignFirstResponder];
}

#pragma mark - Target Action

- (void)linkBtnAction:(id)sender
{
    HBNLoginViewController *loginCtl = [[HBNLoginViewController alloc] init];
    [self.navigationController pushViewController:loginCtl animated:YES];
}

- (void)finishButtonPressed:(id)sender
{
    [self tapToHideKeyboard:nil];
    
    if ([self checkIfNeedReturn]) {
        return;
    }
    
    NSString *passward  = self.inputPassword.text;
    if (self.viewType == KLeaderViewTypeRegister) {
        [self registerNickname:passward];
//        [self registerUser:passward];
    } else if (self.viewType == KLeaderViewTypeForgetPwd) {
        [self modifyPassword:passward];
    }
}

- (void)registerNickname:(NSString *)password
{
    NSString *nickname = self.inputPhoneNumber.text;
    NSString *smsCode   = self.inputVerifyCode.text;

    [MBHudUtil showActivityView:nil inView:nil];
    [[HBServiceManager defaultManager] requestRegistByName:nickname pwd:password smsCode:smsCode codeId:self.x_code_id completion:^(id responseObject, NSError *error) {
        //{ user: "100107", display_name: "tome.lee" }
        [MBHudUtil hideActivityView:nil];
        if (error == nil) {
            NSDictionary *dict = responseObject;
            HBRegInfoViewController *vc = [[HBRegInfoViewController alloc] init];
            vc.userID = [dict stringForKey:@"user"];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBHudUtil showTextViewAfter:@"注册失败，请重试"];
        }
    }];
}

- (void)registerUser:(NSString *)password
{
    NSString *phone     = self.inputPhoneNumber.text;
    NSString *smsCode   = self.inputVerifyCode.text;
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
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [MBHudUtil showActivityView:nil inView:nil];
    [[HBServiceManager defaultManager] requestUpdatePwd:phone token:userEntity.token password:password sms_code:smsCode code_id:self.smsDict[@"code_id"] completion:^(id responseObject, NSError *error) {
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

- (void)fetchVerifyCode:(id)sender
{
    [self tapToHideKeyboard:nil];
    
    if (self.viewType == KLeaderViewTypeRegister) {
        [self getVerifyImage];
        return;
    }
    
    NSString *phoneNum = self.inputPhoneNumber.text;
    if (![phoneNum isPhoneNumInput]){
        [MBHudUtil showTextView:@"请输入正确的手机号" inView:nil];
        return;
    }
    
    HBRequestSmsType smsType = HBRequestSmsByRegister;
    if (self.viewType == KLeaderViewTypeForgetPwd) {
        smsType = HBRequestSmsByForgetPwd;
    }
    [[HBServiceManager defaultManager] requestSmsCode:nil token:nil phone:phoneNum service_type:smsType completion:^(id responseObject, NSError *error) {
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
        } else {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSString *msg = [responseObject objectForKey:@"msg"];
                [MBHudUtil showTextViewAfter:msg];
            }
        }
    }];
}

#pragma mark -  验证码按钮
- (void)beginCountDow
{
    if (_countDownNum <= 0) {
        _getCodeButton.userInteractionEnabled = YES;
        [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        [self.mtimer invalidate];
        self.mtimer = nil;
    }else{
        _getCodeButton.userInteractionEnabled = NO;
        [_getCodeButton setTitle:[NSString stringWithFormat:@"%d秒后重试", _countDownNum] forState:UIControlStateNormal];
    }
    self.countDownNum--;
}

- (BOOL)checkIfNeedReturn
{
    BOOL needReturn = NO;
    NSString *pwd1 = self.inputPassword.text;
    NSString *pwd2 = self.againPassword.text;
    if ([NSString checkTextNULL:self.inputPhoneNumber.text]){
        if (self.viewType == KLeaderViewTypeRegister) {
            [MBHudUtil showTextView:@"请输入昵称" inView:nil];
        } else {
            [MBHudUtil showTextView:@"请输入手机号" inView:nil];
        }
        return YES;
    } else if ([NSString checkTextNULL:self.inputVerifyCode.text]){
        [MBHudUtil showTextView:@"请输入验证码" inView:nil];
        return YES;
    } else if ([pwd1 length]==0 || [pwd2 length]==0) {
        [MBHudUtil showTextView:@"请填写完整的密码" inView:nil];
        needReturn = YES;
    } else if ([pwd1 isEqualToString:pwd2] == NO) {
        [MBHudUtil showTextView:@"输入的密码不一致" inView:nil];
        needReturn = YES;
    }
//    if (![self.inputPassword.text isPasswordInput]){
//        [MBHudUtil showTextView:@"密码长度只能在6-32位字符之间" inView:nil];
//        needReturn = YES;
//    }
    return needReturn;
}

@end
