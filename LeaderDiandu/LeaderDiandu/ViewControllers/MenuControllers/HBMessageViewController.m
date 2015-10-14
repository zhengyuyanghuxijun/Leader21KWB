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

static NSString * const KMessageViewControllerAccessoryReuseId = @"KMessageViewControllerAccessoryReuseId";

@interface HBMessageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *msgArr;

@end

@implementation HBMessageViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.msgArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"消息中心";
    
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
    NSDictionary *dict = [[HBDataSaveManager defaultManager] loadUser];
    if (dict) {
        NSString *user = [dict objectForKey:@"name"];
        NSString *token = [dict objectForKey:@"token"];
        
        //1443248966 是临时用来测试的时间，后续需要改成正式的！
        [[HBServiceManager defaultManager] requestSystemMsg:user token:token from_time:@"1443248966" completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                NSArray *arr = [responseObject arrayForKey:@"messages"];
                for (NSDictionary *dic in arr)
                {
                    HBSystemMsgEntity *msgEntity = [[HBSystemMsgEntity alloc] init];
                    msgEntity.systemMsgId = [NSString stringWithFormat:@"%ld", [dic integerForKey:@"id"]];
                    msgEntity.body = [dic stringForKey:@"body"];
                    msgEntity.user_id = [NSString stringWithFormat:@"%ld", [dic integerForKey:@"user_id"]];
                    NSTimeInterval interval = [[dic numberForKey:@"created_time"] doubleValue];
                    msgEntity.created_time = [TimeIntervalUtils getStringMDHMSFromTimeInterval:interval];
                    
                    [self.msgArr addObject:msgEntity];
                }
                
                //获取消息成功保存数据库
                [[HBMsgEntityDB sharedInstance] updateHBMsgEntity:self.msgArr];
                
                //从数据库读取本地所有消息内容
                NSMutableArray *localMsgArr = [[HBMsgEntityDB sharedInstance] getAllMsgEntity];
                NSString *localMaxMsgId = @"";
                NSString *newMaxMsgId = @"";
                if (localMsgArr.count > 0) {
                    HBSystemMsgEntity *msgEntity = [localMsgArr objectAtIndex:0];
                    localMaxMsgId = msgEntity.systemMsgId;
                }
                
                NSArray *array = [responseObject arrayForKey:@"messages"];
                for (NSDictionary *dic in array)
                {
                    newMaxMsgId = [NSString stringWithFormat:@"%ld", [dic integerForKey:@"id"]];
                    break;
                }
                
                //如果新的消息ID值大于数据库中保存的最大消息ID值，则说明有新消息，需要显示红点
                if ([newMaxMsgId integerValue] > [localMaxMsgId integerValue]) {
                    [AppDelegate delegate].hasNewMsg = YES;
                }else{
                    [AppDelegate delegate].hasNewMsg = NO;
                }
                
                //获取新消息列表成功后发送通知
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_GetMsgSuccess object:nil];
                
                if (self.msgArr.count > 0) {
                    [self addTableView];
                }
            }
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
    NSParameterAssert(self.msgArr);
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
