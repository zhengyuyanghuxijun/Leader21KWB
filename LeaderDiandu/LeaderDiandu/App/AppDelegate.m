//
//  AppDelegate.m
//  LeaderDiandu
//
//  Created by xijun on 15/8/22.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "AppDelegate.h"
#import "Navigator.h"
#import "HBServiceManager.h"
#import "HBDataSaveManager.h"

#import "DHSlideMenuController.h"
#import "DHSlideMenuViewController.h"
#import "HBNLoginViewController.h"
#import "HBGradeViewController.h"

#import "Constants.h"
#import "HBVersionCheck.h"

#import <Bugly/CrashReporter.h>

#if KEnableThirdPay
#import "NSString+Extra.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#endif

@interface AppDelegate ()/*<WXApiDelegate>*/
{
    DHSlideMenuController *menuVC;
    UIViewController      *_currentVC;
}

@end

AppDelegate *myAppDelegate;

@implementation AppDelegate

+ (AppDelegate *)delegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //苹果应用内升级
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        HBVersionCheck *version = [[HBVersionCheck alloc] init];
        [version checkVersion];
    });
    
    //bugly初始化
//    [[CrashReporter sharedInstance] enableLog:YES];
    [[CrashReporter sharedInstance] installWithAppId:KWBBuglyAppID];
    
//    NSString *FirstLoginString = [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLogin"];
    
    // 启动后的界面
    
//    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UITabBarController *tabVC = [mainBoard instantiateInitialViewController];
//    self.globalNavi = [[UINavigationController alloc] initWithRootViewController:tabVC];
//    self.globalNavi.navigationBarHidden = YES;
    
    HBGradeViewController *rootVC = [[HBGradeViewController alloc] init];
    menuVC = [DHSlideMenuController sharedInstance];
    menuVC.mainViewController = rootVC;
    menuVC.rightViewController = nil;
    menuVC.animationType = SlideAnimationTypeMove;
    menuVC.needPanFromViewBounds = YES;
    
    self.loginVC = [[HBNLoginViewController alloc] init];
    self.globalNavi = [[UINavigationController alloc] initWithRootViewController:menuVC];
//    self.globalNavi.navigationBarHidden = YES;
    
    //这里读取数据没有意义，
    //需要登录成功后根据userid读取对应用户的数据才准确，
    //已经加在登陆成功的位置了。
//    [[HBDataSaveManager defaultManager] loadSettings];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.window setRootViewController:self.globalNavi];
    [self.window makeKeyAndVisible];
    
    myAppDelegate = self;
    self.multiple = 1.0;
    if ([UIDevice isiPad]) {
        self.isPad = YES;
        self.multiple = 1.5;
    }
    
//    [self verifyLogin];
    
    return YES;
}

- (void)verifyLogin
{
#if KSaveDefaultUser
    NSDictionary *dict = [[HBDataSaveManager defaultManager] loadUser];
    BOOL islogined = NO;
    if (dict) {
        islogined = YES;
        [self initDHSlideMenu];
    }
    if (!islogined) {
        [self.globalNavi pushViewController:_loginVC animated:NO];
    } else {
        [[HBDataSaveManager defaultManager] loadFirstLogin];
        [[HBDataSaveManager defaultManager] saveFirstLogin];
        
        [[HBDataSaveManager defaultManager] loadSettings];
        
        //用户登录成功后发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_LoginSuccess object:nil];
    }
#else
    NSDictionary *dict = [[HBDataSaveManager defaultManager] loadDefaultAccount];
    if (dict) {
        NSString *phone = dict[KWBDefaultUser];
        NSString *pwd = dict[KWBDefaultPwd];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBHudUtil showActivityView:nil inView:nil];
            [[HBServiceManager defaultManager] requestLogin:phone pwd:pwd completion:^(id responseObject, NSError *error) {
                [MBHudUtil hideActivityView:nil];
                if (error.code == 0) {
                    //登录成功
                    [[HBDataSaveManager defaultManager] loadFirstLogin];
                    [[HBDataSaveManager defaultManager] saveFirstLogin];
                    [[HBDataSaveManager defaultManager] loadSettings];
                    
                    [self initDHSlideMenu];
                    
                    NSString *message = [NSString stringWithFormat:@"用户%@登录成功", phone];
                    [MBHudUtil showTextViewAfter:message];
                    
                    //用户登录成功后发送通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_LoginSuccess object:nil];
                } else {
                    NSString *message = [NSString stringWithFormat:@"用户%@登录失败", phone];
                    [MBHudUtil showTextViewAfter:message];
//                    [self.globalNavi pushViewController:_loginVC animated:NO];
                }
            }];
        });
    } else {
//        [self.globalNavi pushViewController:_loginVC animated:NO];
    }
#endif
}

- (void)showLoginVC
{
    if (_loginVC) {
        UIViewController *curVC = self.globalNavi.topViewController;
        NSLog(@"showLoginVC---curVC=%@", curVC);
        if (_currentVC == _loginVC) {
            return;
        }
        _currentVC = _loginVC;
        [self.globalNavi popToRootViewControllerAnimated:NO];
        [self.globalNavi pushViewController:_loginVC animated:YES];
    }
}

- (void)showLoginVCNow
{
    if (_loginVC) {
        _currentVC = _loginVC;
        [self.globalNavi popToRootViewControllerAnimated:NO];
        [self.globalNavi pushViewController:_loginVC animated:NO];
    }
}

//登录成功后调用
- (void)initDHSlideMenu
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    
    NSArray *imgArray = nil;
    NSArray *titleArr = nil;
    NSArray *ctlArray = nil;
    if (userEntity.type <= 1) {
        imgArray = @[@"menu-icn-myteacher", @"menu-icn-subs", @"menu-icn-test", @"menu-icn-pay", @"menu-icn-message", @"menu-icn-service", @"menu-icn-setting"];
        titleArr = @[@"我的老师", @"订阅等级", @"我的作业", @"支付中心", @"消息中心", @"联系客服", @"设置"];
        ctlArray = @[@"HBMyTeacherViewController", @"HBSubscribeViewController", @"HBTestWorkViewController", @"HBPayViewController", @"HBMessageViewController", @"", @"HBSettingViewController"];
        
    } else if (userEntity.type == 10) {//老师
        imgArray = @[@"menu-icn-student", @"menu-icn-homework", @"menu-icn-instructor", @"menu-icn-message", @"menu-icn-service", @"menu-icn-setting"];
        titleArr = @[@"学生管理", @"作业管理", @"我的教研员", @"消息中心", @"联系客服", @"设置"];
        ctlArray = @[@"HBStuManViewController", @"HBWorkManViewController", @"HBLeaderViewController", @"HBMessageViewController", @"", @"HBSettingViewController"];
        
    } else if (userEntity.type == 20) {//教研员
        imgArray = @[@"menu-icn-teachers", @"menu-icn-homework", @"menu-icn-message", @"menu-icn-service", @"menu-icn-setting"];
        titleArr = @[@"教师管理", @"每周作业", @"消息中心", @"联系客服", @"设置"];
        ctlArray = @[@"HBTeacherManViewController", @"HBWeekWorkViewController", @"HBMessageViewController", @"", @"HBSettingViewController"];
    }
    
    DHSlideMenuViewController *leftViewController = [[DHSlideMenuViewController alloc] init];
    [leftViewController setMenus:titleArr MenuImages:imgArray TabBarControllers:ctlArray];
    leftViewController.headerClassName = @"HBUserInfoViewController";
    menuVC.leftViewController = leftViewController;
    menuVC.leftViewShowWidth = ScreenWidth - 50;
    _currentVC = menuVC;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
#if KEnableThirdPay
    //跳转支付宝钱包进行支付，处理支付结果
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"resultdic = %@",resultDic);
        }];
//        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//            [self handleResultDict:resultDic];
//        }];
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
             [self handleResultDict:resultDic];
         }];
    } else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self handleResultDict:resultDic];
        }];
    } else if ([url.absoluteString rangeOfString:self.wxAppId].length > 0) {
        [WXApi handleOpenURL:url delegate:self];
    }
#endif
    
    return YES;
}

#if KEnableThirdPay
- (void)onReq:(BaseReq *)req
{
    
}

- (void)onResp:(BaseResp *)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付成功";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = @"支付失败";
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    [MBHudUtil showTextViewAfter:strMsg];
}

- (void)handleResultDict:(NSDictionary *)resultDic
{
    NSLog(@"resultdic = %@",resultDic);
    NSInteger resultStatus = [[resultDic stringForKey:@"resultStatus"] integerValue];
    if (resultStatus == 9000) {
        [MBHudUtil showTextViewAfter:@"支付成功"];
    } else {
        [MBHudUtil showTextViewAfter:@"支付失败"];
    }
}
#endif

//resultStatus，状态码：9000 订单支付成功；8000 正在处理中；4000 订单支付失败；6001 用户中途取消；6002 网络连接出错

//"alisdkdemo://safepay/?{"memo":{"result":"partner=\"2088101568353491\"&se ller_id=\"2088101568353491\"&out_trade_no=\"QU6ZOD85K4HVQFN\"&subject=\"1 \"&body=\" 我 是 测 试 数 据 \"&total_fee=\"0.02\"&notify_url=\"http:\/\/www.xxx.com\"&service=\"mobil e.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay= \"30m\"&show_url=\"m.alipay.com\"&success=\"true\"&sign_type=\"RSA\"&sign =\"pg16DPA\/cIRg1iUFCl8lYZG54de+kfw+vCj32hGWye97isZ1A4bW6RNaDXHhZXVaI5Vk2 YDxhNUl85EHRd+EL7\/+ogQTnsaEHl+D13PuZExIXRKGBnkYqaNV6kH6hDygnf5IOtoojHWLQ yem7oRBVzB0vlF\/+YGFpzFHZyTVpM8=\"","memo":"","ResultStatus":"9000"},"req uestType":"safepay"}"

@end
