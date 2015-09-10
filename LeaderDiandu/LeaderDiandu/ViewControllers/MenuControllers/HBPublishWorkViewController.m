//
//  HBPublishWorkViewController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/9.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBPublishWorkViewController.h"
#import "UIViewController+AddBackBtn.h"
#import "HBTitleView.h"
#import "HBGroupSelectViewController.h"
#import "HBClassEntity.h"

#import "HBDataSaveManager.h"
#import "HBServiceManager.h"

@interface HBPublishWorkViewController ()<UITableViewDataSource, UITableViewDelegate, HBGroupSelectViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, strong) UIButton* publishWorkButton;
@property (nonatomic, copy) NSString* groupStr;
@property (nonatomic, copy) NSString* testStr;

@property (nonatomic, strong) HBClassEntity* classEntity;

@end

@implementation HBPublishWorkViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.groupStr = @"群组选择";
        self.testStr = @"测试选择";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HBTitleView *labTitle = [HBTitleView titleViewWithTitle:@"发布作业" onView:self.view];
    [self.view addSubview:labTitle];
    
    [self addBackButton];
    
    [self addTableView];
    
    CGRect rc = CGRectMake(0.0f, ScreenHeight - 80.0f, ScreenWidth, 50.0f);
    self.publishWorkButton = [[UIButton alloc] initWithFrame:rc];
    [self.publishWorkButton setBackgroundImage:[UIImage imageNamed:@"user_button"] forState:UIControlStateNormal];
    [self.publishWorkButton setTitle:@"发布作业" forState:UIControlStateNormal];
    [self.publishWorkButton addTarget:self action:@selector(publishWorkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.publishWorkButton];
}

-(void)addTableView
{
    CGRect rect = self.view.frame;
    CGRect viewFrame = CGRectMake(0, KHBNaviBarHeight + 50, rect.size.width, 70*2);
    _tableView = [[UITableView alloc] initWithFrame:viewFrame];
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
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KHBPublishWorkViewControllerCellReuseId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KHBPublishWorkViewControllerCellReuseId"];
    }
    
    if (0 == indexPath.row) {
        cell.textLabel.text = self.groupStr;
    }else{
        cell.textLabel.text = self.testStr;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (0 == indexPath.row) {
        HBGroupSelectViewController *vc = [[HBGroupSelectViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
//        //测试一下哈
//        NSDictionary *dict = [[HBDataSaveManager defaultManager] loadUser];
//        if (dict) {
//            NSString *user = [dict objectForKey:@"name"];
//            NSString *classIdStr = [NSString stringWithFormat:@"%ld", self.classEntity.classId];
//            NSString *booksetIdStr = [NSString stringWithFormat:@"%ld", self.classEntity.booksetId];
//            [[HBServiceManager defaultManager] requestTaskListOfClass:user class_id:classIdStr bookset_id:booksetIdStr completion:^(id responseObject, NSError *error) {
//                int i = 0;
//            }];
//        }
    }
}

- (void)publishWorkButtonPressed:(id)sender
{
    //to do ...
    //测试一下哈
    NSDictionary *dict = [[HBDataSaveManager defaultManager] loadUser];
    if (dict) {
        NSString *user = [dict objectForKey:@"name"];
        [[HBServiceManager defaultManager] requestTaskList:user class_id:_classEntity.classId bookset_id:_classEntity.booksetId completion:^(id responseObject, NSError *error) {
            int i = 0;
        }];
    }
}

#pragma mark - HBGroupSelectViewDelegate

- (void)selectedGroup:(HBClassEntity *)classEntity
{
    self.classEntity = classEntity;
    self.groupStr = classEntity.name;
    [_tableView reloadData];
}

@end
