//
//  HBLeaderViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/2.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBLeaderViewController.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"

static NSString * const KLeaderViewControllerCellReuseId = @"KUserInfoViewControllerCellReuseId";

@interface HBLeaderViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray     *_titleArr;
    UITableView *_tableView;
}

@property (strong, nonatomic) NSString *accountStr;
@property (strong, nonatomic) NSString *nameStr;

@end

@implementation HBLeaderViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.accountStr = nil;
        self.nameStr = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _titleArr = @[@"账号", @"姓名"];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"我的教研员";
    
    [self getUserInfo];
    
    CGRect rect = self.view.frame;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

- (void)getUserInfo
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBServiceManager defaultManager] requestUserInfo:userEntity.name token:userEntity.token completion:^(id responseObject, NSError *error) {
        if (responseObject) {
            NSDictionary *dic = [responseObject objectForKey:@"director"];
            if (dic) {
                self.accountStr = [dic objectForKey:@"name"];
                self.nameStr = [dic objectForKey:@"display_name"];
                [_tableView reloadData];
            }else{
                //获取教研员列表。。。（等待提供接口）
            }
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSParameterAssert(_titleArr);
    return _titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger imgWidth = 100;
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIView *view = [[UIView alloc] init];
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-imgWidth)/2, (200-imgWidth)/2, imgWidth, imgWidth)];
    headView.image = [UIImage imageNamed:@"menu_user_pohoto"];
    [view addSubview:headView];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(_titleArr);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KLeaderViewControllerCellReuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KLeaderViewControllerCellReuseId];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [_titleArr objectAtIndex:indexPath.row];
    
    if (0 == indexPath.row) {
        cell.textLabel.text = self.accountStr;
    }else{
        cell.textLabel.text = self.nameStr;
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
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

@end
