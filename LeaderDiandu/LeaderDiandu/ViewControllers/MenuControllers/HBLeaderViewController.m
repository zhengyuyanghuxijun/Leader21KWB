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
#import "HBLeaderBindingCell.h"
#import "HBLeaderUnbindingCell.h"
#import "HBHeaderManager.h"

static NSString * const KLeaderBindingCellReuseId = @"KLeaderBindingCellReuseId";
static NSString * const KLeaderUnBindingCellReuseId = @"KLeaderUnBindingCellReuseId";

@interface HBLeaderViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    UIButton *_bottomBtn;
}

@property (strong, nonatomic) NSString *accountStr;
@property (strong, nonatomic) NSString *nameStr;

@property (nonatomic, assign) BOOL isBinding;
@property (nonatomic, strong) NSMutableArray *leadersArr;

@property (nonatomic, strong) NSMutableDictionary *leaderSelectedDic; //key为name value是否已选择

@end

@implementation HBLeaderViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.accountStr = nil;
        self.nameStr = nil;
        self.isBinding = NO;
        self.leadersArr = [[NSMutableArray alloc] initWithCapacity:1];
        self.leaderSelectedDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"我的教研员";
    
    //获取教研员信息，知道是否绑定状态
    [self getUserInfo];
    [self addTableView];
}

- (void)getUserInfo
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBServiceManager defaultManager] requestUserInfo:userEntity.name completion:^(id responseObject, NSError *error) {
        if (responseObject) {
            NSDictionary *dic = [responseObject objectForKey:@"director"];
            if (dic.count > 0) {
                //不为空，表示绑定了教研员
                self.isBinding = YES;
                self.accountStr = [dic objectForKey:@"name"];
                self.nameStr = [dic objectForKey:@"display_name"];
                [self addTableView];
                [self addBottomBtn];
                
                //获取头像
                [self getHeaderAvatar:self.accountStr];
            }else{
                //为空，表示没有绑定教研员，需要获取教研员列表
                self.isBinding = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self getDirectorList];
                });
            }
        }
    }];
}

- (void)getDirectorList
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBServiceManager defaultManager] requestDirectorList:userEntity.name completion:^(id responseObject, NSError *error) {
        NSArray *directorsArr = [responseObject objectForKey:@"directors"];
        [self.leadersArr removeAllObjects];
        for (NSDictionary *director in directorsArr) {
            [self.leadersArr addObject:director];
            [self.leaderSelectedDic setObject:@"0" forKey:[director objectForKey:@"name"]];
            //获取头像
            [self getHeaderAvatar:[director objectForKey:@"name"]];
        }
        if (self.leadersArr.count > 0) {
            [self addTableView];
            [self addBottomBtn];
        }
    }];
}

- (void)getHeaderAvatar:(NSString *)nameStr
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBHeaderManager defaultManager] requestGetAvatar:nameStr token:userEntity.token completion:^(id responseObject, NSError *error) {
        if (error.code == 0) {
            [_tableView reloadData];
        }
    }];
}

-(void)addTableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 60) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        [self.view addSubview:_tableView];
    }
    
    [_tableView reloadData];
}

-(void)addBottomBtn
{
    //底部按钮
    if (!_bottomBtn) {
        CGRect rc = CGRectMake(10.0f, ScreenHeight - 60.0f, ScreenWidth - 10 - 10, 50.0f);
        _bottomBtn = [[UIButton alloc] initWithFrame:rc];
        [_bottomBtn setBackgroundImage:[UIImage imageNamed:@"user_button"] forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(bottomBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bottomBtn];
    }
    
    if (self.isBinding) {
        [_bottomBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
    }else{
        [_bottomBtn setTitle:@"绑定教研员" forState:UIControlStateNormal];
    }
}

#pragma mark - actionSheetDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            //解除绑定
            HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
            [MBHudUtil showActivityView:nil inView:nil];
            [[HBServiceManager defaultManager] requestDirectorUnAss:userEntity.name completion:^(id responseObject, NSError *error) {
                [self getUserInfo];
                [MBHudUtil hideActivityView:nil];
            }];
        }
    }
}

-(void)bottomBtnPressed
{
    if (self.isBinding) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"解除绑定" message:@"确定要和教研员解除绑定吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 0;
        
        [alertView show];
    } else {
        NSString *leaderName = nil;
        for (NSString *keyStr in [self.leaderSelectedDic allKeys]) {
            NSString *valueStr = [self.leaderSelectedDic objectForKey:keyStr];
            if ([valueStr isEqualToString:@"1"]) {
                leaderName = keyStr;
                break;
            }
        }
        
        if (leaderName) {
            HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
            [MBHudUtil showActivityView:nil inView:nil];
            [[HBServiceManager defaultManager] requestDirectorAss:userEntity.name director:leaderName completion:^(id responseObject, NSError *error) {
                [self getUserInfo];
                [MBHudUtil hideActivityView:nil];
            }];
        }
    }
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
    if (self.isBinding) {
        return 2;
    }else{
        return self.leadersArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isBinding){
        if (iPhone4) {
            return 150;
        } else {
            return 200;
        }
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger imgWidth = 100;
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIView *view = [[UIView alloc] init];
    CGFloat imgY = 0;
    if (iPhone4) {
        imgY = (150-imgWidth) / 2;
    } else {
        imgY = (200-imgWidth) / 2;
    }
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-imgWidth)/2, imgY, imgWidth, imgWidth)];
    
    NSString *headFile = [[HBHeaderManager defaultManager] getAvatarFileByUser:self.accountStr];
    
    if (headFile) {
        //设置显示圆形头像
        headView.layer.cornerRadius = 100/2;
        headView.clipsToBounds = YES;
        headView.image = [UIImage imageWithContentsOfFile:headFile];
        if (headView.image == nil) {
            headView.image = [UIImage imageNamed:@"menu_user_pohoto"];
        }
    } else {
        headView.image = [UIImage imageNamed:@"menu_user_pohoto"];
    }

    [view addSubview:headView];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isBinding) {

        HBLeaderBindingCell *cell = [tableView dequeueReusableCellWithIdentifier:KLeaderBindingCellReuseId];
        if (!cell) {
            cell = [[HBLeaderBindingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KLeaderBindingCellReuseId];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        if (0 == indexPath.row) {
            [dic setObject:@"账号" forKey:@"title"];
            [dic setObject:[self.accountStr uppercaseString] forKey:@"content"];
        }else{
            [dic setObject:@"名字" forKey:@"title"];
            [dic setObject:self.nameStr forKey:@"content"];
        }
        
        [cell updateFormData:dic];
        
        return cell;

    }else{
        
        HBLeaderUnbindingCell *cell = [tableView dequeueReusableCellWithIdentifier:KLeaderUnBindingCellReuseId];
        if (!cell) {
            cell = [[HBLeaderUnbindingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KLeaderUnBindingCellReuseId];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell updateFormData:[self.leadersArr objectAtIndex:indexPath.row]];
        [cell selectedBtnPressed:[self.leaderSelectedDic objectForKey:cell.nameLabel.text]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self.isBinding){
        HBLeaderUnbindingCell *cell = (HBLeaderUnbindingCell*)[tableView cellForRowAtIndexPath:indexPath];
        NSString *isSelected = [self.leaderSelectedDic objectForKey:cell.nameLabel.text];
        if ([isSelected isEqualToString:@"1"]) {
            [self.leaderSelectedDic setObject:@"0" forKey:cell.nameLabel.text];
        }else{
            for (NSString *keyStr in [self.leaderSelectedDic allKeys]) {
                [self.leaderSelectedDic setObject:@"0" forKey:keyStr];
            }
            [self.leaderSelectedDic setObject:@"1" forKey:cell.nameLabel.text];
        }
        
        [_tableView reloadData];
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
