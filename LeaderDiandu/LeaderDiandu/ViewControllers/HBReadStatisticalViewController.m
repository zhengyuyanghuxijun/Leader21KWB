//
//  HBReadStatisticalViewController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/17.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBReadStatisticalViewController.h"
#import "HBWeekUtil.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"
#import "HBReadStatisticalLogoCell.h"
#import "HBReadStatisticalDateCell.h"
#import "HBReadStatisticalStuNumCell.h"
#import "HBReadStatisticalContentCell.h"

@interface HBReadStatisticalViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, assign)NSInteger weekOfYear;  //一年中的第几周
@property (nonatomic, assign)NSInteger bookset_id;  //套餐ID
@property (nonatomic, assign)NSInteger student_total;  //总人数
@property (nonatomic, assign)NSInteger student_read;  //阅读人数
@property (nonatomic, assign)NSInteger reading_count;  //阅读总量
@property (nonatomic, assign)NSInteger book_count;  //书籍总量
@property (nonatomic, assign)NSInteger reading_time;  //阅读总时长

@end

@implementation HBReadStatisticalViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINavigationBar *naviBar = self.navigationController.navigationBar;
    //设置navigationBar背景颜色
    [naviBar setBarTintColor:[UIColor colorWithHex:0x1E90FF]];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"阅读统计";
    
    self.weekOfYear = [[HBWeekUtil sharedInstance] getWeekOfYear];
    self.bookset_id = 1;
    
    //阅读人数统计
    [self requestReadingStudent];
    //阅读次数统计
    [self requestReadingTimes];
    //阅读时长统计
    [self requestReadingTime];
    
    [self addTableView];
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

-(void)requestReadingStudent
{
    NSMutableDictionary *dateDic = [[HBWeekUtil sharedInstance] getWeekBeginAndEndWith:nil];
    
    NSDate *beginDate = [dateDic objectForKey:@"beginDate"];
    NSDate *endDate = [dateDic objectForKey:@"endDate"];
    
    NSString *beginDateStr = [NSString stringWithFormat:@"%.f",[beginDate timeIntervalSince1970]];
    NSString *endDateStr = [NSString stringWithFormat:@"%.f",[endDate timeIntervalSince1970]];
    
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        [[HBServiceManager defaultManager] requestReadingStudent:[NSString stringWithFormat:@"%ld", userEntity.userid] bookset_id:[NSString stringWithFormat:@"%ld", self.bookset_id] from_time:beginDateStr to_time:endDateStr completion:^(id responseObject, NSError *error) {
            
        }];
    }
}

-(void)requestReadingTimes
{
    //当前时间
    NSDate *date = [NSDate date];
    NSString *testTime = [NSString stringWithFormat:@"%.f",[date timeIntervalSince1970]];
    
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        [[HBServiceManager defaultManager] requestReadingTimes:[NSString stringWithFormat:@"%ld", userEntity.userid] bookset_id:[NSString stringWithFormat:@"%ld", self.bookset_id] from_time:@"1443248966" to_time:testTime completion:^(id responseObject, NSError *error) {
            
        }];
    }
}

-(void)requestReadingTime
{
    //当前时间
    NSDate *date = [NSDate date];
    NSString *testTime = [NSString stringWithFormat:@"%.f",[date timeIntervalSince1970]];
    
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        [[HBServiceManager defaultManager] requestReadingTime:[NSString stringWithFormat:@"%ld", userEntity.userid] bookset_id:[NSString stringWithFormat:@"%ld", self.bookset_id] from_time:@"1443248966" to_time:testTime completion:^(id responseObject, NSError *error) {
            
        }];
    }
}

-(void)addTableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, ScreenHeight)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = NO;
        [self.view addSubview:_tableView];
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
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    if (0 == indexPath.row) {
        height = 120.0f;
    }else if (1 == indexPath.row){
        height = 50.0f;
    }else if (2 == indexPath.row){
        height = 50.0f;
    }else{
        height = 300.0f;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        HBReadStatisticalLogoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBReadStatisticalLogoCellReuseId"];
        if (!cell) {
            cell = [[HBReadStatisticalLogoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HBReadStatisticalLogoCellReuseId"];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (1 == indexPath.row){
        HBReadStatisticalDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBReadStatisticalDateCellReuseId"];
        if (!cell) {
            cell = [[HBReadStatisticalDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HBReadStatisticalDateCellReuseId"];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (2 == indexPath.row){
        HBReadStatisticalStuNumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBReadStatisticalStuNumCellReuseId"];
        if (!cell) {
            cell = [[HBReadStatisticalStuNumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HBReadStatisticalStuNumCellReuseId"];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        HBReadStatisticalContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBReadStatisticalContentCellReuseId"];
        if (!cell) {
            cell = [[HBReadStatisticalContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HBReadStatisticalContentCellReuseId"];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
