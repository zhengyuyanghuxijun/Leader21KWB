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
{
    UIView *_emptyView;
}

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
    
    [self addTableView];
    [self requestSystemMsg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideEmptyView
{
    if (_emptyView) {
        [_emptyView removeFromSuperview];
    }
}

- (void)showEmptyView
{
    if (_emptyView) {
        [self.view addSubview:_emptyView];
        return;
    }
    _emptyView = [[UIView alloc] initWithFrame:self.view.bounds];
    _emptyView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_emptyView];
    
    CGSize viewSize = self.view.frame.size;
    float imgSide = 80;
    float controlX = (viewSize.width-imgSide) / 2;
    float controlY = viewSize.height / 3;
    UIImageView *emptyImg = [[UIImageView alloc] initWithFrame:CGRectMake(controlX, controlY, imgSide, imgSide)];
    emptyImg.image = [UIImage imageNamed:@"msg_tip_empty"];
    [_emptyView addSubview:emptyImg];
    
    controlX = 0;
    controlY += imgSide + 20;
    UILabel *emptyLbl = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, viewSize.width, 20)];
    emptyLbl.backgroundColor = [UIColor clearColor];
    emptyLbl.textColor = [UIColor lightGrayColor];
    emptyLbl.text = @"暂无系统消息";
    emptyLbl.textAlignment = NSTextAlignmentCenter;
    [_emptyView addSubview:emptyLbl];
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
        [[HBServiceManager defaultManager] requestSystemMsg:user token:token from_time:@"1433248966" completion:^(id responseObject, NSError *error) {
            [MBHudUtil hideActivityView:nil];
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
                
                if (self.msgArr.count > 0) {
                    [_tableView reloadData];
                
                    //获取消息成功保存数据库
                    [[HBMsgEntityDB sharedInstance] updateHBMsgEntity:self.msgArr];
                    //获取到最新数据了，要去掉红点提示
                    [AppDelegate delegate].hasNewMsg = NO;
                    //获取新消息列表成功后发送通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_GetMsgSuccess object:nil];
                } else {
                    [self showEmptyView];
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
