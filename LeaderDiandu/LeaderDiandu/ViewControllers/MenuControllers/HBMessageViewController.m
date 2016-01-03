//
//  HBMessageViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/1.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBMessageViewController.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"
#import "HBSystemMsgEntity.h"
#import "TimeIntervalUtils.h"
#import "HBMessageViewCell.h"
#import "HBMsgEntityDB.h"
#import "HBTableView.h"

static NSString * const KMessageViewControllerAccessoryReuseId = @"KMessageViewControllerAccessoryReuseId";

@interface HBMessageViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    HBTableView *_tableView;
}

@property (nonatomic, strong) NSArray *msgArr;

@end

@implementation HBMessageViewController

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
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"消息中心";
    
    [self addTableView];
    [self requestSystemMsg];
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

-(void)requestSystemMsg
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        NSString *user = userEntity.name;
        NSString *token = userEntity.token;
        
        [MBHudUtil showActivityView:nil inView:nil];
        //1433248966 是临时用来测试的时间，后续需要改成正式的！
        [[HBServiceManager defaultManager] requestSystemMsg:user from_time:@"1433248966" completion:^(id responseObject, NSError *error) {
            [MBHudUtil hideActivityView:nil];
            if (responseObject) {
                NSMutableArray *msgArr = [[NSMutableArray alloc] initWithCapacity:1];
                NSArray *arr = [responseObject arrayForKey:@"messages"];
                for (NSDictionary *dic in arr)
                {
                    HBSystemMsgEntity *msgEntity = [[HBSystemMsgEntity alloc] init];
                    msgEntity.systemMsgId = [NSString stringWithFormat:@"%ld", (long)[dic integerForKey:@"id"]];
                    msgEntity.body = [dic stringForKey:@"body"];
                    msgEntity.user_id = [NSString stringWithFormat:@"%ld", (long)[dic integerForKey:@"user_id"]];
                    NSTimeInterval interval = [[dic numberForKey:@"created_time"] doubleValue];
                    msgEntity.created_time = [TimeIntervalUtils getStringMDHMSFromTimeInterval:interval];
                    
                    [msgArr addObject:msgEntity];
                }
                
                if (msgArr.count > 0) {
                    self.msgArr = [msgArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                        HBSystemMsgEntity *entity1 = obj1;
                        HBSystemMsgEntity *entity2 = obj2;
                        NSComparisonResult result = [entity1.created_time compare:entity2.created_time];
                        return result == NSOrderedAscending;
                    }];
                    
                    [_tableView reloadData];
                
                    //获取消息成功保存数据库
                    [[HBMsgEntityDB sharedInstance] updateHBMsgEntity:self.msgArr];
                    //获取到最新数据了，要去掉红点提示
                    [AppDelegate delegate].hasNewMsg = NO;
                    //获取新消息列表成功后发送通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_GetMsgSuccess object:nil];
                } else {
                    [_tableView showEmptyView:@"msg_tip_empty" tips:@"暂无系统消息"];
                }
            }
        }];
    }
}

-(void)addTableView
{
    if (_tableView == nil) {
        _tableView = [[HBTableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, ScreenHeight)];
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
    return self.msgArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(self.msgArr);
    
    HBMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KMessageViewControllerAccessoryReuseId];
    if (!cell) {
        cell = [[HBMessageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KMessageViewControllerAccessoryReuseId];
    }
    
    HBSystemMsgEntity *msgEntity = [self.msgArr objectAtIndex:indexPath.row];
    
    [cell updateFormData:msgEntity];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
