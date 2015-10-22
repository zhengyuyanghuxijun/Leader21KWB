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
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

static NSString * const KHBPayViewControllerMoneyCellReuseId = @"KHBPayViewControllerMoneyCellReuseId";
static NSString * const KHBPayViewControllerCellModeReuseId = @"KHBPayViewControllerCellModeReuseId";

@interface HBPayViewController ()<UITableViewDataSource, UITableViewDelegate, HBPayCellChangeDelegate, HBPayMoneyCellDelegate>
{
    UITableView *_tableView;
    NSString *_textFieldStr;
}

@property (nonatomic, strong) UIButton* payButton;
@property (nonatomic, strong) NSMutableDictionary *payModeDic;
@property (nonatomic, strong) NSDictionary *orderDict;

@property (nonatomic, assign) NSInteger months;
@property (nonatomic, assign) CGFloat money;

@end

@implementation HBPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"支付中心";
    
    self.months = 1;
    self.money = 10;
    
    self.payModeDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [self.payModeDic setObject:@"pay-icn-alipay" forKey:@"checked"];
    
    CGRect rect = self.view.frame;
    CGRect viewFrame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    _tableView = [[UITableView alloc] initWithFrame:viewFrame];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    CGRect rc = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 70.0f);
    UIView* view = [[UIView alloc] initWithFrame:rc];
    rc.origin.x += 20.0f;
    rc.size.width -= 40.0f;
    if (iPhone5) {
        rc.origin.y += 10.0f;
    } else {
        rc.origin.y += 20.0f;
    }
    rc.size.height -= 30.0f;
    
    self.payButton = [[UIButton alloc] initWithFrame:rc];
    [self.payButton setBackgroundImage:[UIImage imageNamed:@"green-normal"] forState:UIControlStateNormal];
    [self.payButton setTitle:@"支付" forState:UIControlStateNormal];
    [self.payButton addTarget:self action:@selector(payButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.payButton];
    
    _tableView.tableFooterView = view;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"账单" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonPressed)];
    [rightButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightButton;
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

-(void)payButtonPressed
{
    NSString *checkedStr = [self.payModeDic objectForKey:@"checked"];
    if ([checkedStr isEqualToString:@"pay-icn-alipay"]) { //支付宝支付
        [self requestChannelOrder];
    } else if ([checkedStr isEqualToString:@"pay-icn-wechat"]){ //微信支付
        [MBHudUtil showTextView:@"暂不支持微信支付，敬请期待" inView:nil];
    } else { //VIP码
        [self requestVipOrder];
    }
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

- (void)requestChannelOrder
{
    [MBHudUtil showActivityView:nil inView:nil];
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBServiceManager defaultManager] requestChannelOrder:userEntity.name token:userEntity.token channel:@"zfb" quantity:_months product:@"kwb0001" completion:^(id responseObject, NSError *error) {
        [MBHudUtil hideActivityView:nil];
        if (error.code == 0) {
            [self handleAliPay:responseObject];
        } else {
            [MBHudUtil showTextViewAfter:@"支付失败，请重新支付"];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (0 == section) {
        return 1;
    }else{
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return 320;
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
        cell.textLabel.textColor = [UIColor blackColor];
        
        return cell;
    }
    else
    {
        HBPayViewControllerModeCell *cell = [tableView dequeueReusableCellWithIdentifier:KHBPayViewControllerCellModeReuseId];
        
        if (0 == indexPath.row) {
            if (!cell) {
                cell = [[HBPayViewControllerModeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KHBPayViewControllerCellModeReuseId showModeText:YES];
            }
            [self.payModeDic setObject:@"pay-icn-alipay" forKey:@"iconImg"];
            [self.payModeDic setObject:@"支付宝支付" forKey:@"modeLabel"];
        }else if (1 == indexPath.row){
            if (!cell) {
                cell = [[HBPayViewControllerModeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KHBPayViewControllerCellModeReuseId showModeText:YES];
            }
            
            [self.payModeDic setObject:@"pay-icn-wechat" forKey:@"iconImg"];
            [self.payModeDic setObject:@"微信支付" forKey:@"modeLabel"];
        }else{
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
    [[NSDate date] timeIntervalSince1970];
    NSDictionary *paymentDict = [orderDict dicForKey:@"payment_params"];
    
    Order *order = [[Order alloc] init];
    order.partner = [paymentDict stringForKey:@"partner"];
    order.seller = [paymentDict stringForKey:@"seller_id"];
    order.tradeNO = [orderDict stringForKey:@"order_no"]; //订单ID(由商家自行制定)
    order.productName = [orderDict stringForKey:@"subject"]; //商品标题
    order.productDescription = [orderDict stringForKey:@"body"]; //商品描述
    order.amount = @"0.01";//[NSString stringWithFormat:@"%.2f",[[orderDict stringForKey:@"price"] floatValue]]; //商品价格
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
}

@end
