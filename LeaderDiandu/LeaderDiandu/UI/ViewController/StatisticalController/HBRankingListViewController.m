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
#import "HBRankBookEntity.h"
#import "HBRankingListCell.h"

static NSString * const KHBRankingListMybookCellReuseId = @"KHBRankingListMybookCellReuseId";
static NSString * const KHBRankingListAllbookCellReuseId = @"KHBRankingListAllbookCellReuseId";

@interface HBRankingListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

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
        
        self.bookset_id = 1;
        
        self.myBooksArr = [[NSMutableArray alloc] initWithCapacity:1];
        self.allBooksArr = [[NSMutableArray alloc] initWithCapacity:1];
        
        self.isShowMyRanking = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINavigationBar *naviBar = self.navigationController.navigationBar;
    //设置navigationBar背景颜色
    [naviBar setBarTintColor:HEXRGBCOLOR(0x1E90FF)];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"排行榜";
    
    [self initButton];
    [self initSelectBookSetView];

    [self requestReadingRank]; //我的排行
    [self requestAllReadingRank]; //全国排行
    
    [self addTableView];
}

-(void)addTableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, HBNavBarHeight + 50 + 50, HBFullScreenWidth, HBFullScreenHeight - HBNavBarHeight - 50 - 50)];
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
    //我的排行按钮
    CGRect rc = CGRectMake(0.0f, HBNavBarHeight, self.view.frame.size.width/2, 50.0f);
    self.myRankingButton = [[UIButton alloc] initWithFrame:rc];
    [self.myRankingButton setBackgroundColor:[UIColor whiteColor]];
    [self.myRankingButton setTitle:@"我的" forState:UIControlStateNormal];
    [self.myRankingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.myRankingButton addTarget:self action:@selector(myRankingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.myRankingButton];
    
    self.myRankingSeperator = [[UILabel alloc] initWithFrame:CGRectMake(0, self.myRankingButton.frame.size.height - 2, self.myRankingButton.frame.size.width, 2)];
    self.myRankingSeperator.backgroundColor = HEXRGBCOLOR(0x1E90FF);
    [self.myRankingButton addSubview:self.myRankingSeperator];
    
    //全国排行按钮
    rc = CGRectMake(self.view.frame.size.width/2, HBNavBarHeight, self.view.frame.size.width/2, 50.0f);
    self.allRankingButton = [[UIButton alloc] initWithFrame:rc];
    [self.allRankingButton setBackgroundColor:[UIColor whiteColor]];
    [self.allRankingButton setTitle:@"全国" forState:UIControlStateNormal];
    [self.allRankingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.allRankingButton addTarget:self action:@selector(allRankingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.allRankingButton];
    
    self.allRankingSeperator = [[UILabel alloc] initWithFrame:CGRectMake(0, self.allRankingButton.frame.size.height - 2, self.allRankingButton.frame.size.width, 2)];
    self.allRankingSeperator.backgroundColor = HEXRGBCOLOR(0x1E90FF);
    [self.allRankingButton addSubview:self.allRankingSeperator];
    
    [self showMyRankingView:YES];
}

- (void)initSelectBookSetView
{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, HBNavBarHeight + 50, HBFullScreenWidth, 50);
    bgView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:bgView];
    
    UILabel *seperator = [[UILabel alloc] initWithFrame:CGRectMake(0, bgView.frame.size.height - 1, bgView.frame.size.width, 1)];
    seperator.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:seperator];
    
    //套餐按钮
    self.bookSetButton = [[UIButton alloc] initWithFrame:CGRectMake(HBFullScreenWidth - 8 - 44, (50 - 35)/2, 35, 35)];
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
    [self showMyRankingView:YES];
    [_tableView reloadData];
}

-(void)allRankingButtonPressed
{
    self.isShowMyRanking = NO;
    [self showMyRankingView:NO];
    [_tableView reloadData];
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
    
    CGRect menuFrame = CGRectMake(HBFullScreenWidth - 75, 160, 60, 50 * 9);
    
    [FTMenu showMenuWithFrame:menuFrame inView:self.navigationController.view menuItems:menuItems currentID:0];
}

- (void) pushMenuItem:(KxMenuItem *)sender
{
    [self.bookSetButton setTitle:sender.title forState:UIControlStateNormal];
    self.bookset_id = [sender.title integerValue];
    
    [self requestReadingRank]; //我的排行
    [self requestAllReadingRank]; //全国排行
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
    NSDate *endDate = [dateDic objectForKey:@"endDate"];
    NSString *endDateStr = [NSString stringWithFormat:@"%.f",[endDate timeIntervalSince1970]];
    
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBServiceManager defaultManager] requestReadingRank:userEntity bookset_id:[NSString stringWithFormat:@"%ld", self.bookset_id] from_time:@"1433248966" to_time:endDateStr completion:^(id responseObject, NSError *error) {
        if (responseObject) {
            [self.myBooksArr removeAllObjects];
            NSArray *arr = [responseObject arrayForKey:@"books"];
            NSInteger rankNum = 0;
            for (NSDictionary *dic in arr)
            {
                rankNum++;
                HBRankBookEntity *rankBookEntity = [[HBRankBookEntity alloc] init];
                rankBookEntity.rank = [NSString stringWithFormat:@"%ld", rankNum];
                rankBookEntity.book_title = [dic stringForKey:@"book_title"];
                rankBookEntity.book_title_cn = [dic stringForKey:@"book_title_cn"];
                rankBookEntity.count = [[dic numberForKey:@"count"] stringValue];
                rankBookEntity.file_id = [dic stringForKey:@"file_id"];
                
                [self.myBooksArr addObject:rankBookEntity];
            }
            
            [_tableView reloadData];
        }
    }];
}

-(void)requestAllReadingRank
{
    NSMutableDictionary *dateDic = [[HBWeekUtil sharedInstance] getWeekBeginAndEndWith:nil];
    NSDate *endDate = [dateDic objectForKey:@"endDate"];
    NSString *endDateStr = [NSString stringWithFormat:@"%.f",[endDate timeIntervalSince1970]];
    
    [[HBServiceManager defaultManager] requestReadingRank:nil bookset_id:[NSString stringWithFormat:@"%ld", self.bookset_id] from_time:@"1433248966" to_time:endDateStr completion:^(id responseObject, NSError *error) {
        if (responseObject) {
            [self.allBooksArr removeAllObjects];
            NSArray *arr = [responseObject arrayForKey:@"books"];
            NSInteger rankNum = 0;
            for (NSDictionary *dic in arr)
            {
                rankNum++;
                HBRankBookEntity *rankBookEntity = [[HBRankBookEntity alloc] init];
                rankBookEntity.rank = [NSString stringWithFormat:@"%ld", rankNum];
                rankBookEntity.book_title = [dic stringForKey:@"book_title"];
                rankBookEntity.book_title_cn = [dic stringForKey:@"book_title_cn"];
                rankBookEntity.count = [[dic numberForKey:@"count"] stringValue];
                rankBookEntity.file_id = [dic stringForKey:@"file_id"];
                
                [self.allBooksArr addObject:rankBookEntity];
            }
            
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
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isShowMyRanking) {
        NSParameterAssert(self.myBooksArr);
        
        HBRankingListCell *cell = [tableView dequeueReusableCellWithIdentifier:KHBRankingListMybookCellReuseId];
        if (!cell) {
            cell = [[HBRankingListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KHBRankingListMybookCellReuseId];
        }
        
        [cell updateFormData:[self.myBooksArr objectAtIndex:indexPath.row]];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else{
        NSParameterAssert(self.allBooksArr);
        
        HBRankingListCell *cell = [tableView dequeueReusableCellWithIdentifier:KHBRankingListAllbookCellReuseId];
        if (!cell) {
            cell = [[HBRankingListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KHBRankingListAllbookCellReuseId];
        }
        
        [cell updateFormData:[self.allBooksArr objectAtIndex:indexPath.row]];
        
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
