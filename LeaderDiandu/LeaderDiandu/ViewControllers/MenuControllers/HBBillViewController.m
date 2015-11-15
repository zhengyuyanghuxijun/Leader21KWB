//
//  HBBillViewController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/12.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBBillViewController.h"
#import "HBBillViewControllerCell.h"
#import "HBServiceManager.h"
#import "HBDataSaveManager.h"
#import "HBBillEntity.h"
#import "TimeIntervalUtils.h"

static NSString * const KHBBillViewControllerCellReuseId = @"KHBBillViewControllerCellReuseId";

@interface HBBillViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, strong) NSMutableArray *billArr;

@end

@implementation HBBillViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.billArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"账单";
    
    //用户获取订单记录
    [self requestBillList];
    
    CGRect rect = self.view.frame;
    CGRect viewFrame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    _tableView = [[UITableView alloc] initWithFrame:viewFrame];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
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

-(void)requestBillList
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        [MBHudUtil showActivityView:nil inView:nil];
        [[HBServiceManager defaultManager] requestBillList:userEntity.name from_time:@"1433248966" count:50 completion:^(id responseObject, NSError *error) {
            [MBHudUtil hideActivityView:nil];
            
            NSArray *arr = [responseObject objectForKey:@"payments"];
            if (arr.count > 0) {
                [self.billArr removeAllObjects];
            }
            
            for (NSDictionary *dic in arr)
            {
                HBBillEntity *billEntity = [[HBBillEntity alloc] init];
                billEntity.type = [NSString stringWithFormat:@"%ld", (long)[dic integerForKey:@"type"]];
                billEntity.subject = [dic stringForKey:@"subject"];
                billEntity.body = [dic stringForKey:@"body"];
                NSTimeInterval interval = [[dic numberForKey:@"created_time"] doubleValue];
                billEntity.created_time = [TimeIntervalUtils getStringMDHMSFromTimeInterval:interval];
                billEntity.status = [NSString stringWithFormat:@"%ld", (long)[dic integerForKey:@"status"]];
                billEntity.total_fee = [dic stringForKey:@"total_fee"];
                
                [self.billArr addObject:billEntity];
            }
            
            [_tableView reloadData];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.billArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HBBillViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:KHBBillViewControllerCellReuseId];
    if (!cell) {
        cell = [[HBBillViewControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KHBBillViewControllerCellReuseId];
    }
    
    HBBillEntity *billEntity = [self.billArr objectAtIndex:(self.billArr.count - 1 - indexPath.row)];
    [cell updateFormData:billEntity];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
