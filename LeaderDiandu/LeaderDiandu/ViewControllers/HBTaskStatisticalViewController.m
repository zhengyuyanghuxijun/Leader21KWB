//
//  HBTaskStatisticalViewController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/17.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBTaskStatisticalViewController.h"
#import "FTMenu.h"
#import "HBWeekUtil.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"
#import "HBExamKnowledgeEntity.h"
#import "HBExamAbilityEntity.h"
#import "HBTaskStatisticalCell.h"
#import "HBTableView.h"

@interface HBTaskStatisticalViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    HBTableView *_tableView;
}

@property (nonatomic, assign)NSInteger year;  //年
@property (nonatomic, assign)NSInteger weekOfYear;  //一年中的第几周
@property (nonatomic, strong)NSDate * currentDate;  //当前展示时间
@property (nonatomic, assign)NSInteger bookset_id;  //套餐ID

@property (nonatomic, strong)UIButton *knowledgeButton;  //知识点
@property (nonatomic, strong)UIButton *abilityButton;  //能力值
@property (nonatomic, strong) UILabel * knowledgeSeperator;
@property (nonatomic, strong) UILabel * abilitySeperator;

@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIButton *thisWeekButton;
@property (strong, nonatomic) UIButton *bookSetButton;

@property (nonatomic, strong) NSMutableArray *knowledgeArr;
@property (nonatomic, strong) NSMutableArray *abilityArr;

@property (nonatomic, assign) BOOL isShowKnowledge;

@end

@implementation HBTaskStatisticalViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.currentDate = [NSDate date];
        NSDateComponents *components = [[HBWeekUtil sharedInstance] getCompontentsWithDate:self.currentDate];
        self.year = [components year];
        self.weekOfYear = [components weekOfYear];
        self.bookset_id = 1;
        self.isShowKnowledge = YES;
        
        self.knowledgeArr = [[NSMutableArray alloc] initWithCapacity:1];
        self.abilityArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINavigationBar *naviBar = self.navigationController.navigationBar;
    //设置navigationBar背景颜色
    [naviBar setBarTintColor:[UIColor colorWithHex:0x1E90FF]];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"作业统计";
    
    [self initButton];
    [self initSelectBookSetView];
    
    //作业知识点统计
    [self requestExamKnowledge];
    //作业题目认知能力统计
    [self requestExamAbility];
    
    [self addTableView];
}

-(void)addTableView
{
    if (_tableView == nil) {
        _tableView = [[HBTableView alloc] initWithFrame:CGRectMake(0.0f, KHBNaviBarHeight + 50 + 50, ScreenWidth, ScreenHeight - KHBNaviBarHeight - 50 - 50)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initButton{
    //知识点按钮
    CGRect rc = CGRectMake(0.0f, KHBNaviBarHeight, self.view.frame.size.width/2, 50.0f);
    self.knowledgeButton = [[UIButton alloc] initWithFrame:rc];
    [self.knowledgeButton setBackgroundColor:[UIColor whiteColor]];
    [self.knowledgeButton setTitle:@"知识点" forState:UIControlStateNormal];
    [self.knowledgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.knowledgeButton addTarget:self action:@selector(knowledgeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.knowledgeButton];
    
    self.knowledgeSeperator = [[UILabel alloc] initWithFrame:CGRectMake(0, self.knowledgeButton.frame.size.height - 2, self.knowledgeButton.frame.size.width, 2)];
    self.knowledgeSeperator.backgroundColor = [UIColor colorWithHex:0x1E90FF];
    [self.knowledgeButton addSubview:self.knowledgeSeperator];
    
    //能力值按钮
    rc = CGRectMake(self.view.frame.size.width/2, KHBNaviBarHeight, self.view.frame.size.width/2, 50.0f);
    self.abilityButton = [[UIButton alloc] initWithFrame:rc];
    [self.abilityButton setBackgroundColor:[UIColor whiteColor]];
    [self.abilityButton setTitle:@"能力值" forState:UIControlStateNormal];
    [self.abilityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.abilityButton addTarget:self action:@selector(abilityButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.abilityButton];
    
    self.abilitySeperator = [[UILabel alloc] initWithFrame:CGRectMake(0, self.abilityButton.frame.size.height - 2, self.abilityButton.frame.size.width, 2)];
    self.abilitySeperator.backgroundColor = [UIColor colorWithHex:0x1E90FF];
    [self.abilityButton addSubview:self.abilitySeperator];
    
    [self showKnowledgeView:YES];
}

- (void)initSelectBookSetView
{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, KHBNaviBarHeight + 50, ScreenWidth, 50);
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
    
    //套餐按钮
    self.bookSetButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 8 - 44, (50 - 35)/2, 35, 35)];
    [self.bookSetButton setBackgroundImage:[UIImage imageNamed:@"bookshelf-btn-class"] forState:UIControlStateNormal];
    [self.bookSetButton addTarget:self action:@selector(bookSetButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.bookSetButton setTitle:[NSString stringWithFormat:@"%ld", self.bookset_id] forState:UIControlStateNormal];
    [self.bookSetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bgView addSubview:self.bookSetButton];
}

-(void)showKnowledgeView:(BOOL)showKnowledge
{
    if (showKnowledge) {
        self.knowledgeSeperator.hidden = NO;
        self.abilitySeperator.hidden = YES;
    }else{
        self.knowledgeSeperator.hidden = YES;
        self.abilitySeperator.hidden = NO;
    }
}

-(void)knowledgeButtonPressed
{
    self.isShowKnowledge = YES;
    [self showKnowledgeView:YES];
    [self reloadTableViewByArray];
}

-(void)abilityButtonPressed
{
    self.isShowKnowledge = NO;
    [self showKnowledgeView:NO];
    [self reloadTableViewByArray];
}

-(void)leftButtonPressed
{
    NSDate *newDate = [[HBWeekUtil sharedInstance] turnWeekDay:YES withCurrentDate:self.currentDate];
    self.currentDate = newDate;
    NSDateComponents *components = [[HBWeekUtil sharedInstance] getCompontentsWithDate:self.currentDate];
    self.year = [components year];
    self.weekOfYear = [components weekOfYear];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%ld年%ld周", self.year, self.weekOfYear];
//    [self reloadTableViewByArray];
    
    //作业知识点统计
    [self requestExamKnowledge];
    //作业题目认知能力统计
    [self requestExamAbility];
}

-(void)rightButtonPressed
{
    NSDate *newDate = [[HBWeekUtil sharedInstance] turnWeekDay:NO withCurrentDate:self.currentDate];
    
    NSComparisonResult result = [newDate compare:[NSDate date]];
    if (result == NSOrderedDescending) { //如果日期大于当前日期了，就不执行了
        [MBHudUtil showTextView:@"已到达最新日期" inView:nil];
        return;
    }
    
    self.currentDate = newDate;
    NSDateComponents *components = [[HBWeekUtil sharedInstance] getCompontentsWithDate:self.currentDate];
    self.year = [components year];
    self.weekOfYear = [components weekOfYear];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%ld年%ld周", self.year, self.weekOfYear];
//    [self reloadTableViewByArray];
    
    //作业知识点统计
    [self requestExamKnowledge];
    //作业题目认知能力统计
    [self requestExamAbility];
}

-(void)thisWeekButtonPressed
{
    self.currentDate = [NSDate date];
    NSDateComponents *components = [[HBWeekUtil sharedInstance] getCompontentsWithDate:self.currentDate];
    self.year = [components year];
    self.weekOfYear = [components weekOfYear];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%ld年%ld周", self.year, self.weekOfYear];
    [self reloadTableViewByArray];
    
    //作业知识点统计
    [self requestExamKnowledge];
    //作业题目认知能力统计
    [self requestExamAbility];
}

- (void)bookSetButtonPressed
{
    [self showPullView];
}

-(void)showPullView
{
    NSMutableArray *menuItems = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (NSInteger index = 1; index <= 9; index++) {
        NSString * bookIdStr = [NSString stringWithFormat:@"%ld", index];
        KxMenuItem *item = [KxMenuItem
                            menuItem:bookIdStr
                            image:nil
                            target:self
                            action:@selector(pushMenuItem:)];
        [menuItems addObject:item];
    }
    
    CGRect menuFrame = CGRectMake(ScreenWidth - 75, 160, 60, 50 * 9);
    
    [FTMenu showMenuWithFrame:menuFrame inView:self.navigationController.view menuItems:menuItems currentID:0];
}

- (void) pushMenuItem:(KxMenuItem *)sender
{
    [self.bookSetButton setTitle:sender.title forState:UIControlStateNormal];
    self.bookset_id = [sender.title integerValue];
    
    //作业知识点统计
    [self requestExamKnowledge];
    //作业题目认知能力统计
    [self requestExamAbility];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.isShowKnowledge) {
        NSParameterAssert(self.knowledgeArr);
        if (0 == self.knowledgeArr.count % 4) {
            return self.knowledgeArr.count/4;
        }else{
            return self.knowledgeArr.count/4 + 1;
        }
    }else{
        NSParameterAssert(self.abilityArr);
        if (0 == self.abilityArr.count % 4) {
            return self.abilityArr.count/4;
        }else{
            return self.abilityArr.count/4 + 1;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = nil;
    if (self.isShowKnowledge) {
        NSParameterAssert(self.knowledgeArr);
        arr = self.knowledgeArr;
    }else{
        NSParameterAssert(self.abilityArr);
        arr = self.abilityArr;
    }
    
    NSInteger tempInt = arr.count / ((indexPath.row + 1) * 4);
    NSInteger currentRowCount;
    NSInteger beginIndex;
    if (0 == tempInt) {
        currentRowCount = arr.count % 4;
        beginIndex = indexPath.row * 4;
    }else{
        currentRowCount = 4;
        beginIndex = indexPath.row * 4;
    }
    
    NSRange range = NSMakeRange(beginIndex, currentRowCount);
    NSArray *destArr = [arr subarrayWithRange:range];
    
    HBTaskStatisticalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KHBTaskStatisticalViewCellReuseId"];
    if (!cell) {
        cell = [[HBTaskStatisticalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KHBTaskStatisticalViewCellReuseId"];
    }
    
    [cell updateFormData:destArr isKnowledge:self.isShowKnowledge];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)reloadTableViewByArray
{
    NSMutableArray *arr = nil;
    if (self.isShowKnowledge) {
        arr = self.knowledgeArr;
    }else{
        arr = self.abilityArr;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        if ([arr count] == 0) {
            [_tableView showEmptyView:nil tips:@"还没有数据，请稍候刷新"];
        }
    });
}

-(void)requestExamKnowledge
{
    [MBHudUtil showActivityView:nil inView:nil];
    NSMutableDictionary *dateDic = [[HBWeekUtil sharedInstance] getWeekBeginAndEndWith:self.currentDate];
    
    NSDate *beginDate = [dateDic objectForKey:@"beginDate"];
    NSDate *endDate = [dateDic objectForKey:@"endDate"];
    
    NSString *beginDateStr = [NSString stringWithFormat:@"%.f",[beginDate timeIntervalSince1970]];
    NSString *endDateStr = [NSString stringWithFormat:@"%.f",[endDate timeIntervalSince1970]];
    
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBServiceManager defaultManager] requestExamKnowledge:userEntity bookset_id:[NSString stringWithFormat:@"%ld", self.bookset_id] from_time:beginDateStr to_time:endDateStr completion:^(id responseObject, NSError *error) {
        if (responseObject) {
            [self.knowledgeArr removeAllObjects];
            NSArray *arr = [responseObject arrayForKey:@"knowledge_stat"];
            for (NSDictionary *dic in arr)
            {
                HBExamKnowledgeEntity *knowledgeEntity = [[HBExamKnowledgeEntity alloc] init];
                knowledgeEntity.knowledge = [dic stringForKey:@"knowledge"];
                knowledgeEntity.total = [[dic numberForKey:@"total"] integerValue];
                knowledgeEntity.correct = [[dic numberForKey:@"correct"] integerValue];
                if ([knowledgeEntity.knowledge integerValue] == 11) {
                    knowledgeEntity.tag = @"惯用短语";
                } else {
                    knowledgeEntity.tag = [dic stringForKey:@"tag"];
                }
                
                [self.knowledgeArr addObject:knowledgeEntity];
            }
        }
        [MBHudUtil hideActivityView:nil];
        
        if (self.isShowKnowledge) {
            [self reloadTableViewByArray];
        }
    }];
}

-(void)requestExamAbility
{
    [MBHudUtil showActivityView:nil inView:nil];
    NSMutableDictionary *dateDic = [[HBWeekUtil sharedInstance] getWeekBeginAndEndWith:self.currentDate];
    
    NSDate *beginDate = [dateDic objectForKey:@"beginDate"];
    NSDate *endDate = [dateDic objectForKey:@"endDate"];
    
    NSString *beginDateStr = [NSString stringWithFormat:@"%.f",[beginDate timeIntervalSince1970]];
    NSString *endDateStr = [NSString stringWithFormat:@"%.f",[endDate timeIntervalSince1970]];
    
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBServiceManager defaultManager] requestExamAbility:userEntity bookset_id:[NSString stringWithFormat:@"%ld", self.bookset_id] from_time:beginDateStr to_time:endDateStr completion:^(id responseObject, NSError *error) {
        if (responseObject) {
            [self.abilityArr removeAllObjects];
            NSArray *arr = [responseObject arrayForKey:@"ability_stat"];
            for (NSDictionary *dic in arr)
            {
                HBExamAbilityEntity *abilityEntity = [[HBExamAbilityEntity alloc] init];
                abilityEntity.ability = [dic stringForKey:@"ability"];
                abilityEntity.total = [[dic numberForKey:@"total"] integerValue];
                abilityEntity.correct = [[dic numberForKey:@"correct"] integerValue];
                abilityEntity.tag = [dic stringForKey:@"tag"];
                
                [self.abilityArr addObject:abilityEntity];
            }
        }
        [MBHudUtil hideActivityView:nil];
        
        if (self.isShowKnowledge == NO) {
            [self reloadTableViewByArray];
        }
    }];
}

@end
