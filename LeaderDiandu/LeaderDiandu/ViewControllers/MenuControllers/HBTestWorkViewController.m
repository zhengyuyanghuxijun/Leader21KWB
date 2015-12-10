//
//  HBTestWorkViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/1.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBTestWorkViewController.h"
#import "HBMyWorkViewController.h"
#import "HBPayViewController.h"

#import "HBDataSaveManager.h"
#import "HBServiceManager.h"
#import "HBContentManager.h"
#import "HBTaskEntity.h"
#import "TimeIntervalUtils.h"
#import "LocalSettings.h"
#import "UIImageView+AFNetworking.h"
#import "HBTestWorkManager.h"
#import "HBExamIdDB.h"
#import "HBTableView.h"

static NSString * const KTestWorkViewControllerCellReuseId = @"KTestWorkViewControllerCellReuseId";

@implementation HBTestWorkViewCell

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
    UIFont *fontTime = [UIFont systemFontOfSize:14];
    //时间
    self.cellTime = [[UILabel alloc] init];
    _cellTime.font = fontTime;
    self.cellTime.textColor = [UIColor lightGrayColor];
    self.cellTime.frame = CGRectMake(10, 5, 100, 25);
    [self addSubview:self.cellTime];
    
    //老师
    self.cellTeacherName = [[UILabel alloc] init];
    self.cellTeacherName.textColor = KLeaderRGB;
    self.cellTeacherName.frame = CGRectMake(CGRectGetMaxX(self.cellTime.frame), 5, 80, 25);
    [self addSubview:self.cellTeacherName];
    
    //书皮
    self.cellImageBookCover = [[UIImageView alloc] init];
    self.cellImageBookCover.frame = CGRectMake(10, 35, 50, 60);
    [self addSubview:self.cellImageBookCover];
    
    float controlW = 85;
    float controlX = ScreenWidth-controlW-25;
    //分数
    self.cellScore = [[UILabel alloc] init];
    self.cellScore.textColor = KLeaderRGB;
    _cellScore.textAlignment = NSTextAlignmentRight;
    self.cellScore.frame = CGRectMake(controlX, 5, controlW, 20);
    [self addSubview:self.cellScore];
    
    self.cellModifiedTime = [[UILabel alloc] initWithFrame:CGRectMake(controlX, 25, controlW, 20)];
    _cellModifiedTime.font = fontTime;
    _cellModifiedTime.textColor = [UIColor lightGrayColor];
    _cellModifiedTime.textAlignment = NSTextAlignmentRight;
    [self addSubview:_cellModifiedTime];
    
    //状态
    self.cellSubmitState = [[UILabel alloc] init];
    _cellSubmitState.textAlignment = NSTextAlignmentRight;
    self.cellSubmitState.frame = CGRectMake(controlX, 35, controlW, 60);
    [self addSubview:self.cellSubmitState];
    
    //书名
    controlX = CGRectGetMaxX(self.cellImageBookCover.frame) + 10;
    controlW = CGRectGetMinX(self.cellSubmitState.frame) - controlX - 10;
    self.cellBookName = [[UILabel alloc] init];
    self.cellBookName.frame = CGRectMake(controlX, 35, controlW, 60);
    self.cellBookName.numberOfLines = 0;
    [self addSubview:self.cellBookName];
}

-(void)updateFormData:(id)sender
{
    HBTaskEntity *taskEntity = (HBTaskEntity*)sender;
    
    if (taskEntity) {
        self.cellTime.text = taskEntity.createdTime;
        self.cellModifiedTime.text = taskEntity.modifiedTime;
        self.cellTeacherName.text = taskEntity.teacherName;
        
        if ([taskEntity.score length] == 0) {
            self.cellScore.text = nil;
        }else{
            NSInteger score = [taskEntity.score integerValue];
            if (100 == score) {
                self.cellScore.text = @"A+";
            }else if (score >=80 && score < 100){
                self.cellScore.text = @"A";
            }else if (score >= 60 && score < 80){
                self.cellScore.text = @"B";
            }else{
                self.cellScore.text = @"C";
            }
        }
        
        self.cellBookName.text = taskEntity.bookName;
        if (self.cellScore.text) {
            self.cellSubmitState.text = @"";
        }else{
            self.cellSubmitState.text = @"未提交";
        }
        
        NSString *fileIdStr = [taskEntity.fileId lowercaseString];
        NSString *urlStr = [NSString stringWithFormat:KHBBookImgFormatUrl, fileIdStr, fileIdStr];
        [self.cellImageBookCover setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"mainGrid_defaultBookCover"]];
    }
    //刷新cell
//    [self setNeedsLayout];
}

@end

@interface HBTestWorkViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    HBTableView *_tableView;
    HBTestWorkManager *_workManager;
}

@property (nonatomic, strong)NSMutableArray *taskEntityArr;

@end

@implementation HBTestWorkViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.taskEntityArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _workManager = [[HBTestWorkManager alloc] init];

    self.navigationController.navigationBarHidden = NO;
    self.title = @"我的作业";
    
    [self addTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestTaskListOfStudent];
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

-(void)addTableView
{
    CGRect rect = self.view.frame;
    CGRect viewFrame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    _tableView = [[HBTableView alloc] initWithFrame:viewFrame];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

-(void)requestTaskListOfStudent
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        NSString *user = userEntity.name;
//        NSString *timeStr = [NSString stringWithFormat:@"%f", [NSDate date].timeIntervalSince1970];
        [MBHudUtil showActivityView:nil inView:nil];
        [[HBServiceManager defaultManager] requestTaskListOfStudent:user from:0 count:100 completion:^(id responseObject, NSError *error) {
            [MBHudUtil hideActivityView:nil];
            if (responseObject) {
                //学生获取作业列表成功
                [self.taskEntityArr removeAllObjects];
                NSArray *arr = [responseObject arrayForKey:@"exams"];
                NSMutableArray *examArr = [[NSMutableArray alloc] initWithCapacity:1];
                for (NSDictionary *dic in arr)
                {
                    HBTaskEntity *taskEntity = [[HBTaskEntity alloc] init];
                    taskEntity.exam_id = [[dic numberForKey:@"exam_id"] integerValue];
                    
                    NSDictionary *teacherDic = [dic dicForKey:@"teacher"];
                    NSString *teacherName = [teacherDic stringForKey:@"display_name"];
                    if ([teacherName length] == 0) {
                        teacherName = [teacherDic stringForKey:@"name"];
                    }
                    taskEntity.teacherName = teacherName;
                    
                    NSDictionary *bookDic = [dic dicForKey:@"book"];
                    NSString *bookName;
                    if ([[HBDataSaveManager defaultManager] showEnBookName]) {
                        bookName = [bookDic stringForKey:@"book_title"];
                    }else{
                        bookName = [bookDic stringForKey:@"book_title_cn"];
                    }
                    taskEntity.bookId = [[bookDic numberForKey:@"id"] integerValue];
                    taskEntity.bookName = bookName;
                    taskEntity.fileId = [bookDic stringForKey:@"file_id"];
                    
                    NSTimeInterval interval = [[dic numberForKey:@"created_time"] doubleValue];
                    taskEntity.createdTime = [TimeIntervalUtils getStringMDHMSFromTimeInterval:interval];
                    interval = [[dic numberForKey:@"modified_time"] doubleValue];
                    taskEntity.modifiedTime = [TimeIntervalUtils getStringMDHMSFromTimeInterval:interval];
                    taskEntity.score = [dic stringForKey:@"score"];
          
                    [self.taskEntityArr addObject:taskEntity];
                    
                    [examArr addObject: [NSString stringWithFormat:@"%ld", taskEntity.exam_id]];
                }
                
                NSInteger count = self.taskEntityArr.count;
                if (count > 0) {
                    [_tableView reloadData];
                } else {
                    [_tableView showEmptyView:@"test_empty" tips:@"你的老师还没有布置作业哦"];
                }
                
                //获取作业成功保存数据库
                if (count > 0) {
                    if (examArr.count > 0) {
                        [[HBExamIdDB sharedInstance] updateHBExamId:examArr];
                        
                        //获取到最新数据了，要去掉红点提示
                        [AppDelegate delegate].hasNewExam = NO;
                        
                        //学生获取作业列表成功后发送通知
                        [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_GetExamSuccess object:nil];
                    }
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
    NSParameterAssert(self.taskEntityArr);
    return self.taskEntityArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(self.taskEntityArr);

    HBTestWorkViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KTestWorkViewControllerCellReuseId];
    if (!cell) {
        cell = [[HBTestWorkViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KTestWorkViewControllerCellReuseId];
    }
    
    HBTaskEntity *taskEntity = [self.taskEntityArr objectAtIndex:indexPath.row];
    [cell updateFormData:taskEntity];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        HBTaskEntity *taskEntity = [self.taskEntityArr objectAtIndex:indexPath.row];
        NSMutableDictionary *vipBookDic = [[HBDataSaveManager defaultManager] vipBookDic];
        NSNumber *bookID = [NSNumber numberWithInteger:taskEntity.bookId];
        BOOL isBookVip = [[vipBookDic objectForKey:bookID] isEqualToString:@"1"];
        BOOL isFree = [self isFreeBook:[bookID stringValue]];
        if (isBookVip || isFree==NO) {
            if (userEntity.account_status == 1) {
                [self showAlertView:@"你尚未开通VIP，无权下载阅读此书，请开通VIP后再试。"];
                return;
            } else if (userEntity.account_status == 3){
                [self showAlertView:@"你的VIP已过期，无权下载阅读此书，请重新激活后再试。"];
                return;
            }
        }
        
        [MBHudUtil showActivityView:nil inView:nil];
        NSString *user = userEntity.name;
        [[HBServiceManager defaultManager] requestBookInfo:user book_id:taskEntity.bookId completion:^(id responseObject, NSError *error) {
            // to do ...
            if (responseObject) {
                NSDictionary *dict = responseObject;
                if (dict == nil) {
                    [MBHudUtil hideActivityView:nil];
                    [MBHudUtil showTextViewAfter:@"服务器资源缺失，敬请期待"];
                } else {
                    NSString *url = dict[@"url"];
                    if (url) {
                        [self downloadTestWork:url onSelect:taskEntity];
                    }
                }
            }
        }];
    }
}

- (BOOL)isFreeBook:(NSString *)bookId
{
    BOOL isFree = NO;
    NSArray *freeBookArr = [[HBDataSaveManager defaultManager] freeBookIDArr];
    for (NSString *bookIds in freeBookArr) {
        NSRange range = [bookIds rangeOfString:bookId];
        if (range.length > 0) {
            isFree = YES;
            break;
        }
    }
    return isFree;
}

- (void)showAlertView:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:text delegate:self cancelButtonTitle:@"再等等" otherButtonTitles:@"现在激活", nil];
        alertView.tag = 0;
        [alertView show];
    });
}

#pragma mark - actionSheetDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            HBPayViewController *controller = [[HBPayViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void)downloadTestWork:(NSString *)url onSelect:(HBTaskEntity *)taskEntity
{
    NSString *path = [LocalSettings bookCachePath];
    path = [NSString stringWithFormat:@"%@/%@", path, KHBTestWorkPath];
    [[HBContentManager defaultManager] downloadFileURL:url savePath:path fileName:@"test.zip" completion:^(id responseObject, NSError *error) {
        [MBHudUtil hideActivityView:nil];
        if (responseObject && [responseObject isKindOfClass:[NSString class]]) {
            NSString *path = responseObject;
            [_workManager parseTestWork:path];
            HBMyWorkViewController *controller = [[HBMyWorkViewController alloc] init];
            controller.workManager = _workManager;
            controller.taskEntity = taskEntity;
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            [MBHudUtil showTextViewAfter:@"服务器资源缺失，敬请期待"];
        }
    }];
}

@end
