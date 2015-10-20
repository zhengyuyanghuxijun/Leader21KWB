//
//  HBRankingListViewController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/17.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBRankingListViewController.h"
#import "HBWeekUtil.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"
#import "FTMenu.h"

@interface HBRankingListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, assign)NSInteger weekOfYear;  //一年中的第几周
@property (nonatomic, assign)NSInteger bookset_id;  //套餐ID

@property (nonatomic, strong)UIButton *myRankingButton;  //我的排行
@property (nonatomic, strong)UIButton *allRankingButton;  //全国排行
@property (nonatomic, strong) UILabel * myRankingSeperator;
@property (nonatomic, strong) UILabel * allRankingSeperator;

@property (nonatomic, assign) BOOL isShowMyRanking;

@property (nonatomic, strong) NSMutableArray *myBooksArr;
@property (nonatomic, strong) NSMutableArray *allBooksArr;

@property (strong, nonatomic) UIButton *bookSetButton;

@end


@implementation HBRankingListViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.weekOfYear = [[HBWeekUtil sharedInstance] getWeekOfYear];
        self.bookset_id = 1;
        
        self.myBooksArr = [[NSMutableArray alloc] initWithCapacity:1];
        self.allBooksArr = [[NSMutableArray alloc] initWithCapacity:1];
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
    self.title = @"排行榜";
    
    [self initButton];
    [self initSelectBookSetView];

    [self requestReadingRank];
    
    [self addTableView];
}

-(void)addTableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, KHBNaviBarHeight + 50 + 50, ScreenWidth, ScreenHeight - KHBNaviBarHeight - 50 - 50)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tableView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initButton{
    //我的排行按钮
    CGRect rc = CGRectMake(0.0f, KHBNaviBarHeight, self.view.frame.size.width/2, 50.0f);
    self.myRankingButton = [[UIButton alloc] initWithFrame:rc];
    [self.myRankingButton setBackgroundColor:[UIColor colorWithHex:0x1E90FF]];
    [self.myRankingButton setTitle:@"我的" forState:UIControlStateNormal];
    [self.myRankingButton addTarget:self action:@selector(myRankingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.myRankingButton];
    
    self.myRankingSeperator = [[UILabel alloc] initWithFrame:CGRectMake(0, self.myRankingButton.frame.size.height - 2, self.myRankingButton.frame.size.width, 2)];
    self.myRankingSeperator.backgroundColor = [UIColor blueColor];
    [self.myRankingButton addSubview:self.myRankingSeperator];
    
    //全国排行按钮
    rc = CGRectMake(self.view.frame.size.width/2, KHBNaviBarHeight, self.view.frame.size.width/2, 50.0f);
    self.allRankingButton = [[UIButton alloc] initWithFrame:rc];
    [self.allRankingButton setBackgroundColor:[UIColor colorWithHex:0x1E90FF]];
    [self.allRankingButton setTitle:@"全国" forState:UIControlStateNormal];
    [self.allRankingButton addTarget:self action:@selector(allRankingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.allRankingButton];
    
    self.allRankingSeperator = [[UILabel alloc] initWithFrame:CGRectMake(0, self.allRankingButton.frame.size.height - 2, self.allRankingButton.frame.size.width, 2)];
    self.allRankingSeperator.backgroundColor = [UIColor blueColor];
    [self.allRankingButton addSubview:self.allRankingSeperator];
    
    [self showMyRankingView:YES];
}

- (void)initSelectBookSetView
{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, KHBNaviBarHeight + 50, ScreenWidth, 50);
    bgView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:bgView];
    
    UILabel *seperator = [[UILabel alloc] initWithFrame:CGRectMake(0, bgView.frame.size.height - 1, bgView.frame.size.width, 1)];
    seperator.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:seperator];
    
    //套餐按钮
    self.bookSetButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 8 - 44, (50 - 35)/2, 35, 35)];
    [self.bookSetButton setBackgroundImage:[UIImage imageNamed:@"bookshelf-btn-class"] forState:UIControlStateNormal];
    [self.bookSetButton addTarget:self action:@selector(bookSetButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.bookSetButton setTitle:[NSString stringWithFormat:@"%ld", self.bookset_id] forState:UIControlStateNormal];
    [self.bookSetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bgView addSubview:self.bookSetButton];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)myRankingButtonPressed
{
    self.isShowMyRanking = YES;
    if (0 == self.myBooksArr.count) {
//        [self requestReadingRank];
    }
    
    [_tableView reloadData];
    
    [self showMyRankingView:YES];
}

-(void)allRankingButtonPressed
{
    self.isShowMyRanking = NO;
    if (0 == self.allBooksArr.count) {
//        [self requestAllReadingRank];
    }
    
    [_tableView reloadData];
    
    [self showMyRankingView:NO];
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
}

-(void)showMyRankingView:(BOOL)showMyRanking
{
    if (showMyRanking) {
        self.myRankingSeperator.hidden = NO;
        self.allRankingSeperator.hidden = YES;
    }else{
        self.myRankingSeperator.hidden = YES;
        self.allRankingSeperator.hidden = NO;
    }
}

-(void)requestReadingRank
{
    NSMutableDictionary *dateDic = [[HBWeekUtil sharedInstance] getWeekBeginAndEndWith:nil];
    
    NSDate *beginDate = [dateDic objectForKey:@"beginDate"];
    NSDate *endDate = [dateDic objectForKey:@"endDate"];
    
    NSString *beginDateStr = [NSString stringWithFormat:@"%.f",[beginDate timeIntervalSince1970]];
    NSString *endDateStr = [NSString stringWithFormat:@"%.f",[endDate timeIntervalSince1970]];
    
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBServiceManager defaultManager] requestReadingRank:[NSString stringWithFormat:@"%ld", userEntity.userid] bookset_id:[NSString stringWithFormat:@"%ld", self.bookset_id] from_time:beginDateStr to_time:endDateStr completion:^(id responseObject, NSError *error) {
        
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
    if (self.isShowMyRanking) {
        NSParameterAssert(self.myBooksArr);
        return self.myBooksArr.count;
    }else{
        NSParameterAssert(self.allBooksArr);
        return self.allBooksArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isShowMyRanking) {
        NSParameterAssert(self.myBooksArr);
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else{
        NSParameterAssert(self.allBooksArr);
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"456"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"456"];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
