//
//  HBPublishWorkViewController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/9.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBPublishWorkViewController.h"
#import "HBGroupSelectViewController.h"
#import "HBTestSelectViewController.h"
#import "HBClassEntity.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"

#import "Leader21SDKOC.h"

@interface HBPublishWorkViewController ()<UITableViewDataSource, UITableViewDelegate, HBGroupSelectViewDelegate, HBTestSelectViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, strong) UIButton* publishWorkButton;
@property (nonatomic, copy) NSString* groupStr;
@property (nonatomic, copy) NSString* testStr;

@property (nonatomic, strong) HBClassEntity* classEntity;
@property (nonatomic, strong) BookEntity* bookEntity;

@end

@implementation HBPublishWorkViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.groupStr = @"群组选择";
        self.testStr = @"作业选择";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"发布作业";
    
    [self addTableView];
    
    CGRect rc = CGRectMake(10.0f, HBFullScreenHeight - 80.0f, HBFullScreenWidth - 10 - 10, 50.0f);
    self.publishWorkButton = [[UIButton alloc] initWithFrame:rc];
    [self.publishWorkButton setBackgroundImage:[UIImage imageNamed:@"yellow-normal"] forState:UIControlStateNormal];
    [self.publishWorkButton setBackgroundImage:[UIImage imageNamed:@"yellow-press"] forState:UIControlStateHighlighted];
    [self.publishWorkButton setTitle:@"发布作业" forState:UIControlStateNormal];
    [self.publishWorkButton addTarget:self action:@selector(publishWorkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.publishWorkButton];
}

-(void)addTableView
{
    CGRect rect = self.view.frame;
    CGRect viewFrame = CGRectMake(0, 0, rect.size.width, HBFullScreenHeight);
    _tableView = [[UITableView alloc] initWithFrame:viewFrame];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = NO;
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
    
    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0,70 - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    seperatorLine.backgroundColor = HEXRGBCOLOR(0xff8903);
    [cell addSubview:seperatorLine];
    
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
        HBTestSelectViewController *vc = [[HBTestSelectViewController alloc] init];
        vc.bookset_id = self.classEntity.booksetId;
        vc.delegate = self;
        if (0 == vc.bookset_id) {
            [MBHudUtil showTextView:@"请先选择群组" inView:nil];
        }else{
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)publishWorkButtonPressed:(id)sender
{
    if (self.classEntity == nil) {
        [MBHudUtil showTextView:@"请选择群租" inView:nil];
        return;
    } else if (self.bookEntity == nil) {
        [MBHudUtil showTextView:@"请选择作业" inView:nil];
        return;
    }
    
    [MBHudUtil showActivityView:nil inView:nil];
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        NSString *user = userEntity.name;
        
        [[HBServiceManager defaultManager] requestClassMember:user class_id:self.classEntity.classId completion:^(id responseObject, NSError *error) {
            NSArray *arr = [responseObject objectForKey:@"members"];
            if (arr.count > 0) {
                [[HBServiceManager defaultManager] requestTaskAssign:user book_id:[self.bookEntity.bookId integerValue] class_id:self.classEntity.classId bookset_id:self.classEntity.booksetId completion:^(id responseObject, NSError *error) {
                    //布置作业成功!!!
                    if (responseObject) {
                        NSDictionary *dict = responseObject;
                        if (dict[@"exam_id"]) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }
                }];
            }else{
                [MBHudUtil showTextView:@"该班级无成员，无法布置作业！" inView:nil];
            }
        }];
    }
}

#pragma mark - HBGroupSelectViewDelegate

- (void)selectedGroup:(HBClassEntity *)classEntity
{
    if (self.classEntity.classId != classEntity.classId) {
        self.bookEntity = nil;
        self.testStr = @"作业选择";
    }
    
    self.classEntity = classEntity;
    self.groupStr = classEntity.name;

    [_tableView reloadData];
}

#pragma mark - HBTestSelectViewDelegate

- (void)selectedTest:(BookEntity *)bookEntity
{
    self.bookEntity = bookEntity;
    if ([[HBDataSaveManager defaultManager] showEnBookName]) {
        self.testStr = bookEntity.bookTitle;
    }else{
        self.testStr = bookEntity.bookTitleCN;
    }
    
    [_tableView reloadData];
}

@end
