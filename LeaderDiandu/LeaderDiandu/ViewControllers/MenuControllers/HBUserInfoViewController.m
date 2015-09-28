//
//  HBUserInfoViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/2.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBUserInfoViewController.h"
#import "UIViewController+AddBackBtn.h"
#import "HBTitleView.h"
#import "HBServiceManager.h"
#import "HBEditNameViewController.h"
#import "HBBindPhoneViewController.h"
#import "HBDataSaveManager.h"

static NSString * const KUserInfoViewControllerCellReuseId = @"KUserInfoViewControllerCellReuseId";

@interface HBUserInfoViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray     *_titleArr;
    UITableView *_tableView;
}

@end

@implementation HBUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _titleArr = @[@"账号", @"姓名", @"手机"];
    
    HBTitleView *labTitle = [HBTitleView titleViewWithTitle:@"个人中心" onView:self.view];
    [self.view addSubview:labTitle];
    
    [self addBackButton];
    
    CGRect rect = self.view.frame;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KHBNaviBarHeight, rect.size.width, rect.size.height-KHBNaviBarHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    [self getUserInfo];
}

- (void)getUserInfo
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBServiceManager defaultManager] requestUserInfo:userEntity.name token:userEntity.token completion:^(id responseObject, NSError *error) {
        if (responseObject) {
            [[HBDataSaveManager defaultManager] setUserEntityByDict:responseObject];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KUserInfoViewControllerCellReuseId];
    NSInteger index = indexPath.row;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KUserInfoViewControllerCellReuseId];
        float viewWidth = self.view.frame.size.width;
        float width = 200;
        UILabel *valueLbl = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth-width-40, 10, width, 20)];
        valueLbl.tag = 1001;
        valueLbl.backgroundColor = [UIColor clearColor];
        valueLbl.textColor = [UIColor lightGrayColor];
        valueLbl.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:valueLbl];
        
        if (index == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (index > 0) {
            UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-40, 20, 20, 20)];
            arrowImg.image = [UIImage imageNamed:@"menu_icon_user_open"];
            [cell.contentView addSubview:arrowImg];
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [_titleArr objectAtIndex:index];
    cell.textLabel.textColor = [UIColor blackColor];
    
    UILabel *valueLbl = (UILabel *)[cell.contentView viewWithTag:1001];
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (index == 0) {
        valueLbl.text = userEntity.name;
    } else if (index == 1) {
        valueLbl.text = userEntity.display_name;
    } else {
        valueLbl.text = userEntity.phone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    if (index == 1) {
        HBEditNameViewController *controller = [[HBEditNameViewController alloc] init];
        [[AppDelegate delegate].globalNavi pushViewController:controller animated:YES];
    } else if (index == 2) {
        HBBindPhoneViewController *controller = [[HBBindPhoneViewController alloc] init];
        [[AppDelegate delegate].globalNavi pushViewController:controller animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
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
