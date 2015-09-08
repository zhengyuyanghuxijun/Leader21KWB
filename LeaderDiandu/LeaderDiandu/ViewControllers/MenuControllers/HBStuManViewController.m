//
//  HBStuManViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/2.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBStuManViewController.h"
#import "UIViewController+AddBackBtn.h"
#import "HBTitleView.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"
#import "HBStudentEntity.h"
#import "TimeIntervalUtils.h"

static NSString * const KStuManViewControllerCellAccessoryReuseId = @"KStuManViewControllerCellAccessoryReuseId";

@interface HBStuManViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, strong) UIButton* studentButton;
@property (nonatomic, strong) UIButton* groupButton;
@property (nonatomic, strong) NSMutableArray *studentArr;
@property (nonatomic, strong) NSMutableArray *groupArr;

@end

@implementation HBStuManViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.studentArr = [[NSMutableArray alloc] initWithCapacity:1];
        self.groupArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HBTitleView *labTitle = [HBTitleView titleViewWithTitle:@"学生管理" onView:self.view];
    [self.view addSubview:labTitle];
    
    [self addBackButton];
    
    [self requestStudentList];
    
    CGRect rc = CGRectMake(0.0f, KHBNaviBarHeight, self.view.frame.size.width/2, 50.0f);
    self.studentButton = [[UIButton alloc] initWithFrame:rc];
    [self.studentButton setBackgroundImage:[UIImage imageNamed:@"user_button"] forState:UIControlStateNormal];
    [self.studentButton setTitle:@"学生" forState:UIControlStateNormal];
    [self.studentButton addTarget:self action:@selector(studentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.studentButton];
    
    rc = CGRectMake(self.view.frame.size.width/2, KHBNaviBarHeight, self.view.frame.size.width/2, 50.0f);
    self.groupButton = [[UIButton alloc] initWithFrame:rc];
    [self.groupButton setBackgroundImage:[UIImage imageNamed:@"user_button"] forState:UIControlStateNormal];
    [self.groupButton setTitle:@"群组" forState:UIControlStateNormal];
    [self.groupButton addTarget:self action:@selector(groupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.groupButton];
}

-(void)addTableView
{
    CGRect rc = CGRectMake(0.0f, KHBNaviBarHeight + 50.0f, self.view.frame.size.width, self.studentArr.count * 60);
    _tableView = [[UITableView alloc] initWithFrame:rc];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSParameterAssert(self.studentArr);
    return self.studentArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(self.studentArr);
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:KStuManViewControllerCellAccessoryReuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KStuManViewControllerCellAccessoryReuseId];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HBStudentEntity *studentEntity = [self.studentArr objectAtIndex:indexPath.row];
    cell.textLabel.text = studentEntity.displayName;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    
    return cell;
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

- (void)studentButtonPressed:(id)sender
{
    //to do ...
}

-(void)groupButtonPressed:(id)sender
{
    //to do ...
}

- (void)requestStudentList
{
    NSDictionary *dict = [[HBDataSaveManager defaultManager] loadUser];
    if (dict) {
        NSString *user = [dict objectForKey:@"name"];
        [[HBServiceManager defaultManager] requestStudentList:user completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                //获取绑定老师的学生信息成功
                NSArray *arr = [responseObject objectForKey:@"students"];
                for (NSDictionary *dic in arr)
                {
                    HBStudentEntity *studentEntity = [[HBStudentEntity alloc] init];
                    studentEntity.displayName = [dic objectForKey:@"display_name"];
                    studentEntity.name = [dic objectForKey:@"name"];
                    studentEntity.phone = [dic objectForKey:@"phone"];
                    NSTimeInterval interval = [[dic objectForKey:@"vip_time"] doubleValue];
                    studentEntity.vipTime = [TimeIntervalUtils getStringMDHMSFromTimeInterval:interval];
                    studentEntity.classId = [[dic objectForKey:@"class_id"] integerValue];
                    studentEntity.studentId = [[dic objectForKey:@"id"] integerValue];
                    studentEntity.gender = [[dic objectForKey:@"gender"] integerValue];
                    studentEntity.type = [[dic objectForKey:@"type"] integerValue];
                    
                    [self.studentArr addObject:studentEntity];
                }
                [self addTableView];
            }
        }];
    }
}

@end
