//
//  HBSettingViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/1.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBSettingViewController.h"
#import "HBBookManViewController.h"
#import "HBAboutViewController.h"

#import "HBServiceManager.h"
#import "GuideView.h"
#import "HBSettingViewCell.h"

static NSString * const KSettingViewControllerCellSwitchReuseId = @"KSettingViewControllerCellSwitchReuseId";
static NSString * const KSettingViewControllerCellAccessoryReuseId = @"KSettingViewControllerCellAccessoryReuseId";

@interface HBSettingViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSArray     *_titleArr;
    UITableView *_tableView;
}

@property (nonatomic, strong) UIButton* logoutButton;
@property (nonatomic, assign) NSInteger current_version;

@end

@implementation HBSettingViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.current_version = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _titleArr = @[@"仅用WiFi下载图书", @"显示英文书名", @"本地图书管理", @"欢迎页", @"关于课外宝"];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"设置";
    
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
    
    self.logoutButton = [[UIButton alloc] initWithFrame:rc];
    [self.logoutButton setBackgroundImage:[UIImage imageNamed:@"user_button"] forState:UIControlStateNormal];
    [self.logoutButton setTitle:@"退出帐号" forState:UIControlStateNormal];
    [self.logoutButton addTarget:self action:@selector(logoutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.logoutButton];
    _tableView.tableFooterView = view;
}

- (void)logoutButtonPressed:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要退出账号？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 0;
    
    [alertView show];
}

#pragma mark - actionSheetDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        //升级
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreUrl]];
        return;
    }
    if (buttonIndex == 1){
        //to do 注销...
        HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
        [[HBServiceManager defaultManager] requestLogout:userEntity.name token:userEntity.token completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                NSDictionary *dic = responseObject;
                if ([dic[@"result"] isEqualToString:@"OK"]) {
                    //注销成功
                    [[HBDataSaveManager defaultManager] clearUserData];
                    [Navigator pushLoginController];
                }
            }
        }];
    }
}

- (void)wifiDownload:(id)sender
{
    BOOL aWifiDownload = YES;
    UISwitch *aSwitch = (UISwitch *)sender;
    if (aSwitch.isOn) {
        aWifiDownload = YES;
    }else{
        aWifiDownload = NO;
    }
    
    BOOL aShowEnBookName = [[HBDataSaveManager defaultManager] showEnBookName];
    NSString *wifiDownloadStr = [NSString stringWithFormat:@"%d", aWifiDownload];
    NSString *showEnBookNameStr = [NSString stringWithFormat:@"%d", aShowEnBookName];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:wifiDownloadStr, @"wifidownload", showEnBookNameStr, @"showenbookname", nil];
    
    [[HBDataSaveManager defaultManager] saveSettingsByDict:dict];
}

- (void)showEnglishName:(id)sender
{
    BOOL aShowEnBookName = YES;
    UISwitch *aSwitch = (UISwitch *)sender;
    if (aSwitch.isOn) {
        aShowEnBookName = YES;
    }else{
        aShowEnBookName = NO;
    }
    
    BOOL aWifiDownload = [[HBDataSaveManager defaultManager] wifiDownload];
    NSString *wifiDownloadStr = [NSString stringWithFormat:@"%d", aWifiDownload];
    NSString *showEnBookNameStr = [NSString stringWithFormat:@"%d", aShowEnBookName];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:wifiDownloadStr, @"wifidownload", showEnBookNameStr, @"showenbookname", nil];
    
    [[HBDataSaveManager defaultManager] saveSettingsByDict:dict];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(_titleArr);
    
    if(indexPath.row == 0)
    {
        HBSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KSettingViewControllerCellSwitchReuseId];
        if (!cell) {
            cell = [[HBSettingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KSettingViewControllerCellSwitchReuseId];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.mainLabel.text = [_titleArr objectAtIndex:indexPath.row];
        cell.describeLabel.text = @"仅用WiFi下载，避免使用2G/3G流量";
        cell.textLabel.textColor = [UIColor blackColor];
        
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchView addTarget:self action:@selector(wifiDownload:) forControlEvents:UIControlEventValueChanged];
        if ([[HBDataSaveManager defaultManager] wifiDownload]) {
            [switchView setOn:YES];
        }else{
            [switchView setOn:NO];
        }

        cell.accessoryView = switchView;
        return cell;
    }
    else if(indexPath.row == 1)
    {
        HBSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KSettingViewControllerCellSwitchReuseId];
        if (!cell) {
            cell = [[HBSettingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KSettingViewControllerCellSwitchReuseId];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.mainLabel.text = [_titleArr objectAtIndex:indexPath.row];
        cell.describeLabel.text = @"默认显示中文书名";
        cell.textLabel.textColor = [UIColor blackColor];
        
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchView addTarget:self action:@selector(showEnglishName:) forControlEvents:UIControlEventValueChanged];
        if ([[HBDataSaveManager defaultManager] showEnBookName]) {
            [switchView setOn:YES];
        }else{
            [switchView setOn:NO];
        }

        cell.accessoryView = switchView;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KSettingViewControllerCellAccessoryReuseId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KSettingViewControllerCellAccessoryReuseId];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [_titleArr objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2){
        HBBookManViewController *vc = [[HBBookManViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 3)
    /*{
        [MBHudUtil showActivityView:nil inView:nil];
        [[HBServiceManager defaultManager] requestCheckUpdate:@"ios" current_version:self.current_version branch:@"dev" completion:^(id responseObject, NSError *error) {
            [MBHudUtil hideActivityView:nil];
            if (responseObject) {
                NSDictionary *dic = responseObject;
                NSInteger latest_version = [[dic objectForKey:@"latest_version"] integerValue];
                if (latest_version == self.current_version) {
                    [MBHudUtil showTextView:@"当前已是最新版本" inView:nil];
                } else if (latest_version > self.current_version) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"升级" message:@"当前不是最新版本，是否升级？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即升级", nil];
                    alertView.tag = 1001;
                    [alertView show];
                }
            }
        }];
    } else if (indexPath.row == 4)*/
    {
        [GuideView showGuideViewAnimated:YES];
    }else if (indexPath.row == 4){
        HBAboutViewController *vc = [[HBAboutViewController alloc] init];
        NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
        NSString *mainVersion = [dict objectForKey:@"CFBundleShortVersionString"];
        NSString *buildVersion = [dict objectForKey:@"CFBundleVersion"];
        NSString *localVersion = [NSString stringWithFormat:@"%@.%@", mainVersion, buildVersion];
        [vc setVersionStr:localVersion];
        [self.navigationController pushViewController:vc animated:YES];
    }
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