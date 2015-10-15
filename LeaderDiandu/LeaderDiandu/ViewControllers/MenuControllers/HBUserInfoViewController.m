//
//  HBUserInfoViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/2.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBUserInfoViewController.h"
#import "HBServiceManager.h"
#import "HBEditNameViewController.h"
#import "HBBindPhoneViewController.h"
#import "HBDataSaveManager.h"
#import "HBHeaderManager.h"

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
    
    _titleArr = @[@"账号", @"姓名", @"手机", @"修改密码"];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"个人中心";
    
    CGRect rect = self.view.frame;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    [self getUserInfo];
    [self getHeaderAvatar];
}

- (void)getHeaderAvatar
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBHeaderManager defaultManager] requestGetAvatar:userEntity.name token:userEntity.token completion:^(id responseObject, NSError *error) {
        
    }];
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
    float controlW = 70;
    float controlH = 25;
    float controlX = (screenWidth-imgWidth-controlW)/2;
    float controlY = (200-imgWidth)/2;
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(controlX, controlY, imgWidth, imgWidth)];
    headView.image = [UIImage imageNamed:@"menu_user_pohoto"];
    [view addSubview:headView];
    
    controlX += imgWidth+10;
    controlY += (imgWidth-controlH) / 2;
    UIView *typeView = [self createTypeView:CGRectMake(controlX, controlY, controlW, controlH)];
    [view addSubview:typeView];
    
    return view;
}

- (UIView *)createTypeView:(CGRect)frame
{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:frame];
    UILabel *typeLbl = [[UILabel alloc] initWithFrame:bgView.bounds];
    typeLbl.textAlignment = NSTextAlignmentCenter;
    typeLbl.textColor = [UIColor whiteColor];
    typeLbl.font = [UIFont systemFontOfSize:16];
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity.type == 1) {
        if (userEntity.vip_time == 0) {
            typeLbl.text = @"普通用户";
            bgView.image = [UIImage imageNamed:@"studentmanage-bg-normal-user"];
        } else {
            NSTimeInterval cur = [NSDate date].timeIntervalSince1970;
            if (userEntity.vip_time < cur) {
                //vip过期
                typeLbl.text = @"VIP过期";
                bgView.image = [UIImage imageNamed:@"studentmanage-bg-vipover-user"];
            } else {
                typeLbl.text = @"VIP会员";
                bgView.image = [UIImage imageNamed:@"studentmanage-bg-vip-user"];
            }
        }
    } else if (userEntity.type == 10) {
        typeLbl.text = @"教师";
        bgView.image = [UIImage imageNamed:@"studentmanage-bg-normal-user"];
    } else {
        typeLbl.text = @"教研员";
        bgView.image = [UIImage imageNamed:@"studentmanage-bg-normal-user"];
    }
    [bgView addSubview:typeLbl];
    return bgView;
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
            UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-40, 10, 20, 20)];
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
    } else if (index == 2) {
        valueLbl.text = userEntity.phone;
    } else if (index == 3) {
        valueLbl.text = @"******";
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
