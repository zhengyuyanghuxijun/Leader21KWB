//
//  HBWorkManViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/2.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBWorkManViewController.h"
#import "UIViewController+AddBackBtn.h"
#import "HBTitleView.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"
#import "HBManageTaskEntity.h"
#import "TimeIntervalUtils.h"
#import "UIImageView+AFNetworking.h"
#import "HBScoreListViewController.h"
#import "HBPublishWorkViewController.h"

#define KHBBookImgFormatUrl @"http://teach.61dear.cn:9083/bookImgStorage/%@.jpg?t=BASE64(%@)"
static NSString * const KWorkManViewControllerCellReuseId = @"KWorkManViewControllerCellReuseId";

@implementation HBWorkManViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (void) initUI
{
    //时间
    self.cellTime = [[UILabel alloc] init];
    self.cellTime.frame = CGRectMake(10, 5, 120, 25);
    [self addSubview:self.cellTime];
    
    //班级
    self.cellClassName = [[UILabel alloc] init];
    self.cellClassName.frame = CGRectMake(self.cellTime.frame.origin.x + self.cellTime.frame.size.width + 10, 5, 80, 25);
    [self addSubview:self.cellClassName];
    
    //完成
    UILabel * submittedTitle = [[UILabel alloc] init];
    submittedTitle.text = @"完成";
    submittedTitle.frame = CGRectMake(ScreenWidth - 110, 5, 50, 25);
    [submittedTitle setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:submittedTitle];
    self.cellSubmitted = [[UILabel alloc] init];
    self.cellSubmitted.frame = CGRectMake(ScreenWidth - 110, 25, 50, 25);
    [self.cellSubmitted setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.cellSubmitted];
    
    //总数
    UILabel * totleTitle = [[UILabel alloc] init];
    totleTitle.text = @"总数";
    totleTitle.frame = CGRectMake(ScreenWidth - 70, 5, 50, 25);
    [totleTitle setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:totleTitle];
    self.cellTotal = [[UILabel alloc] init];
    self.cellTotal.frame = CGRectMake(ScreenWidth - 70, 25, 50, 25);
    [self.cellTotal setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.cellTotal];
    
    //书皮
    self.cellImageBookCover = [[UIImageView alloc] init];
    self.cellImageBookCover.image = [UIImage imageNamed:@"mainGrid_defaultBookCover"];
    self.cellImageBookCover.frame = CGRectMake(10, 35, 50, 60);
    [self addSubview:self.cellImageBookCover];
    
    //书名
    self.cellBookName = [[UILabel alloc] init];
    self.cellBookName.frame = CGRectMake(self.cellImageBookCover.frame.origin.x + self.cellImageBookCover.frame.size.width + 10, 35, 200, 60);
    [self addSubview:self.cellBookName];
}

-(void)updateFormData:(id)sender
{
    HBManageTaskEntity *manageTaskEntity = (HBManageTaskEntity*)sender;
    
    if (manageTaskEntity) {
        self.cellTime.text = manageTaskEntity.taskTime;
        self.cellClassName.text = manageTaskEntity.className;
        self.cellSubmitted.text = [NSString stringWithFormat:@"%ld", manageTaskEntity.submitted];
        self.cellTotal.text = [NSString stringWithFormat:@"%ld", manageTaskEntity.total];
        self.cellBookName.text = manageTaskEntity.bookName;
        
        NSString *fileIdStr = manageTaskEntity.fileId;
        fileIdStr = [fileIdStr lowercaseString];
        NSString *urlStr = [NSString stringWithFormat:KHBBookImgFormatUrl, fileIdStr, fileIdStr];
        [self.cellImageBookCover setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"mainGrid_defaultBookCover"]];
    }
}

@end

@interface HBWorkManViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, strong) NSMutableArray *manageTaskEntityArr;
@property (nonatomic, strong) UIButton* assignWorkButton;

@end

@implementation HBWorkManViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.manageTaskEntityArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HBTitleView *labTitle = [HBTitleView titleViewWithTitle:@"作业管理" onView:self.view];
    [self.view addSubview:labTitle];
    
    [self addBackButton];

    [self requestTaskListOfTeacher];
    
    CGRect rc = CGRectMake(0.0f, ScreenHeight - 50.0f, ScreenWidth, 50.0f);
    self.assignWorkButton = [[UIButton alloc] initWithFrame:rc];
    [self.assignWorkButton setBackgroundImage:[UIImage imageNamed:@"user_button"] forState:UIControlStateNormal];
    [self.assignWorkButton setTitle:@"布置作业" forState:UIControlStateNormal];
    [self.assignWorkButton addTarget:self action:@selector(assignWorkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.assignWorkButton];
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

- (void)assignWorkButtonPressed:(id)sender
{
    HBPublishWorkViewController *vc = [[HBPublishWorkViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addTableView
{
    CGRect rect = self.view.frame;
    CGRect viewFrame = CGRectMake(0, KHBNaviBarHeight, rect.size.width, rect.size.height-KHBNaviBarHeight - 50);
    _tableView = [[UITableView alloc] initWithFrame:viewFrame];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

-(void)requestTaskListOfTeacher
{
    NSDictionary *dict = [[HBDataSaveManager defaultManager] loadUser];
    if (dict) {
        NSString *user = [dict objectForKey:@"name"];
        [[HBServiceManager defaultManager] requestTaskListOfTeacher:user from:0 count:100 completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                NSArray *arr = [responseObject objectForKey:@"exams"];
                for (NSDictionary *dic in arr)
                {
                    HBManageTaskEntity *manageTaskEntity = [[HBManageTaskEntity alloc] init];
                    NSDictionary *classDic = [dic objectForKey:@"class"];
                    NSString *className = [classDic objectForKey:@"name"];
                    manageTaskEntity.className = className;
                    
                    NSDictionary *bookDic = [dic objectForKey:@"book"];
                    NSString *bookName;
                    if ([[HBDataSaveManager defaultManager] showEnBookName]) {
                        bookName = [bookDic objectForKey:@"book_title"];
                    }else{
                        bookName = [bookDic objectForKey:@"book_title_cn"];
                    }
                    manageTaskEntity.bookName = bookName;
                    NSString *fileId = [bookDic objectForKey:@"file_id"];
                    manageTaskEntity.fileId = fileId;
                    
                    NSDictionary *statDic = [dic objectForKey:@"stat"];
                    NSString *submitted = [statDic objectForKey:@"submitted"];
                    manageTaskEntity.submitted = [submitted integerValue];
                    NSString *total = [statDic objectForKey:@"total"];
                    manageTaskEntity.total = [total integerValue];
                    
                    NSString *examId = [dic objectForKey:@"exam_id"];
                    manageTaskEntity.examId = [examId integerValue];
                    
                    NSTimeInterval interval = [[dic objectForKey:@"created_time"] doubleValue];
                    manageTaskEntity.taskTime = [TimeIntervalUtils getStringMDHMSFromTimeInterval:interval];
                    
                    [self.manageTaskEntityArr addObject:manageTaskEntity];
                }
                if (self.manageTaskEntityArr.count > 0) {
                    [self addTableView];
                }
            }
        }];
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
    NSParameterAssert(self.manageTaskEntityArr);
    return self.manageTaskEntityArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(self.manageTaskEntityArr);
    
    HBWorkManViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KWorkManViewControllerCellReuseId];
    if (!cell) {
        cell = [[HBWorkManViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KWorkManViewControllerCellReuseId];
    }
    
    HBManageTaskEntity *manageTaskEntity = [self.manageTaskEntityArr objectAtIndex:indexPath.row];
    [cell updateFormData:manageTaskEntity];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HBScoreListViewController *vc = [[HBScoreListViewController alloc] init];
    HBManageTaskEntity *manageTaskEntity = [self.manageTaskEntityArr objectAtIndex:indexPath.row];
    [vc setTitleStr:manageTaskEntity.bookName];
    [vc setExamId:manageTaskEntity.examId];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
