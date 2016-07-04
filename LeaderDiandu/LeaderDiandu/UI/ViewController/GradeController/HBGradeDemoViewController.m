//
//  HBGradeDemoViewController.m
//  LeaderDiandu
//
//  Created by huxijun on 15/12/1.
//  Copyright © 2015年 hxj. All rights reserved.
//

#import "HBGradeDemoViewController.h"
#import "HBTitleView.h"
#import "UIViewController+AddBackBtn.h"
#import "DHSlideMenuController.h"
#import "DHSlideMenuViewController.h"
#import "HBGridView.h"
#import "TextGridItemView.h"
#import "HBDataSaveManager.h"
#import "HBContentManager.h"
#import "HBReadprogressEntity.h"

#import "AppDelegate.h"
#import "Leader21SDKOC.h"
#import "AFNetworkReachabilityManager.h"

#define LEADERSDK [Leader21SDKOC sharedInstance]

@interface HBGradeDemoViewController ()<HBGridViewDelegate, reloadGridDelegate>
{
    HBGridView *_gridView;
    DHSlideMenuController *_slideMenuVC;
}

@property (nonatomic, strong)UIButton *leftButton;
@property (nonatomic, strong)UIButton *rightButton;

@property (nonatomic, strong)NSArray *bookIdArray;
@property (nonatomic, strong)NSArray *bookEntityArr;
@property (nonatomic, strong)NSMutableDictionary *readProgressEntityDic;

@property (nonatomic, assign)AFNetworkReachabilityStatus networkState;

@end

@implementation HBGradeDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.bookIdArray = @[@"5", @"6", @"10", @"12", @"16", @"17"];
        self.readProgressEntityDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        //用户阅读书籍返回通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReadBookBack:) name:kNotification_ReadBookBack object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [LEADERSDK setAppKey:KAppKeyKWB];
    [LEADERSDK setServerUrl:CONTENTAPI];
    [self addObserverNet];
    
    CGRect rect = self.view.frame;
    UIImageView *navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect), KHBNaviBarHeight)];
    navView.image = [UIImage imageNamed:@"bookshelf-bg-navi"];
    [self.view addSubview:navView];
    
    [self initMainView];
    [self initMainGrid];
    [self initButton];
    
    [self requestContentDetailEntity];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initMainView
{
    HBTitleView *labTitle = [HBTitleView titleViewWithTitle:@"课外宝" onView:self.view];
    labTitle.textColor = [UIColor blackColor];
    [self.view addSubview:labTitle];
}

- (void)initMainGrid
{
    if (_gridView == nil) {
        _gridView = [[HBGridView alloc] initWithFrame:CGRectMake(0, KHBNaviBarHeight, ScreenWidth, ScreenHeight - KHBNaviBarHeight)];
        _gridView.delegate = self;
        _gridView.backgroundColor = [UIColor clearColor];
        [_gridView setBackgroundView:@"bookshelf-bg-body"];
//        [_gridView setHeaderViewHidden:NO];

        [self.view addSubview:_gridView];
    }
}

- (void)initButton
{
    //左按钮
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 20, 44, 44)];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"bookshelf-btn-menu"] forState:UIControlStateNormal];//menu_user_pohoto//
    [self.leftButton addTarget:self action:@selector(ToggleMenuPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftButton];
    
    //右按钮
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 8 - 44, 20, 44, 44)];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"bookshelf-btn-class"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitle:@"1" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.rightButton];
}

#pragma mark - Button Action

- (void)ToggleMenuPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self showLoginAlert:@"你尚未登录，无法完成操作，请登录后重试。"];
}

- (void)rightButtonPressed:(id)sender
{
    [self showLoginAlert:@"获取更多等级内容，请登录。"];
}

#pragma mark HBGridViewDelegate

// 获取单元格的总数
- (NSInteger)gridNumberOfGridView:(HBGridView *)gridView
{
    return _bookEntityArr.count+1;
}

// 获取gridview每行显示的grid数
- (NSInteger)columnNumberOfGridView:(HBGridView *)gridView
{
    return 3;
}

// 获取单元格的行数
- (NSInteger)rowNumberOfGridView:(HBGridView *)gridView
{
    NSInteger count = _bookEntityArr.count + 1;
    if (count % [self columnNumberOfGridView:gridView])
    {
        return count / [self columnNumberOfGridView:gridView] + 1;
    }
    else
    {
        return count / [self columnNumberOfGridView:gridView];
    }
}

- (CGFloat)gridView:(HBGridView *)gridView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (ScreenHeight - KHBNaviBarHeight) / 3.0f;
}

// 获取特定位置的单元格视图
- (HBGridItemView *)gridView:(HBGridView *)gridView inGridCell:(HBGridCellView *)gridCell gridItemViewAtGridIndex:(GridIndex *)gridIndex listIndex:(NSInteger)listIndex
{
    NSLog(@"list index:%ld", (long)listIndex);
    TextGridItemView *itemView = (TextGridItemView *)[gridView dequeueReusableGridItemAtGridIndex:gridIndex ofGridCellView:gridCell];
    if (!itemView)
    {
        itemView = [[TextGridItemView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/3, (ScreenHeight - KHBNaviBarHeight)/3)];
    }
    
    itemView.delegate = self;
    itemView.touchEnable = NO;
    
    if (listIndex == [_bookEntityArr count]) {
        //默认封皮
        [itemView.bookCoverButton setBackgroundImage:[UIImage imageNamed:@"cover_get_more"] forState:UIControlStateNormal];
//        itemView.bookNameLabel.text = @"更多资源";
        return itemView;
    }
    
    BookEntity *entity = _bookEntityArr[listIndex];
    NSString *bookTitle = entity.bookTitleCN;
    if ([[HBDataSaveManager defaultManager] showEnBookName]) {
        bookTitle = entity.bookTitle;
    }
    
    NSDictionary * targetData = [[NSDictionary alloc]initWithObjectsAndKeys:
                                 bookTitle, TextGridItemView_BookName,entity.fileId, TextGridItemView_BookCover, @"mainGrid_download", TextGridItemView_downloadState, @"0", TextGridItemView_isVip, nil];
    
    [itemView updateFormData:targetData];
    
    itemView.bookDownloadUrl = entity.bookUrl;
    NSString *book_id = [NSString stringWithFormat:@"%@", entity.bookId];
    HBReadprogressEntity *readprogressEntity = [_readProgressEntityDic objectForKey:book_id];
    NSString *progress = readprogressEntity.progress;
    if ([LEADERSDK isBookDownloaded:entity]) {
        [itemView bookDownloaded:entity progress:progress isTask:NO];
    }else if([LEADERSDK isBookDownloading:entity]){
        [itemView bookDownloading:entity];  //正在下载
    }else{
        [itemView bookUnDownload:entity];   //未下载
    }
    
    return itemView;
}

- (void)gridView:(HBGridView *)gridView didSelectGridItemAtIndex:(NSInteger)index
{
    if (index == _bookEntityArr.count) {
        [self showLoginAlert:@"获取更多内容，请登录。"];
        return;
    }
    TextGridItemView *itemView = (TextGridItemView *)[gridView gridItemViewAtIndex:index];
    
    BookEntity *entity = _bookEntityArr[index];
    
    if (itemView.isTest && [LEADERSDK isBookDownloading:entity]==NO) {
        //跳转作业逻辑
    } else {
        //记录一下开始阅读时间
        
        BOOL isDownloaded = [LEADERSDK bookPressed:entity useNavigation:myAppDelegate.globalNavi];
        if (isDownloaded == NO) {
            [self handleDownload:entity];
        }
        itemView.bookDownloadUrl = entity.bookUrl;
    }
}

-(void)reloadGridView
{
    [_gridView reloadData];
}

- (void)handleDownload:(BookEntity *)entity
{
    BOOL wifiDownload = [[HBDataSaveManager defaultManager] wifiDownload];
    if (_networkState == AFNetworkReachabilityStatusReachableViaWiFi) {
        [LEADERSDK startDownloadBook:entity];
    } else {
        if (wifiDownload) {
            //提示非wifi
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"WiFi设置" message:@"已开启仅用WiFi下载，请连接WiFi网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            alertView.tag = 1002;
            [alertView show];
        } else {
            [LEADERSDK startDownloadBook:entity];
        }
    }
}

- (void)showLoginAlert:(NSString *)tips
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:tips delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"马上登录", nil];
    alertView.tag = 1001;
    [alertView show];
}

#pragma mark - actionSheetDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (alertView.tag == 1002) {
        if (buttonIndex == 1) {
            //开启设置wifi页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
        }
    }
}

#pragma mark - 网络请求
-(void)requestContentDetailEntity
{
    //获取书本列表
    [MBHudUtil showActivityView:nil inView:nil];
    NSString *destBooksStr = [_bookIdArray componentsJoinedByString:@","];
    [LEADERSDK requestBookInfo:destBooksStr onComplete:^(NSArray *booklist, NSInteger errorCode, NSString *errorMsg) {
        [MBHudUtil hideActivityView:nil];
        NSMutableArray *booklistTmp = [[NSMutableArray alloc] initWithCapacity:1];
        for (BookEntity *entityTmp in booklist) {
            [booklistTmp addObject:entityTmp];
        }
        
        //如果缓存中有数据，先不要清空，可能这个时候缓存中的数据保存着正在下载书籍的URL等信息
        for (BookEntity *entity in _bookEntityArr) {
            for (NSInteger index = 0; index < booklistTmp.count; index++) {
                BookEntity *newEntity = [booklistTmp objectAtIndex:index];
                if ([entity.fileId isEqualToString:newEntity.fileId]) {
                    [booklistTmp replaceObjectAtIndex:index withObject:entity];
                    break;
                }
            }
        }
        self.bookEntityArr = booklistTmp;
        
        [_gridView hideRefreshView];
        [_gridView reloadData];
    }];
}

-(void)ReadBookBack:(NSNotification*)note
{
    //记录一下结束阅读时间
    NSMutableDictionary *dic = (NSMutableDictionary *)[note userInfo];
    NSString *bookId = [dic objectForKey:@"book_id"];
    NSString *progress = [dic objectForKey:@"progress"];
    HBReadprogressEntity *readprogressEntity = [[HBReadprogressEntity alloc] init];
    readprogressEntity.book_id = bookId;
    readprogressEntity.progress = progress;
    readprogressEntity.exam_assigned = NO; //先临时设置为NO
    [self.readProgressEntityDic setObject:readprogressEntity forKey:bookId];
    [_gridView reloadData];
}

#pragma mark - 更新网络
-(void)addObserverNet
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)networkStateChange
{
//    NSString *state = [self getNetWorkStates];
    
    [self isNetworkEnable];
}

- (BOOL)isNetworkEnable
{
    BOOL flag = YES;
    AFNetworkReachabilityStatus state=  [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    self.networkState = state;
    switch (state) {
        case AFNetworkReachabilityStatusNotReachable:
            flag = NO;
            NSLog(@"没网络");
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:;{
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            //            NSLog(@"WiFi网络");
            break;
        default:
            break;
    }
    return flag;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
