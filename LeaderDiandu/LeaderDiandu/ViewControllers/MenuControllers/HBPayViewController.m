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

static NSString * const KHBPayViewControllerMoneyCellReuseId = @"KHBPayViewControllerMoneyCellReuseId";
static NSString * const KHBPayViewControllerCellModeReuseId = @"KHBPayViewControllerCellModeReuseId";

@interface HBPayViewController ()<UITableViewDataSource, UITableViewDelegate, HBPayCellChangeDelegate>
{
    UITableView *_tableView;
    NSString *_textFieldStr;
}

@property (nonatomic, strong) UIButton* payButton;
@property (nonatomic, strong) NSMutableDictionary *payModeDic;

@end

@implementation HBPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"支付中心";
    
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
    rc.origin.y += 20.0f;
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
        
    }else if([checkedStr isEqualToString:@"pay-icn-wechat"]){ //微信支付
        [MBHudUtil showTextView:@"暂不支持微信支付，敬请期待" inView:nil];
    }else{ //VIP码
        [self requestVipOrder];
    }
}

-(void)requestVipOrder
{
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
        return 250;
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

-(void)rightButtonPressed
{
    HBBillViewController *vc = [[HBBillViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
