//
//  HBBookManViewController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/18.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBBookManViewController.h"
#import "HBTitleView.h"
#import "UIViewController+AddBackBtn.h"
#import "Leader21SDKOC.h"
#import "LeaderSDKUtil.h"

#define LEADERSDK [Leader21SDKOC sharedInstance]

@interface HBBookManViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, strong) UILabel   *describeLabel;
@property (nonatomic, assign) NSInteger localBookSize;

@end

@implementation HBBookManViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.localBookSize = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HBTitleView *labTitle = [HBTitleView titleViewWithTitle:@"本地图书管理" onView:self.view];
    [self.view addSubview:labTitle];
    
    [self addBackButton];
    
    [self creatDescribeLabel];
    [self addTableView];
    
    ////////////////////////////////////////////////////////////
//    NSMutableArray *arr = [LEADERSDK getLocalBooks];
//    for (BookEntity *bookEntity in arr) {
//        NSString *bookStr = bookEntity.bookTitle;
//        
////        DownloadEntity *downloadEntity = (DownloadEntity *)bookEntity.download;
//        DownloadEntity *downloadEntity = [[LeaderSDKUtil defaultSDKUtil] queryEntityByUrl:bookEntity.bookUrl];
//        NSNumber *tmp = downloadEntity.totalSize;
//    }
    ////////////////////////////////////////////////////////////
    
}

-(void)creatDescribeLabel
{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, KHBNaviBarHeight, ScreenWidth, 44);
    bgView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bgView];
    
    self.describeLabel = [[UILabel alloc] init];
    self.describeLabel.frame = CGRectMake(10, KHBNaviBarHeight, ScreenWidth, 44);
    NSString *describeStr = [NSString stringWithFormat:@"本地图书共%ldM,存储空间剩余%@", self.localBookSize, [self freeSpace]];
    self.describeLabel.text = describeStr;
    [self.view addSubview:self.describeLabel];
}

-(void)addTableView
{
    CGRect rect = CGRectMake(0, KHBNaviBarHeight + 44, ScreenWidth, ScreenHeight - KHBNaviBarHeight - 44 - 44);
    _tableView = [[UITableView alloc] initWithFrame:rect];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

-(NSString *)freeSpace{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSString  * freeStr= [NSString stringWithFormat:@"%0.1fM", [freeSpace longLongValue]/1024.0/1024.0];
    
    return freeStr;
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
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KHBBookManViewControllerCellReuseId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KHBBookManViewControllerCellReuseId"];
    }
    
    cell.textLabel.text = @"我是一个程序猿！！！";
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
