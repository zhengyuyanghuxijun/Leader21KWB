//
//  HBStuManViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/2.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBStuManViewController.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"
#import "HBStudentEntity.h"
#import "HBClassEntity.h"
#import "TimeIntervalUtils.h"
#import "HBStudentCell.h"
#import "HBGroupCell.h"
#import "HBCreatGroupController.h"
#import "HBSetStuController.h"

static NSString * const KStudentCellAccessoryReuseId = @"KStudentCellAccessoryReuseId";
static NSString * const KGroupCellAccessoryReuseId = @"KGroupCellAccessoryReuseId";

@interface HBStuManViewController ()<UITableViewDataSource, UITableViewDelegate, UnbundlingDelegate, DissolveDelegate, CreatGroupDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, strong) UIButton* studentButton;
@property (nonatomic, strong) UILabel * studentSeperator;
@property (nonatomic, strong) UIButton* groupButton;
@property (nonatomic, strong) UILabel * groupSeperator;
@property (nonatomic, strong) UIButton* addGroupButton;
@property (nonatomic, strong) NSMutableArray *studentArr;
@property (nonatomic, strong) NSMutableArray *groupArr;

@property (nonatomic, assign) NSInteger unBundingStudentId;
@property (nonatomic, assign) NSInteger unBundingClassId;

@property (nonatomic, assign) BOOL isShowStuView;

@property (nonatomic, assign) NSInteger num;

@end

@implementation HBStuManViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.studentArr = [[NSMutableArray alloc] initWithCapacity:1];
        self.groupArr = [[NSMutableArray alloc] initWithCapacity:1];
        self.isShowStuView = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置页面背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"学生管理";
    
    [self requestStudentList];
    //学生按钮
    CGRect rc = CGRectMake(0.0f, KHBNaviBarHeight, self.view.frame.size.width/2 - 3, 50.0f);
    self.studentButton = [[UIButton alloc] initWithFrame:rc];
    [self.studentButton setTitle:@"学生" forState:UIControlStateNormal];
    [self.studentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.studentButton addTarget:self action:@selector(studentButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.studentButton];
    
    self.studentSeperator = [[UILabel alloc] initWithFrame:CGRectMake(0, self.studentButton.frame.size.height - 2, self.studentButton.frame.size.width, 2)];
    self.studentSeperator.backgroundColor = [UIColor colorWithHex:0xff8903];
    [self.studentButton addSubview:self.studentSeperator];
    
    //分割线
    UILabel *verticalLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.studentButton.frame.origin.x + self.studentButton.frame.size.width, KHBNaviBarHeight, 6, 50)];
    verticalLineLabel.text = @"|";
    verticalLineLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    verticalLineLabel.textAlignment = NSTextAlignmentCenter;
    verticalLineLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:verticalLineLabel];
    
    //群组按钮
    rc = CGRectMake(self.view.frame.size.width/2 + 3, KHBNaviBarHeight, self.view.frame.size.width/2, 50.0f);
    self.groupButton = [[UIButton alloc] initWithFrame:rc];
    [self.groupButton setTitle:@"群组" forState:UIControlStateNormal];
    [self.groupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.groupButton addTarget:self action:@selector(groupButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.groupButton];
    
    self.groupSeperator = [[UILabel alloc] initWithFrame:CGRectMake(0, self.groupButton.frame.size.height - 2, self.groupButton.frame.size.width, 2)];
    self.groupSeperator.backgroundColor = [UIColor colorWithHex:0xff8903];
    [self.groupButton addSubview:self.groupSeperator];
    
    //底部按钮
    rc = CGRectMake(10.0f, ScreenHeight - 60.0f, ScreenWidth - 10 - 10, 50.0f);
    self.addGroupButton = [[UIButton alloc] initWithFrame:rc];
    [self.addGroupButton setBackgroundImage:[UIImage imageNamed:@"user_button"] forState:UIControlStateNormal];
    [self.addGroupButton setTitle:@"添加群组" forState:UIControlStateNormal];
    [self.addGroupButton addTarget:self action:@selector(assignWorkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addGroupButton];
    [self.addGroupButton setHidden:YES];
    
    [self showStudentView:YES];
}

-(void)showStudentView:(BOOL)showStudentView
{
    if (showStudentView) {
        [self.studentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.groupButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.studentSeperator.hidden = NO;
        self.groupSeperator.hidden = YES;
    }else{
        [self.studentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.groupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.studentSeperator.hidden = YES;
        self.groupSeperator.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.isShowStuView) {
        [self requestStudentList];
        [self requestClassList];
    }
}

-(void)addTableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = NO;
        [self.view addSubview:_tableView];
        
        if (self.isShowStuView) {
            CGRect rc = CGRectMake(0.0f, KHBNaviBarHeight + 50.0f, ScreenWidth, ScreenHeight - KHBNaviBarHeight - 50.0f);
            _tableView.frame = rc;
        }else{
            CGRect rc = CGRectMake(0.0f, KHBNaviBarHeight + 50.0f, ScreenWidth, ScreenHeight - KHBNaviBarHeight - 50.0f - 60.0f);
            _tableView.frame = rc;
        }
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
    if (self.isShowStuView) {
        NSParameterAssert(self.studentArr);
        return self.studentArr.count;
    }else{
        NSParameterAssert(self.groupArr);
        return self.groupArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isShowStuView) {
        NSParameterAssert(self.studentArr);
        
        HBStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:KStudentCellAccessoryReuseId];
        if (!cell) {
            cell = [[HBStudentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KStudentCellAccessoryReuseId];
        }
        
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HBStudentEntity *studentEntity = [self.studentArr objectAtIndex:indexPath.row];
        [cell updateFormData:studentEntity];
        
        return cell;
    }else{
        NSParameterAssert(self.groupArr);
        
        HBGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:KGroupCellAccessoryReuseId];
        if (!cell) {
            cell = [[HBGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KGroupCellAccessoryReuseId];
        }
        
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HBClassEntity *classEntity = [self.groupArr objectAtIndex:indexPath.row];
        [cell updateFormData:classEntity];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (void)studentButtonPressed
{
    [self.addGroupButton setHidden:YES];
    self.isShowStuView = YES;
    if (0 == self.studentArr.count) {
        [self requestStudentList];
    }
    
    CGRect rc = CGRectMake(0.0f, KHBNaviBarHeight + 50.0f, ScreenWidth, ScreenHeight - KHBNaviBarHeight - 50.0f);
    _tableView.frame = rc;
    
    [_tableView reloadData];
    
    [self showStudentView:YES];
}

-(void)groupButtonPressed
{
    [self.addGroupButton setHidden:NO];
    self.isShowStuView = NO;
    if (0 == self.groupArr.count) {
        [self requestClassList];
    }
    
    CGRect rc = CGRectMake(0.0f, KHBNaviBarHeight + 50.0f, ScreenWidth, ScreenHeight - KHBNaviBarHeight - 50.0f - 60.0f);
    _tableView.frame = rc;
    
    [_tableView reloadData];
    
    [self showStudentView:NO];
}

-(void)assignWorkButtonPressed:(id)sender
{
    HBCreatGroupController *vc = [[HBCreatGroupController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestStudentList
{
    [MBHudUtil showActivityView:nil inView:nil];
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        NSString *user = userEntity.name;
        [[HBServiceManager defaultManager] requestStudentList:user completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                //获取绑定老师的学生信息成功
                NSArray *arr = [responseObject objectForKey:@"students"];
                if (arr.count > 0) {
                    [self.studentArr removeAllObjects];
                }
                for (NSDictionary *dic in arr)
                {
                    HBStudentEntity *studentEntity = [[HBStudentEntity alloc] init];
                    studentEntity.displayName = [dic objectForKey:@"display_name"];
                    studentEntity.name = [dic objectForKey:@"name"];
                    studentEntity.phone = [dic objectForKey:@"phone"];
                    if ([studentEntity.displayName isEqualToString:@""]) {
                        studentEntity.displayName = studentEntity.phone;
                    }
                    NSTimeInterval interval = [[dic objectForKey:@"vip_time"] doubleValue];
                    studentEntity.vipTime = [TimeIntervalUtils getStringMDHMSFromTimeInterval:interval];
                    studentEntity.className = [dic objectForKey:@"class_name"];
                    studentEntity.classId = [[dic objectForKey:@"class_id"] integerValue];
                    studentEntity.studentId = [[dic objectForKey:@"id"] integerValue];
                    studentEntity.gender = [[dic objectForKey:@"gender"] integerValue];
                    studentEntity.type = [[dic objectForKey:@"type"] integerValue];
                    studentEntity.accountStatus = [[dic objectForKey:@"account_status"] integerValue];
                    
                    [self.studentArr addObject:studentEntity];
                    
//                    //获取用户头像
//                    [[HBServiceManager defaultManager] requestGetAvatar:user token:token userId:studentEntity.name completion:^(id responseObject, NSError *error) {
//                        
//                    }];
                }
                
                if (self.studentArr.count > 0) {
                    [self addTableView];
                }
                
                [_tableView reloadData];
            }
            [MBHudUtil hideActivityView:nil];
        }];
    }
}

-(void)requestClassList
{
    [MBHudUtil showActivityView:nil inView:nil];
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        NSString *user = userEntity.name;
        [[HBServiceManager defaultManager] requestClassList:user completion:^(id responseObject, NSError *error) {
            NSArray *arr = [responseObject objectForKey:@"classes"];
            if (arr.count > 0) {
                self.num = 0;
                [self.groupArr removeAllObjects];
            }
            for (NSDictionary *dic in arr)
            {
                HBClassEntity *classEntity = [[HBClassEntity alloc] init];
                classEntity.name = [dic objectForKey:@"name"];
                classEntity.booksetId = [[dic objectForKey:@"bookset_id"] integerValue];
                classEntity.classId = [[dic objectForKey:@"id"] integerValue];
                NSTimeInterval interval = [[dic objectForKey:@"created_time"] doubleValue];
                classEntity.createdTime = [TimeIntervalUtils getStringMDHMSFromTimeInterval:interval];
                
                [self.groupArr addObject:classEntity];
            }
            
            for (HBClassEntity *classEntity in self.groupArr) {
                [[HBServiceManager defaultManager] requestClassMember:user class_id: classEntity.classId completion:^(id responseObject, NSError *error) {
                    self.num++;
                    NSArray *arr = [responseObject objectForKey:@"members"];
                    classEntity.stuCount = arr.count;
                    if (self.num == self.groupArr.count) {
                        [MBHudUtil hideActivityView:nil];
                        [_tableView reloadData];
                    }
                }];
            }
        }];
    }
}

#pragma mark - UnbundlingDelegate
- (void)unbundlingBtnPressed:(NSInteger)studentId
{
    self.unBundingStudentId = studentId;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"解除绑定" message:@"确定要和此学生解除绑定吗？解除之后此学生将自动退出已加入的群组。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1;
    
    [alertView show];
}

#pragma mark - actionSheetDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        //to do ...
    }else{
        if (alertView.tag == 1) {
            HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
            if (userEntity) {
                NSString *user = userEntity.name;
                
                [MBHudUtil showActivityView:nil inView:nil];
                [[HBServiceManager defaultManager] requestTeacherUnAssignStu:user student_id:[NSString stringWithFormat:@"%ld", self.unBundingStudentId] completion:^(id responseObject, NSError *error) {
                    //解除绑定成功！！！
                    [self requestStudentList];
                }];
            }
        }else{
            [MBHudUtil showActivityView:nil inView:nil];
            HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
            if (userEntity) {
                NSString *user = userEntity.name;
                
                [[HBServiceManager defaultManager] requestClassDelete:user class_id:[NSString stringWithFormat:@"%ld", self.unBundingClassId] completion:^(id responseObject, NSError *error) {
                    int index = 0;
                    for (HBClassEntity *classEntity in self.groupArr) {
                        if (classEntity.classId == self.unBundingClassId) {
                            break;
                        }
                        index++;
                    }
                    
                    [self.groupArr removeObjectAtIndex:index];
                    [MBHudUtil hideActivityView:nil];
                    [self requestClassList];
                    [self groupButtonPressed];
                }];
            }
        }
    }
}

#pragma mark - DissolveDelegate
- (void)dissolveBtnPressed:(NSInteger)classId
{
    self.unBundingClassId = classId;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"解散" message:@"确定要解散此群组吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 2;
    
    [alertView show];
}

- (void)editBtnPressed:(HBClassEntity *)classEntity
{
    NSMutableArray *groupStuArr = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableArray *otherStuArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (HBStudentEntity *studentEntity in self.studentArr) {
        if (studentEntity.classId == classEntity.classId) {
            [groupStuArr addObject:studentEntity];
        }else if(0 == studentEntity.classId){
            [otherStuArr addObject:studentEntity];
        }
    }
    
    HBSetStuController *vc = [[HBSetStuController alloc] init];
    vc.titleStr = classEntity.name;
    vc.classId = classEntity.classId;
    vc.groupStuArr = groupStuArr;
    vc.otherStuArr = otherStuArr;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - CreatGroupDelegate
- (void)creatGroupComplete
{
//    [self requestClassList];
}

@end
