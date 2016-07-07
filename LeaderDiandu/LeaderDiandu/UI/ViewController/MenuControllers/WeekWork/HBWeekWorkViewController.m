//
//  HBWeekWorkViewController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/11/7.
//  Copyright © 2015年 hxj. All rights reserved.
//

#import "HBWeekWorkViewController.h"
#import "HBWeekUtil.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"
#import "HBExamEntity.h"
#import "HBHeaderManager.h"
#import "HBWeekWorkCell.h"

@interface HBWeekWorkViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray  *_examsArr;
    UITableView *_tableView;
}

@property (nonatomic, assign)NSInteger year;  //年
@property (nonatomic, assign)NSInteger weekOfYear;  //一年中的第几周
@property (nonatomic, strong)NSDate * currentDate;  //当前展示时间
@property (nonatomic, assign)NSInteger bookset_id;  //套餐ID

@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIButton *thisWeekButton;

@end

@implementation HBWeekWorkViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.currentDate = [NSDate date];
        NSDateComponents *components = [[HBWeekUtil sharedInstance] getCompontentsWithDate:self.currentDate];
        self.year = [components year];
        self.weekOfYear = [components weekOfYear];
        
        _examsArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"每周作业";
    
    [self initDateView];
    [self addTableView];
    
    //教研员获取相关老师的作业统计信息
    [self requestTeacherTaskList];
}

-(void)initDateView
{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, HBNavBarHeight, HBFullScreenWidth, 50);
    bgView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:bgView];
    
    UILabel *seperator = [[UILabel alloc] initWithFrame:CGRectMake(0, bgView.frame.size.height - 1, bgView.frame.size.width, 1)];
    seperator.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:seperator];
    
    //左箭头
    self.leftButton = [[UIButton alloc] init];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"Statistics-btn-last"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton.frame = CGRectMake(10, (50 - 30)/2, 30, 30);
    [bgView addSubview:self.leftButton];
    
    //右箭头
    self.rightButton = [[UIButton alloc] init];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"Statistics-btn-next"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.frame = CGRectMake(150, (50 - 30)/2, 30, 30);
    [bgView addSubview:self.rightButton];
    
    //日期label
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.frame = CGRectMake(40, 0, 110, 50);
    self.dateLabel.text = [NSString stringWithFormat:@"%ld年%ld周", self.year, self.weekOfYear];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:self.dateLabel];
    
    //本周button
    self.thisWeekButton = [[UIButton alloc] init];
    self.thisWeekButton.frame = CGRectMake(200, 0, 60, 50);
    [self.thisWeekButton setTitle:@"本周" forState:UIControlStateNormal];
    //    self.thisWeekButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [self.thisWeekButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.thisWeekButton addTarget:self action:@selector(thisWeekButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.thisWeekButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [bgView addSubview:self.thisWeekButton];
}

-(void)leftButtonPressed
{
    NSDate *newDate = [[HBWeekUtil sharedInstance] turnWeekDay:YES withCurrentDate:self.currentDate];
    self.currentDate = newDate;
    NSDateComponents *components = [[HBWeekUtil sharedInstance] getCompontentsWithDate:self.currentDate];
    self.year = [components year];
    self.weekOfYear = [components weekOfYear];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%ld年%ld周", self.year, self.weekOfYear];
    [_tableView reloadData];
    
    //教研员获取相关老师的作业统计信息
    [self requestTeacherTaskList];
}

-(void)rightButtonPressed
{
    NSDate *newDate = [[HBWeekUtil sharedInstance] turnWeekDay:NO withCurrentDate:self.currentDate];
    
    NSComparisonResult result = [newDate compare:[NSDate date]];
    if (result == NSOrderedDescending) { //如果日期大于当前日期了，就不执行了
        return;
    }
    
    self.currentDate = newDate;
    NSDateComponents *components = [[HBWeekUtil sharedInstance] getCompontentsWithDate:self.currentDate];
    self.year = [components year];
    self.weekOfYear = [components weekOfYear];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%ld年%ld周", self.year, self.weekOfYear];
    [_tableView reloadData];
    
    //教研员获取相关老师的作业统计信息
    [self requestTeacherTaskList];
}

-(void)thisWeekButtonPressed
{
    self.currentDate = [NSDate date];
    NSDateComponents *components = [[HBWeekUtil sharedInstance] getCompontentsWithDate:self.currentDate];
    self.year = [components year];
    self.weekOfYear = [components weekOfYear];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%ld年%ld周", self.year, self.weekOfYear];
    [_tableView reloadData];
    
    //教研员获取相关老师的作业统计信息
    [self requestTeacherTaskList];
}

-(void)addTableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, HBNavBarHeight + 50, HBFullScreenWidth, HBFullScreenHeight - HBNavBarHeight - 50)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableView];
    }
}

-(void)requestTeacherTaskList
{
    NSMutableDictionary *dateDic = [[HBWeekUtil sharedInstance] getWeekBeginAndEndWith:self.currentDate];
    
    NSDate *beginDate = [dateDic objectForKey:@"beginDate"];
    NSDate *endDate = [dateDic objectForKey:@"endDate"];
    
    NSString *beginDateStr = [NSString stringWithFormat:@"%.f",[beginDate timeIntervalSince1970]];
    NSString *endDateStr = [NSString stringWithFormat:@"%.f",[endDate timeIntervalSince1970]];
    
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        NSString *user = userEntity.name;
        //教研员获取相关老师的作业统计信息
        [MBHudUtil showActivityView:nil inView:nil];
        [[HBServiceManager defaultManager] requestTeacherTaskList:user fromTime:[beginDateStr integerValue] toTime:[endDateStr integerValue] completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                [_examsArr removeAllObjects];
                //教研员获取相关老师的作业统计信息成功
                NSArray *arr = [responseObject objectForKey:@"exams"];
                for (NSDictionary *dict in arr)
                {
                    HBExamEntity *examEntity = [[HBExamEntity alloc] init];
                    examEntity.name = [dict objectForKey:@"name"];
                    examEntity.display_name = [dict objectForKey:@"display_name"];
                    examEntity.total_count = [[dict objectForKey:@"total_count"] integerValue];
                    examEntity.submitted_count = [[dict objectForKey:@"submitted_count"] integerValue];
                    
                    [_examsArr addObject:examEntity];
                    
                    //获取用户头像
                    [self getHeaderAvatar:examEntity];
                }
                
                [_tableView reloadData];
                
                [MBHudUtil hideActivityView:nil];
            }
        }];
    }
}

- (void)getHeaderAvatar:(HBExamEntity *)examEntity
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBHeaderManager defaultManager] requestGetAvatar:examEntity.name token:userEntity.token completion:^(id responseObject, NSError *error) {
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
    NSParameterAssert(_examsArr);
    return _examsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HBWeekWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KHBWeekWorkViewCellReuseId"];
    if (!cell) {
        cell = [[HBWeekWorkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KHBWeekWorkViewCellReuseId"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    HBExamEntity *exams = [_examsArr objectAtIndex:indexPath.row];
    [cell updateFormData:exams];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
