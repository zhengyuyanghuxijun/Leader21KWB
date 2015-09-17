//
//  MJNLoginViewController.m
//  Unity-iPhone
//
//  Created by zhangwujian on 15/8/12.
//
//

#import "HBLoginViewController.h"
#import "HBRegistViewController.h"
#import "HBForgetPwdViewController.h"
#import "UIViewController+AddBackBtn.h"
//#import "MJThirdLoginView.h"
//#import "MJMainViewController.h"

#import "HBTitleView.h"
#import "NSString+Verify.h"
#import "HBNTextField.h"

#import "HBServiceManager.h"

@interface HBLoginViewController ()<UITextFieldDelegate>

@property(nonatomic, assign) BOOL isLoginChecking;
@property (weak, nonatomic) IBOutlet HBNTextField *inputPhoneNumber;
@property (weak, nonatomic) IBOutlet HBNTextField *inputPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *userRegister;
@property (weak, nonatomic) IBOutlet UIButton *forgetPassword;

@end

@implementation HBLoginViewController

#pragma mark - VC lifecircle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initMainView];
//    [self addThirdLoginObserve];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLoginID"]) {
//        UITextField *textID = (UITextField *)[[self.view viewWithTag:1005] viewWithTag:1006];
        self.inputPhoneNumber.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLoginID"] ];
    }
//    UITextField *textPW = (UITextField *)[[self.view viewWithTag:1005] viewWithTag:1007];
    self.inputPassword.text = @"";
}

#pragma mark - init Method

- (void)initMainView
{
    HBTitleView *labTitle = [HBTitleView titleViewWithTitle:@"注册登录" onView:self.view];
    [self.view addSubview:labTitle];
    
//    self.fd_interactivePopDisabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHideKeyboard:)];
    [self.view addGestureRecognizer:tap];
    [self.view bringSubviewToFront:self.userRegister];
    [self.inputPhoneNumber setupTextFieldWithType:HBNTextFieldTypeDefault withIconName:@"phone"];
    [self.inputPassword setupTextFieldWithType:HBNTextFieldTypePassword withIconName:@"lock"];
}
- (void)tapToHideKeyboard:(id)sender {
    [_inputPassword resignFirstResponder];
    [_inputPhoneNumber resignFirstResponder];
}

#pragma mark - Target Action
- (IBAction)login:(id)sender
{
    [self tapToHideKeyboard:nil];
    
    NSString *phone = self.inputPhoneNumber.text;
    NSString *pwd = self.inputPassword.text;
    if ([NSString checkTextNULL:phone]  || [NSString checkTextNULL:pwd] ) {
        if ([NSString checkTextNULL:phone]) {
            [self.inputPhoneNumber showErrorMessage:@"请输入手机号"];
        }
        if ([NSString checkTextNULL:pwd]) {
            [self.inputPassword showErrorMessage:@"请输入密码"];
        }
        if (![pwd isValidPassword]) {
            [self.inputPassword showErrorMessage:@"请输入正确格式的密码"];
        }
        return;
    }
    
//    [self setButton:sender Enable:NO];
    self.loginButton.enabled = NO;
    //登录
    [[HBServiceManager defaultManager] requestLogin:phone pwd:pwd completion:^(id responseObject, NSError *error) {
        if (responseObject) {
            //登录成功
            [[HBDataSaveManager defaultManager] loadSettings];
            self.loginButton.enabled = YES;
            [Navigator popToRootController];
            [[AppDelegate delegate] initDHSlideMenu];
            
            NSString *message = [NSString stringWithFormat:@"用户%@登录成功", phone];
            [MBHudUtil showTextView:message inView:nil];
        } else {
            NSString *message = [NSString stringWithFormat:@"用户%@登录失败", phone];
            [MBHudUtil showTextView:message inView:nil];
        }
    }];
}

- (IBAction)loginWithQQ:(id)sender {
//    [[MJLoginManager defaultManager] qqLogin];
}

- (IBAction)loginWithWeibo:(id)sender {
//    [[MJLoginManager defaultManager] weiboLogin];
}

- (IBAction)forgetPassword:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    HBForgetPwdViewController *vc = [sb instantiateViewControllerWithIdentifier:@"HBForgetPwdViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)userRegister:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    HBRegistViewController *vc = [sb instantiateViewControllerWithIdentifier:@"HBRegistViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Notification
//操作按钮的是否可用状态切换
- (void)setButton:(id)Sender Enable:(BOOL)isEnable{
    UIButton *controlBtn = (UIButton *)Sender;
    controlBtn.enabled = isEnable;
    [controlBtn setBackgroundImage:[UIImage imageNamed:(isEnable?@"user_login_btn":@"user_login_btn2")] forState:UIControlStateNormal];
}
-(void)MJResignViewController_WillAppear{
    [self addThirdLoginObserve];
}

- (void)addThirdLoginObserve{
    [self removeThirdLoginObserve];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receivedThirdLogin:)
//                                                 name:kNotificationWeiboLogin
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receivedThirdLogin:)
//                                                 name:kNotificationQQLogin
//                                               object:nil];
}

- (void)removeThirdLoginObserve{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationQQLogin object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationWeiboLogin object:nil];
}

- (void)receivedThirdLogin:(NSNotification *)notification{
    [self loginedCheck];
}

- (void)loginedCheck{
    if (_isLoginChecking) {
        return;
    }
    [self removeThirdLoginObserve];
    //判断是否已经绑定手机号
    
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.isLoginChecking = NO;
    return YES;
}

#pragma mark - PushPage
- (void)pushMenuPage{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
//    MJMainViewController *mainVC = [[MJMainViewController alloc] initWithNibName:nil bundle:nil];
//    [self.navigationController pushViewController:mainVC animated:YES];
}

#pragma mark - 控制旋转方向
-(NSUInteger)supportedInterfaceOrientations{
    //这里写你需要的方向
    return UIInterfaceOrientationPortrait;
}
- (BOOL)shouldAutorotate
{
    return NO;
}



@end
