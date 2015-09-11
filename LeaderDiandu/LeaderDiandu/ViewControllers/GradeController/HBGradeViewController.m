//
//  HBGradeViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/8/26.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBGradeViewController.h"
#import "UIViewController+AddBackBtn.h"
#import "HBTitleView.h"
#import "DHSlideMenuController.h"
#import "HBGridView.h"
#import "TextGridItemView.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"
#import "HBContentManager.h"
#import "HBContentEntity.h"
#import "HBContentDetailDB.h"
#import "FTMenu.h"

#import "Leader21SDKOC.h"
#import "DownloadEntity.h"
#import "DataEngine.h"

#define LEADERSDK [Leader21SDKOC sharedInstance]

#define DataSourceCount 10

@interface HBGradeViewController ()<HBGridViewDelegate>
{
    HBGridView *_gridView;
    NSInteger currentID;
}

@property (nonatomic, strong)NSMutableArray *contentEntityArr;
@property (nonatomic, strong)NSMutableDictionary *contentDetailEntityDic;

@property (nonatomic, copy) NSString* bookDownloadUrl;

@end

@implementation HBGradeViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.contentEntityArr = [[NSMutableArray alloc] initWithCapacity:1];
        self.contentDetailEntityDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        currentID = 1;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [LEADERSDK setAppKey:KAppKeyStudy];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:kNotification_bookDownloadProgress object:nil];
    
    [self initMainView];
    [self initMainGrid];
    [self initButton];
    //获取所有可选套餐
    [self requestAllBookset];
}

- (void)initMainView
{
    HBTitleView *labTitle = [HBTitleView titleViewWithTitle:@"课外宝" onView:self.view];
    labTitle.textColor = [UIColor blackColor];
    [self.view addSubview:labTitle];
}

- (void)initMainGrid
{
    _gridView = [[HBGridView alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth, ScreenHeight)];
    _gridView.delegate = self;
    _gridView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_gridView];
}

-(void)showPullView
{
    NSMutableArray *menuItems = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (HBContentEntity *contentEntity in self.contentEntityArr) {
        NSString * bookIdStr = [NSString stringWithFormat:@"%ld", contentEntity.bookId];
        KxMenuItem *item = [KxMenuItem
                            menuItem:bookIdStr
                            image:nil
                            target:self
                            action:@selector(pushMenuItem:)];
        [menuItems addObject:item];
    }
 
    CGRect menuFrame = CGRectMake(ScreenWidth - 70, 70, 60, 50 * self.contentEntityArr.count);

    [FTMenu showMenuWithFrame:menuFrame inView:self.navigationController.view menuItems:menuItems];
}

- (void) pushMenuItem:(KxMenuItem *)sender
{
//    if ([sender.title isEqualToString:@"1"]) {
//        
//    }else if([sender.title isEqualToString:@"2"]){
//        
//    }else if([sender.title isEqualToString:@"3"]){
//        
//    }else if([sender.title isEqualToString:@"4"]){
//        
//    }else if([sender.title isEqualToString:@"5"]){
//        
//    }else if([sender.title isEqualToString:@"6"]){
//        
//    }else if([sender.title isEqualToString:@"7"]){
//        
//    }else if([sender.title isEqualToString:@"8"]){
//        
//    }else if([sender.title isEqualToString:@"9"]){
//        
//    }

    currentID = [sender.title integerValue];
    //获取书本列表
    [self requestContentDetailEntity];
}

- (void)initButton
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 20, 44, 44)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"ToggleMenu"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(ToggleMenuPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 8 - 44, 20, 44, 44)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"ToggleMenu"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
}

- (void)ToggleMenuPressed:(id)sender
{
    [[DHSlideMenuController sharedInstance] showLeftViewController:YES];
}

- (void)rightButtonPressed:(id)sender
{
    [self showPullView];
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

#pragma mark -
#pragma mark HBGridViewDelegate

// 获取单元格的总数
- (NSInteger)gridNumberOfGridView:(HBGridView *)gridView
{
    NSMutableArray *arr = [self.contentDetailEntityDic objectForKey:[NSString stringWithFormat:@"%ld", currentID]];
    return arr.count;
}

// 获取gridview每行显示的grid数
- (NSInteger)columnNumberOfGridView:(HBGridView *)gridView
{
    return 3;
}

// 获取单元格的行数
- (NSInteger)rowNumberOfGridView:(HBGridView *)gridView
{
    NSMutableArray *arr = [self.contentDetailEntityDic objectForKey:[NSString stringWithFormat:@"%ld", currentID]];
    
    if (arr.count % [self columnNumberOfGridView:gridView])
    {
        return arr.count / [self columnNumberOfGridView:gridView] + 1;
    }
    else
    {
        return arr.count / [self columnNumberOfGridView:gridView];
    }
}

- (CGFloat)gridView:(HBGridView *)gridView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenHeight / 3.0f;
}

// 获取特定位置的单元格视图
- (HBGridItemView *)gridView:(HBGridView *)gridView inGridCell:(HBGridCellView *)gridCell gridItemViewAtGridIndex:(GridIndex *)gridIndex listIndex:(NSInteger)listIndex
{
    NSLog(@"list index:%ld", listIndex);
    TextGridItemView *itemView = (TextGridItemView *)[gridView dequeueReusableGridItemAtGridIndex:gridIndex ofGridCellView:gridCell];
    if (!itemView)
    {
        itemView = [[TextGridItemView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/3, ScreenHeight/3)];
    }
    
    NSMutableArray *arr = [self.contentDetailEntityDic objectForKey:[NSString stringWithFormat:@"%ld", currentID]];
    
    NSMutableDictionary *dic = [arr objectAtIndex:listIndex];
    
    NSDictionary * targetData = [[NSDictionary alloc]initWithObjectsAndKeys:
                                 [dic objectForKey:@"BOOK_TITLE_CN"], TextGridItemView_BookName,[dic objectForKey:@"FILE_ID"], TextGridItemView_BookCover,@"mainGrid_download", TextGridItemView_downloadState,
                                 nil];
    [itemView updateFormData:targetData];
    return itemView;
}

- (void)gridView:(HBGridView *)gridView didSelectGridItemAtIndex:(NSInteger)index
{
    HBGridItemView *itemView = [gridView gridItemViewAtIndex:index];
    itemView.backgroundColor = [UIColor grayColor];
    
    NSMutableArray *arr = [self.contentDetailEntityDic objectForKey:[NSString stringWithFormat:@"%ld", currentID]];
    NSMutableDictionary *dic = [arr objectAtIndex:index];
    [LEADERSDK startDownloadBookByDict:dic];
}

- (void)requestAllBookset
{
    NSDictionary *dict = [[HBDataSaveManager defaultManager] loadUser];
    if (dict) {
        NSString *user = [dict objectForKey:@"name"];
        NSString *token = [dict objectForKey:@"token"];
        //获取所有可选套餐
        [[HBServiceManager defaultManager] requestAllBookset:user token:token completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                //获取所有可选套餐成功
                NSArray *arr = [responseObject objectForKey:@"booksets"];
                for (NSDictionary *dict in arr)
                {
                    HBContentEntity *contentEntity = [[HBContentEntity alloc] initWithDictionary:dict];
                    [self.contentEntityArr addObject:contentEntity];
                }
                //获取书本列表
                [self requestContentDetailEntity];
            }
        }];
    }
}

-(void)requestContentDetailEntity
{
    //获取书本列表
    for (HBContentEntity *contentEntity in self.contentEntityArr) {
        if (contentEntity.bookId == currentID) {
            [[HBContentManager defaultManager] requestBookList:contentEntity.books completion:^(id responseObject, NSError *error) {
                if (responseObject){
                    //获取书本列表成功
                    NSArray *arr = [responseObject objectForKey:@"books"];
                    [self.contentDetailEntityDic setObject:arr forKey:[NSString stringWithFormat:@"%ld", (long)currentID]];
                    [[HBContentDetailDB sharedInstance] updateHBContentDetail:arr];
                    [_gridView reloadData];
                }
            }];
            
            break;
        }
    }
}

- (void)updateProgress:(NSNotification*)notification
{
    if ([notification.object isKindOfClass:[BookEntity class]]) {
        BookEntity* book = (BookEntity*)notification.object;
        if ([book.bookUrl isEqualToString:self.bookDownloadUrl]) {
            
            if (book.download == nil) {
                NSPredicate* pre = [NSPredicate predicateWithFormat:@"downloadUrl == %@", book.bookUrl];
//                DownloadEntity* download = (DownloadEntity*)[BookListCellView getFirstObjectWithEntryName:@"DownloadEntity" withPredicate:pre];
//                book.download = download;
            }
            [self resetWithBook:book];
        }
    }

//    NSInteger per =  [[notification.userInfo objectForKey:@"progress"] integerValue];
//    
//    if (per == 1) {
//        [LEADERSDK readBook:(BookEntity*)notification.object useNavigation:self.navigationController];
//
//    }
}

- (void)resetWithBook:(BookEntity *)book
{
    TextGridItemView *itemView = (TextGridItemView *)[_gridView gridItemViewAtIndex:_gridView.selIndex];
    [itemView resetWithBook];
    
    CGFloat progress = book.download.progress.floatValue;
    
    // 是否正在下载
    NSInteger s = book.download.status.integerValue;
    NSLog(@"download status:%ld, progress:%f", (long)s, progress);
    if (book.download != nil) {
        if (book.download.status.integerValue != downloadStatusFinished) {
            if (progress > 0.97f) {
                progress = 0.97f;
            }
        }
    }
    if (book.download != nil && (progress < 1.0f || book.download.status.integerValue == downloadStatusUnZipping)) {
        if (s == downloadStatusPause) {
//            self.progressView.hidden = YES;
//            self.pauseView.hidden = NO;
            NSLog(@"download status:pause");
        }
        else {
            if (progress < 0.005) {
                progress = 0.005;
            }
            if (downloadStatusUnZipping == book.download.status.integerValue) {
                progress = 0.97f;
            }
            else if (progress == 1.0f) {
                book.download.status = @(downloadStatusFinished);
            }
//            self.progressView.hidden = NO;
//            self.pauseView.hidden = YES;
//            self.progressView.alpha = 1.0f;
//            self.progressView.progress = progress;
            NSLog(@"download status:downing");
        }
//        if (book.hasBook.boolValue) {
//            self.priceButton.hidden = YES;
//            self.readProgressLabel.text = [NSString stringWithFormat:@"Read %d%%", book.readProgress.integerValue];
//            self.readProgressLabel.hidden = NO;
//        }
//        else {
//            self.priceButton.hidden = NO;
//            self.readProgressLabel.hidden = YES;
//        }
    }
}

@end
