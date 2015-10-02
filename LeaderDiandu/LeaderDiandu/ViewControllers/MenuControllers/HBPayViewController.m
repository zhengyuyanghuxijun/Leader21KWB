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

static NSString * const KHBPayViewControllerMoneyCellReuseId = @"KHBPayViewControllerMoneyCellReuseId";
static NSString * const KHBPayViewControllerCellModeReuseId = @"KHBPayViewControllerCellModeReuseId";

@interface HBPayViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, strong) UIButton* payButton;

@end

@implementation HBPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"支付中心";
    
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
    [self.payButton setBackgroundImage:[UIImage imageNamed:@"user_button"] forState:UIControlStateNormal];
    [self.payButton setTitle:@"支付" forState:UIControlStateNormal];
    [self.payButton addTarget:self action:@selector(payButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.payButton];
    
    _tableView.tableFooterView = view;
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
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
        if (0 == indexPath.row) {
            if (!cell) {
                cell = [[HBPayViewControllerModeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KHBPayViewControllerCellModeReuseId showModeText:YES];
            }
            [cell setChecked:YES];
            [dic setObject:@"pay-icn-alipay" forKey:@"iconImg"];
            [dic setObject:@"支付宝支付" forKey:@"modeLabel"];
        }else if (1 == indexPath.row){
            if (!cell) {
                cell = [[HBPayViewControllerModeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KHBPayViewControllerCellModeReuseId showModeText:YES];
            }
            
            [dic setObject:@"pay-icn-wechat" forKey:@"iconImg"];
            [dic setObject:@"微信支付" forKey:@"modeLabel"];
        }else{
            if (!cell) {
                cell = [[HBPayViewControllerModeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KHBPayViewControllerCellModeReuseId showModeText:NO];
            }
            
            [dic setObject:@"pay-icn-voucher" forKey:@"iconImg"];
            [dic setObject:@"VIP码" forKey:@"modeLabel"];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor blackColor];
        [cell updateFormData:dic];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
