//
//  HBPayViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/1.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBPayViewController.h"
#import "HBPayViewControllerMoneyCell.h"
#import "HBPayViewControllerModeCell.h"
#import "HBBillViewController.h"
#import "HBServiceManager.h"
#import "HBDataSaveManager.h"

#import "HBSKPayService.h"
#import "MBProgressHUD.h"
#import "HHAlertSingleView.h"

#if KEnableThirdPay
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "WXApi.h"
#import "WXApiObject.h"
#endif

#define KHBPayUserID    @"HBPayUserID"
#define KHBPayReceipt   @"HBPayReceipt"
#define KHBPayMonths    @"HBPayMonths"
#define KHBPayTransID   @"HBPayTransactionID"

#define KLeaderAliPay   @"zfb"
#define KLeaderWXPay    @"tenpay"

static NSString * const KHBPayViewControllerMoneyCellReuseId = @"KHBPayViewControllerMoneyCellReuseId";
static NSString * const KHBPayViewControllerCellModeReuseId = @"KHBPayViewControllerCellModeReuseId";

@interface HBPayViewController ()<UITableViewDataSource, UITableViewDelegate, HBPayCellChangeDelegate, HBPayMoneyCellDelegate, HBSKPayServiceDelegate>
{
    UITableView *_tableView;
    NSString *_textFieldStr;
    
    NSDictionary *_payMonthDic;
}

@property (nonatomic, strong) UIButton* payButton;
@property (nonatomic, strong) NSMutableDictionary *payModeDic;
@property (nonatomic, strong) NSDictionary *orderDict;

@property (nonatomic, assign) NSInteger months;
@property (nonatomic, assign) CGFloat money;

@property (nonatomic, strong) NSTimer *mtimer;
@property (nonatomic, strong) HBSKPayService *skPayService;
@property (nonatomic, strong) MBProgressHUD *progressView;

@end

@implementation HBPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"支付中心";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"账单" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonPressed)];
    [rightButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.skPayService = [HBSKPayService defaultService];
    self.skPayService.payDelegate = self;
    _payMonthDic = @{@(1):@(30), @(3):@(88), @(6):@(178), @(12):@(348)};
    
    self.months = 1;
    self.money = 30;
    
    self.payModeDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [self.payModeDic setObject:@"pay-icn-alipay" forKey:@"checked"];
    
    CGRect rect = self.view.frame;
    CGRect viewFrame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    _tableView = [[UITableView alloc] initWithFrame:viewFrame];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    CGRect rc = CGRectMake(0.0f, 0.0f, rect.size.width, 80.0f);
    UIView* view = [[UIView alloc] initWithFrame:rc];
    rc.origin.x += 20.0f;
    rc.size.width -= 40.0f;
    if (isIPhone5) {
        rc.origin.y += 10.0f;
    } else {
        rc.origin.y += 20.0f;
    }
    rc.size.height -= 30.0f;
    
    float controlX = 20;
    float controlY = 20;
    float controlW = rc.size.width-controlX*2;
    float controlH = 50*myAppDelegate.multiple;
    self.payButton = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    [self.payButton setBackgroundImage:[UIImage imageNamed:@"green-normal"] forState:UIControlStateNormal];
    self.payButton.titleLabel.font = [UIFont systemFontOfSize:20*myAppDelegate.multiple];
    [self.payButton setTitle:@"支付" forState:UIControlStateNormal];
    [self.payButton addTarget:self action:@selector(payButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.payButton];
    
    _tableView.tableFooterView = view;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity == nil) {
        return;
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *payDic = [userDefault objectForKey:userEntity.name];
    if (payDic) {
        //提示用户恢复充值，重新连接服务器
        [HHAlertSingleView showAlertWithStyle:HHAlertStyleOk inView:[UIApplication sharedApplication].keyWindow Title:@"恢复支付" detail:@"上一次支付有误，\r\n点击“确定”恢复支付" cancelButton:nil Okbutton:@"确定" block:^(HHAlertButton buttonindex) {
            //延时触发，避免两个弹框冲突
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showMBProgressHUD:@"恢复支付"];
                [self inAppPurchase_ConnectServer:payDic[KHBPayReceipt] transactionID:payDic[KHBPayTransID]];
            });
        }];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //取消充值
    [self.skPayService cancelTier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoginAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你尚未登录，无法完成此操作！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"马上登录", nil];
    [alertView show];
}

#pragma mark - actionSheetDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [Navigator pushLoginControllerNow];
    }
}

-(void)payButtonPressed
{
    if ([[HBDataSaveManager defaultManager] userEntity] == nil) {
        [self showLoginAlert];
        return;
    }
    [self showMBProgressHUD:@"正在连接支付..."];
    [[HBSKPayService defaultService] requestTierByMonth:_months];
    
//    NSString *checkedStr = [self.payModeDic objectForKey:@"checked"];
//    if ([checkedStr isEqualToString:@"pay-icn-alipay"]) { //支付宝支付
//        [self requestChannelOrder:KLeaderAliPay];
//    } else if ([checkedStr isEqualToString:@"pay-icn-wechat"]){ //微信支付
//        [self requestChannelOrder:KLeaderWXPay];
//    } else { //VIP码
//        [self requestVipOrder];
//    }
}

-(void)requestVipOrder
{
    if ([_textFieldStr length] == 0) {
        [MBHudUtil showTextView:@"请输入VIP码" inView:nil];
        return;
    }
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        [MBHudUtil showActivityView:nil inView:nil];
        [[HBServiceManager defaultManager] requestVipOrder:userEntity.name vip_code:_textFieldStr product:@"kwb0001" completion:^(id responseObject, NSError *error) {
//            [MBHudUtil hideActivityView:nil];
            if([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]){
                [MBHudUtil showTextViewAfter:@"VIP码充值成功"];
            }else{
                [MBHudUtil showTextViewAfter:@"VIP码充值失败"];
            }
        }];
    }
}

- (void)requestChannelOrder:(NSString *)channel
{
    [MBHudUtil showActivityView:nil inView:nil];
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBServiceManager defaultManager] requestChannelOrder:userEntity.name channel:channel quantity:_months product:@"kwb0001" completion:^(id responseObject, NSError *error) {
        [MBHudUtil hideActivityView:nil];
        if (error.code == 0) {
            if (responseObject == nil) {
                [MBHudUtil showTextViewAfter:@"支付失败，请重新支付"];
                return;
            }
            if ([channel isEqualToString:KLeaderAliPay]) {
                [self handleAliPay:responseObject];
            } else if ([channel isEqualToString:KLeaderWXPay]) {
                [self handleWXPay:responseObject];
            }
        } else {
            [MBHudUtil showTextViewAfter:@"支付失败，请重新支付"];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
//    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (0 == section) {
        return 1;
    } else {
#if KEnableThirdPay
        return 4;
#else
        return 1;
#endif
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return 320*myAppDelegate.multiple;
    }else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.section)
    {
        HBPayViewControllerMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:KHBPayViewControllerMoneyCellReuseId];
        if (!cell) {
            cell = [[HBPayViewControllerMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KHBPayViewControllerMoneyCellReuseId];
        }
        
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        HBPayViewControllerModeCell *cell = [tableView dequeueReusableCellWithIdentifier:KHBPayViewControllerCellModeReuseId];
        
        NSInteger index = indexPath.row;
        if (0 == index) {
            if (!cell) {
                cell = [[HBPayViewControllerModeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KHBPayViewControllerCellModeReuseId showModeText:YES];
            }
            [self.payModeDic setObject:@"pay-normal" forKey:@"iconImg"];
            [self.payModeDic setObject:@"其他支付" forKey:@"modeLabel"];
        } else if (1 == index) {
            if (!cell) {
                cell = [[HBPayViewControllerModeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KHBPayViewControllerCellModeReuseId showModeText:YES];
            }
            [self.payModeDic setObject:@"pay-icn-alipay" forKey:@"iconImg"];
            [self.payModeDic setObject:@"支付宝支付" forKey:@"modeLabel"];
        } else if (2 == index){
            if (!cell) {
                cell = [[HBPayViewControllerModeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KHBPayViewControllerCellModeReuseId showModeText:YES];
            }
            
            [self.payModeDic setObject:@"pay-icn-wechat" forKey:@"iconImg"];
            [self.payModeDic setObject:@"微信支付" forKey:@"modeLabel"];
        } else {
            if (!cell) {
                cell = [[HBPayViewControllerModeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KHBPayViewControllerCellModeReuseId showModeText:NO];
            }
            
            [self.payModeDic setObject:@"pay-icn-voucher" forKey:@"iconImg"];
            [self.payModeDic setObject:@"VIP码" forKey:@"modeLabel"];
        }
        
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor blackColor];
        [cell updateFormData:self.payModeDic checkedName:[self.payModeDic objectForKey:@"checked"]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)payCellChecked:(NSString *)cellText
{
    _textFieldStr = @"";
    [self.payModeDic setObject:cellText forKey:@"checked"];
    [_tableView reloadData];
}

- (void)textFieldDidChange:(NSString *)str
{
    _textFieldStr = str;
}

- (void)textFieldDidBegin:(id)sender
{
    if (_tableView) {
        [_tableView setContentOffset:CGPointMake(0, 200) animated:YES];
    }
}

- (void)textFieldDidEnd:(id)sender
{
    if (_tableView) {
        [_tableView setContentOffset:CGPointMake(0, -60) animated:YES];
    }
}

-(void)rightButtonPressed
{
    if ([[HBDataSaveManager defaultManager] userEntity] == nil) {
        [self showLoginAlert];
        return;
    }
    HBBillViewController *vc = [[HBBillViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)HBPaySelectMonth:(NSInteger)months money:(CGFloat)money
{
    self.months = months;
    self.money = money;
}

#pragma mark - AliPay

- (void)handleAliPay:(NSDictionary *)orderDict
{
#if KEnableThirdPay
    NSDictionary *paymentDict = [orderDict dicForKey:@"payment_params"];
    
    Order *order = [[Order alloc] init];
    order.partner = [paymentDict stringForKey:@"partner"];
    order.seller = [paymentDict stringForKey:@"seller_id"];
    order.tradeNO = [orderDict stringForKey:@"order_no"]; //订单ID(由商家自行制定)
    order.productName = [orderDict stringForKey:@"subject"]; //商品标题
    order.productDescription = [orderDict stringForKey:@"body"]; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[[orderDict stringForKey:@"price"] floatValue]]; //商品价格
    order.notifyURL = [paymentDict stringForKey:@"notify_url"]; //回调URL
    order.service = [paymentDict stringForKey:@"service"];
    order.paymentType = [paymentDict stringForKey:@"payment_type"];
    order.inputCharset = [paymentDict stringForKey:@"_input_charset"];
    order.itBPay = [paymentDict stringForKey:@"it_b_pay"];
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"LeaderDiandu";
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    NSString *privateKey = [paymentDict stringForKey:@"rsa_private"];
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式 NSString *orderString = nil;
    if (signedString != nil) {
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //【callback 处理支付结果】
            NSLog(@"reslut = %@",resultDic);
        }];
    }
#endif
}

#pragma mark - WXPay

- (void)handleWXPay:(NSDictionary *)orderDict
{
#if KEnableThirdPay
    //从服务器获取支付参数，服务端自定义处理逻辑和格式
    NSDictionary *orderParams = orderDict[@"order_params"];
    if ( orderParams != nil) {
        NSMutableString *stamp  = [orderParams objectForKey:@"timestamp"];
        NSString *appID = [orderParams objectForKey:@"appid"];
        APP_DELEGATE.wxAppId = appID;
        [WXApi registerApp:appID];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = appID;
        req.partnerId           = [orderParams objectForKey:@"partnerid"];
        req.prepayId            = [orderParams objectForKey:@"prepayid"];
        req.nonceStr            = [orderParams objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [orderParams objectForKey:@"package"];
        req.sign                = [orderParams objectForKey:@"sign"];
        [WXApi sendReq:req];
    }
#endif
}

- (void)showMBProgressHUD:(NSString *)string
{
    [MBHudUtil showActivityView:string inView:nil];
//    [self hideMBProgressHUD];
//    self.progressView = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
//    self.progressView.detailsLabelText = string;
//    self.progressView.detailsLabelFont = [UIFont systemFontOfSize:13];
//    [self.progressView show:YES];
}

- (void)hideMBProgressHUD
{
    [MBHudUtil hideActivityView:nil];
//    if (self.progressView) {
//        [self.progressView removeFromSuperview];
//        self.progressView = nil;
//    }
}

#pragma mark - Timer
- (void)startTimer
{
    [self endTimer];
    self.mtimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
}

- (void)endTimer
{
    if (_mtimer) {
        [_mtimer invalidate];
        _mtimer = nil;
    }
}

- (void)handleTimer:(NSTimer *)timer
{
    //取消魔豆充值
    [self.skPayService cancelTier];
    [self hideMBProgressHUD];
    [MBHudUtil showTextView:@"网络异常，请检查网络连接" inView:nil];
}

#pragma mark ------HBSKPayServiceDelegate
/**
 *  获取商品信息
 */
-(void)inAppPurchase_LoadProduct:(NSString*)msg
{
    self.progressView.detailsLabelText = msg;
}
/**
 *  获取商品信息失败
 */
-(void)inAppPurchase_LoadProductFail
{
    [self hideMBProgressHUD];
    [self endTimer];
    [MBHudUtil showTextView:@"从AppStore获取商品失败" inView:nil];
}
/**
 *  开始支付
 */
-(void)inAppPurchase_InPay
{
    [self endTimer];
    [self showMBProgressHUD:@"正在支付..."];
}
/**
 *  支付成功
 */
-(void)inAppPurchase_PaySuccess
{
    self.progressView.detailsLabelText = @"支付成功";
}
/**
 *  支付失败
 */
-(void)inAppPurchase_PayFail:(NSString*)errorMsg
{
    [self hideMBProgressHUD];
    [self endTimer];
    [MBHudUtil showTextView:@"支付失败" inView:nil];
}
/**
 *  支付恢复
 */
-(void)inAppPurchase_PayRestored
{
//    self.progressView.detailsLabelText = @"恢复充值";
}
/**
 *  连接服务器
 */
-(void)inAppPurchase_ConnectServer:(NSString*)payReceipt transactionID:(NSString *)transactionID
{
    self.progressView.detailsLabelText = @"连接服务器";
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    NSInteger month = self.months;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *payDic = [userDefault objectForKey:userEntity.name];
    if (payDic) {
        month = [payDic[KHBPayMonths] integerValue];
    }
    [[HBServiceManager defaultManager] requestIAPNotify:userEntity.name total_fee:_payMonthDic[@(month)] quantity:month payReceipt:payReceipt transactionID:transactionID completion:^(id responseObject, NSError *error) {
        NSString *result = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            result = responseObject[@"result"];
        }
        if ([result isEqualToString:@"OK"]) {
            //充值成功，删除payReceipt
            [userDefault removeObjectForKey:userEntity.name];
            [MBHudUtil showTextViewAfter:@"支付成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_PayVIPSuccess object:nil];
        } else {
            //存储payReceipt
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:transactionID forKey:KHBPayTransID];
            [dic setObject:payReceipt forKey:KHBPayReceipt];
            [dic setObject:@(_months) forKey:KHBPayMonths];
            [userDefault setObject:dic forKey:userEntity.name];
            [userDefault synchronize];
            [MBHudUtil showTextViewAfter:@"支付失败"];
        }
    }];
}

/**
 *  连接服务器成功
 */
-(void)inAppPurchase_ConnectServerSuccess:(NSString*)errorMsg
{
    
}
/**
 *  连接服务器失败
 */
-(void)inAppPurchase_ConnectServerFail:(NSString*)errorMsg
{
//    [HHAlertSingleView showAlertWithStyle:HHAlertStyleError inView:[UIApplication sharedApplication].keyWindow Title:@"充值失败" detail:errorMsg cancelButton:nil Okbutton:@"确定" block:^(HHAlertButton buttonindex) {
//        
//    }];
}

@end
