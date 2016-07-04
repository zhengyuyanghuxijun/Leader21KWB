//
//  HBTeacherManViewController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/25.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBTeacherManViewController.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"
#import "HBTeacherEntity.h"
#import "TimeIntervalUtils.h"
#import "HBTeacherManCell.h"
#import "HBHeaderManager.h"

static NSString * const KHBTeacherManViewControllerCellAccessoryReuseId = @"KHBTeacherManViewControllerCellAccessoryReuseId";

@interface HBTeacherManViewController ()<UITableViewDataSource, UITableViewDelegate, HBTeacherManCellDelegate>
{
    NSMutableArray  *_teacherArr;
    UITableView     *_tableView;
    
    NSString *_unbindingTeacherStr;
}
@end

@implementation HBTeacherManViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _teacherArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"教研员";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect rect = self.view.frame;
    CGRect viewFrame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    _tableView = [[UITableView alloc] initWithFrame:viewFrame];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
    
    //获取教师列表
    [self requestTeacherList];
}

-(void)requestTeacherList
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        NSString *user = userEntity.name;
        //获取教师列表
        [MBHudUtil showActivityView:nil inView:nil];
        [[HBServiceManager defaultManager] requestTeacherList:user completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                //获取教师列表成功
                [_teacherArr removeAllObjects];
                NSArray *arr = [responseObject objectForKey:@"teachers"];
                for (NSDictionary *dict in arr)
                {
                    HBTeacherEntity *teacher = [[HBTeacherEntity alloc] init];
                    teacher.name = [dict objectForKey:@"name"];
                    teacher.display_name = [dict objectForKey:@"display_name"];
                    
                    NSTimeInterval interval = [[dict objectForKey:@"associate_time"] doubleValue];
                    teacher.associate_time = [TimeIntervalUtils getStringMDHMSFromTimeInterval:interval];
                    
                    NSDictionary *student_statDic = [dict objectForKey:@"student_stat"];
                    teacher.total = [[student_statDic objectForKey:@"total"] integerValue];
                    teacher.vip = [[student_statDic objectForKey:@"vip"] integerValue];
                
                    [_teacherArr addObject:teacher];
                    
                    //获取用户头像
                    [self getHeaderAvatar:teacher];
                }
                
                [_tableView reloadData];
                
                [MBHudUtil hideActivityView:nil];
            }
        }];
    }
}

- (void)getHeaderAvatar:(HBTeacherEntity *)teacherEntity
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBHeaderManager defaultManager] requestGetAvatar:teacherEntity.name token:userEntity.token completion:^(id responseObject, NSError *error) {
        if (error.code == 0) {
            [_tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSParameterAssert(_teacherArr);
    return _teacherArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(_teacherArr);

    HBTeacherManCell *cell = [tableView dequeueReusableCellWithIdentifier:KHBTeacherManViewControllerCellAccessoryReuseId];
    if (!cell) {
        cell = [[HBTeacherManCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KHBTeacherManViewControllerCellAccessoryReuseId];
    }
    
    cell.delegate = self;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor blackColor];
    
    HBTeacherEntity *teacher = [_teacherArr objectAtIndex:indexPath.row];
    [cell updateFormData:teacher];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - actionSheetDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
            if (userEntity) {
                NSString *user = userEntity.name;
                //教研员解除一位老师的绑定
                [MBHudUtil showActivityView:nil inView:nil];
                
                [[HBServiceManager defaultManager] requestUnBindingTeacher:user teacher:_unbindingTeacherStr completion:^(id responseObject, NSError *error) {
                    [MBHudUtil hideActivityView:nil];
                    if (responseObject) {
                        //教研员解除一位老师的绑定成功
                        //获取教师列表
                        [self requestTeacherList];
                    }
                }];
            }
        }
    }
}

- (void)unbundlingBtnPressed:(NSString *)teacher
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"解除绑定" message:@"确定要和老师解除绑定吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 0;
    _unbindingTeacherStr = teacher;
    
    [alertView show];
}

@end
