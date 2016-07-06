//
//  HBBaseViewController.m
//  MRWithin
//
//  Created by wangxiao on 15/12/17.
//  Copyright © 2015年 MERI. All rights reserved.
//

#import "HBBaseViewController.h"
#import "UIViewController+HBExt.h"
#import <UMMobClick/MobClick.h>
#import "UIImage+HBExt.h"

@interface HBBaseViewController ()


@end

@implementation HBBaseViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:NSStringFromClass(self.class)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:NSStringFromClass(self.class)];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = RGB(239, 239, 239);
    
    [self setupForDismissKeyboard];//点击空白处，键盘消失
}

- (void)createNoLoginLabel:(NSString *)text
{
    float controlX = 0;
    float controlY = HBFullScreenHeight / 3;
    UILabel *noLoginLbl = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, HBFullScreenWidth, 30)];
    noLoginLbl.backgroundColor = [UIColor clearColor];
    noLoginLbl.textColor = [UIColor lightGrayColor];
    noLoginLbl.text = text;
    noLoginLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noLoginLbl];
}

#pragma mark - 个性化定制statusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark -  navBar
- (void)initNavBarRightBtnWithNormalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action
{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
    [rightButton setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -HBNavItemImgMargin);
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)initNavBarRightBtnWithNormalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action rect:(CGRect)rect
{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:rect];
    [rightButton setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)initNavBarRightBtnWithNormalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage badgeValue:(NSString *)badgeValue target:(id)target action:(SEL)action
{
    if (badgeValue == nil || [badgeValue isEmpty] || [badgeValue isEqualToString:@"0"])
    {
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [rightButton setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
        [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    else
    {
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 25, 25)];
        [rightButton setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
        [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:rightButton];
        
        UILabel *badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 16, 16)];
        badgeLabel.layer.cornerRadius = 8;
        badgeLabel.layer.masksToBounds = YES;
        badgeLabel.backgroundColor = [UIColor redColor];
        badgeLabel.textColor = [UIColor whiteColor];
        badgeLabel.font = [UIFont systemFontOfSize:10];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.text = badgeValue;
        [rightView addSubview:badgeLabel];
        
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
}

- (void)initNavBarRightBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)initNavBarRightBtnWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action
{
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    rightButtonItem.tintColor = color;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)setNavBarRightBtnEnabled:(BOOL)enabled
{
    self.navigationItem.rightBarButtonItem.enabled = enabled;
}

- (void)setNavBarRightBtnNil
{
    self.navigationItem.rightBarButtonItem = nil;
}


- (void)initNavBarLeftBtnWithNormalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [leftButton setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)initNavBarLeftBtnWithNormalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action rect:(CGRect)rect
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:rect];
    [leftButton setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)initNavBarLeftBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)initNavBarLeftBtnWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action
{
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    leftButtonItem.tintColor = color;
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)setNavBarLeftBtnEnabled:(BOOL)enabled
{
    self.navigationItem.leftBarButtonItem.enabled = enabled;
}

- (void)setNavBarLeftBtnNil
{
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)setNavBarTitle:(NSString *)title color:(UIColor *)color
{
    self.navigationItem.title = title;
    
    NSDictionary *titleDict = @{NSForegroundColorAttributeName:color};
    [self.navigationController.navigationBar setTitleTextAttributes:titleDict];
}

#pragma mark - MBProgressHUD

- (void)showLoadingHUDView:(NSString *)title;
{
    [[HBToastHud shared] showLoadingViewWithText:title inView:myAppDelegate.window];
}

- (void)hideLoadingHUDView
{
    [[HBToastHud shared] hideLoadingView];
}

- (void)showCompleteHUDView:(NSString *)title
{
    [[HBToastHud shared] showCompleteViewWithText:title inView:myAppDelegate.window];
}

- (void)showTipNormal:(NSString *)msg
{
//    [APP_DELEGATE.tipWindow showTipMessage:msg type:ETipType_Normal];
}

- (void)showTipWarn:(NSString *)msg code:(NSString *)code
{
    NSString *tipMsg = msg;
    if (code && code.length > 0) {
        
        tipMsg = [NSString stringWithFormat:@"%@(%@)",msg,code];
    }
//    [APP_DELEGATE.tipWindow showTipMessage:tipMsg type:ETipType_Warn];
}

- (void)showTipError:(NSInteger)errorCode
{
    if (errorCode == kCFURLErrorBadServerResponse)
    {
//        [APP_DELEGATE.tipWindow showTipMessage:[NSString stringWithFormat:@"%@(%ld)", kStringNetError1011, (long)errorCode] type:ETipType_Warn];
    }
    else
    {
//        [APP_DELEGATE.tipWindow showTipMessage:[NSString stringWithFormat:@"%@(%ld)", kStringNetError, (long)errorCode] type:ETipType_Warn];
    }
}

- (void)showHintAlert:(NSString *)message buttonTitle:(NSString *)buttonTitle
{
    if (IOS8_Later)
    {
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:nil];
        
        [alertCtr addAction:firstAction];
        [self presentViewController:alertCtr animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil];
        alertView.tag = 521;
        [alertView show];
    }
}

/**
 *  是否可左滑返回
 *
 *  @return
 */
- (BOOL)canDragBack
{
    return YES;
}

#pragma mark - 基类默认只支持MaskPortrait方向，子类需要其他方向重写

/**
 *  controller支持的设备方向
 *
 */
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return  UIInterfaceOrientationMaskPortrait;
}

/**
 *  controller是否可自动旋屏
 *
 */
- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
