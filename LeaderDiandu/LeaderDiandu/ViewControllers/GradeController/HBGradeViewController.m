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
#import "HBReadprogressEntity.h"
#import "HBContentListDB.h"
#import "HBReadProgressDB.h"
#import "FTMenu.h"
#import "Leader21SDKOC.h"
#import "CoreDataHelper.h"
#import "ReadBookViewController.h"

#define LEADERSDK [Leader21SDKOC sharedInstance]

#define DataSourceCount 10

@interface HBGradeViewController ()<HBGridViewDelegate, reloadGridDelegate>
{
    HBGridView *_gridView;
    NSInteger currentID;
}

@property (nonatomic, strong)NSMutableArray *contentEntityArr;
@property (nonatomic, strong)NSMutableDictionary *contentDetailEntityDic;
@property (nonatomic, strong)NSMutableDictionary *readProgressEntityDic;

@property (nonatomic, strong)UIButton *rightButton;


@end

@implementation HBGradeViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.contentEntityArr = [[NSMutableArray alloc] initWithCapacity:1];
        self.contentDetailEntityDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        self.readProgressEntityDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        currentID = 1;
        
        //用户登录成功通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginSuccess) name:kNotification_LoginSuccess object:nil];
        
        //用户阅读书籍返回通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReadBookBack:) name:kNotification_ReadBookBack object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)LoginSuccess
{
    //登录成功，先从本地读取一下当前用户数据库中保存的全部阅读进度
    [self.readProgressEntityDic removeAllObjects];
    self.readProgressEntityDic = [[HBReadProgressDB sharedInstance] getAllReadprogressDic];
    
    currentID = 1;
    NSDictionary *dict = [[HBDataSaveManager defaultManager] loadUser];
    if (dict) {
        /** type: 1 - 学生； 10 - 老师*/
        NSInteger type = [[dict objectForKey:@"type"] integerValue];
        if (type == 1) {
            //从服务器拉取套餐信息
            [self requestAllBookset];
            
            //学生用户从服务器拉取最新的书籍阅读进度（老师用户直接从本地读取）
            NSString *user = [dict objectForKey:@"name"];
            NSString *token = [dict objectForKey:@"token"];
            [[HBServiceManager defaultManager] requestBookProgress:user token:token bookset_id:1 completion:^(id responseObject, NSError *error) {
                if (responseObject) {
                    //获取阅读进度成功
                    [self requestBookProgressSuccess:responseObject];
                }
            }];
        }else{
            //登录成功先load套餐信息，如果套餐信息为空则去服务器拉取数据
            NSString *booksIDsStr = [[HBContentListDB sharedInstance] booksidWithID:currentID];
            if (booksIDsStr) {
                [self.contentEntityArr removeAllObjects];
                self.contentEntityArr = [[HBContentListDB sharedInstance] getAllContentEntitys];
                
                //根据套餐id返回该套餐对应的books字符串,转换为数组格式,便于操作
                NSArray *booksIDsArr=[booksIDsStr componentsSeparatedByString:@","];
                [self getContentDetailEntitys:booksIDsArr];
                
            }else{
                //从服务器拉取套餐信息
                [self requestAllBookset];
            }
        }
    }
}

-(void)ReadBookBack:(NSNotification*)note
{
    NSMutableDictionary *dic = (NSMutableDictionary *)[note userInfo];
    NSString *bookId = [dic objectForKey:@"book_id"];
    NSString *progress = [dic objectForKey:@"progress"];
    
    HBReadprogressEntity *oldReadprogressEntity = [self.readProgressEntityDic objectForKey:bookId];
    NSString *oldProgress = oldReadprogressEntity.progress;
    
    //只有当新的阅读进度大于之前的阅读进度，才更新
    if ([progress integerValue] > [oldProgress integerValue]) {
        NSDictionary *dict = [[HBDataSaveManager defaultManager] loadUser];
        if (dict) {
            NSString *user = [dict objectForKey:@"name"];
            NSString *token = [dict objectForKey:@"token"];
            
            /** type: 1 - 学生； 10 - 老师*/
            NSInteger type = [[dict objectForKey:@"type"] integerValue];
            if (type == 1) {
                [[HBServiceManager defaultManager] requestUpdateBookProgress:user token:token book_id:[bookId integerValue] progress:[progress integerValue] completion:^(id responseObject, NSError *error) {
                    
                    NSString *book_id = [NSString stringWithFormat:@"%ld", [[responseObject objectForKey:@"book_id"] integerValue]];
                    NSString *progress = [NSString stringWithFormat:@"%ld", [[responseObject objectForKey:@"progress"] integerValue]];
                    NSString *exam_assigned = [responseObject objectForKey:@"exam_assigned"];
                    
                    HBReadprogressEntity *readprogressEntity = [self.readProgressEntityDic objectForKey:book_id];
                    
                    if (readprogressEntity) {
                        readprogressEntity.progress = progress;
                        readprogressEntity.exam_assigned = exam_assigned;
                    }else{
                        readprogressEntity = [[HBReadprogressEntity alloc] init];
                        readprogressEntity.book_id = book_id;
                        readprogressEntity.progress = progress;
                        readprogressEntity.exam_assigned = NO; //先临时设置为NO
                        [self.readProgressEntityDic setObject:readprogressEntity forKey:book_id];
                    }
                    
                    NSMutableArray *progressArr = [[NSMutableArray alloc] initWithCapacity:1];
                    [progressArr addObject:readprogressEntity];
                    
                    [[HBReadProgressDB sharedInstance] updateHBReadprogress:progressArr];
                    
                    [self reloadGrid];
                }];
            }else{
                
                HBReadprogressEntity *readprogressEntity = [self.readProgressEntityDic objectForKey:bookId];
                
                if (readprogressEntity) {
                    readprogressEntity.progress = progress;
                    readprogressEntity.exam_assigned = NO; //先临时设置为NO
                }else{
                    readprogressEntity = [[HBReadprogressEntity alloc] init];
                    readprogressEntity.book_id = bookId;
                    readprogressEntity.progress = progress;
                    readprogressEntity.exam_assigned = NO; //先临时设置为NO
                    [self.readProgressEntityDic setObject:readprogressEntity forKey:bookId];
                }
                
                NSMutableArray *progressArr = [[NSMutableArray alloc] initWithCapacity:1];
                [progressArr addObject:readprogressEntity];
                
                [[HBReadProgressDB sharedInstance] updateHBReadprogress:progressArr];
                
                [self reloadGrid];
            }
        }
    }
}

-(void)requestBookProgressSuccess:(id)responseObject
{
    NSArray *arr = [responseObject objectForKey:@"progress"];
    for (NSDictionary *dict in arr)
    {
        NSString *book_id = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"id"] integerValue]];
        NSString *progress = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"progress"] integerValue]];
        
        HBReadprogressEntity *readprogressEntity = [self.readProgressEntityDic objectForKey:book_id];
        
        if (readprogressEntity) {
            readprogressEntity.progress = progress;
        }else{
            readprogressEntity = [[HBReadprogressEntity alloc] init];
            readprogressEntity.book_id = book_id;
            readprogressEntity.progress = progress;
            readprogressEntity.exam_assigned = NO; //先临时设置为NO
            [self.readProgressEntityDic setObject:readprogressEntity forKey:book_id];
        }
    }
    
    NSArray* keys = [self.readProgressEntityDic allKeys];
    NSMutableArray *progressArr = [[NSMutableArray alloc] initWithCapacity:1];
    for(NSString* str in keys)
    {
        [progressArr addObject:[self.readProgressEntityDic objectForKey:str]];
    }
    [[HBReadProgressDB sharedInstance] updateHBReadprogress:progressArr];
    
    [self reloadGrid];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [LEADERSDK setAppKey:KAppKeyStudy];
    
    CGRect rect = self.view.frame;
    UIImageView *navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect), KHBNaviBarHeight)];
    navView.image = [UIImage imageNamed:@"bookshelf-bg-navi"];
    [self.view addSubview:navView];
    
    [self initMainView];
    [self initMainGrid];
    [self initButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    //token失效后再进来需要重新获取数据
//    if ([self.contentEntityArr count] == 0) {
//        //获取所有可选套餐
//        [self requestAllBookset];
//    }

    [self reloadGrid];
}

-(void)getContentDetailEntitys:(NSArray *)booksIDsArr
{
    NSMutableArray *booklist = [[NSMutableArray alloc] initWithCapacity:1];
    for (NSString *bookId in booksIDsArr) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"bookId == %@", bookId];
        BookEntity *bookEntity = (BookEntity*)[CoreDataHelper getFirstObjectWithEntryName:@"BookEntity" withPredicate:predicate];
        if (bookEntity != nil) {
            [booklist addObject:bookEntity];
        }else{
            //获取书本列表
            [self requestContentDetailEntity];
            return ;
        }
    }
    [self.contentDetailEntityDic removeAllObjects];
    [self.contentDetailEntityDic setObject:booklist forKey:[NSString stringWithFormat:@"%ld", (long)currentID]];
    [self reloadGrid];
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

        [self.view addSubview:_gridView];
    }
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
    currentID = [sender.title integerValue];
    
    [self.rightButton setTitle:sender.title forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //获取书本列表
    for (HBContentEntity *contentEntity in self.contentEntityArr) {
        if (contentEntity.bookId == currentID) {
            //根据套餐id返回该套餐对应的books字符串,转换为数组格式,便于操作
            NSArray *booksIDsArr=[contentEntity.books componentsSeparatedByString:@","];
            [self getContentDetailEntitys:booksIDsArr];
        }
    }
}

- (void)initButton
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 20, 44, 44)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"bookshelf-btn-menu"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(ToggleMenuPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 8 - 44, 20, 44, 44)];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"bookshelf-btn-class"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitle:@"1" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.rightButton];
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
    
    NSMutableArray *arr = [self.contentDetailEntityDic objectForKey:[NSString stringWithFormat:@"%ld", (long)currentID]];
    BookEntity *entity = arr[listIndex];
    NSString *bookTitle = entity.bookTitleCN;
    if ([[HBDataSaveManager defaultManager] showEnBookName]) {
        bookTitle = entity.bookTitle;
    }
    NSDictionary * targetData = [[NSDictionary alloc]initWithObjectsAndKeys:
                                 bookTitle, TextGridItemView_BookName,entity.fileId, TextGridItemView_BookCover, @"mainGrid_download", TextGridItemView_downloadState, nil];

    [itemView updateFormData:targetData];
    
    itemView.bookDownloadUrl = entity.bookUrl;
    
    NSString *book_id = [NSString stringWithFormat:@"%@", entity.bookId];
    HBReadprogressEntity *readprogressEntity = [self.readProgressEntityDic objectForKey:book_id];
    NSString *progress = readprogressEntity.progress;
    
    if ([LEADERSDK isBookDownloaded:entity]) {
        [itemView bookDownloaded:entity progress:progress];   //已下载（阅读完成显示“作业”，未完成显示进度条）
    }else if([LEADERSDK isBookDownloading:entity]){
        [itemView bookDownloading:entity];  //正在下载
    }else{
        [itemView bookUnDownload:entity];   //未下载
    }
    
    return itemView;
}

- (void)gridView:(HBGridView *)gridView didSelectGridItemAtIndex:(NSInteger)index
{
    TextGridItemView *itemView = (TextGridItemView *)[gridView gridItemViewAtIndex:index];
//    itemView.backgroundColor = [UIColor grayColor];
    
    NSMutableArray *arr = [self.contentDetailEntityDic objectForKey:[NSString stringWithFormat:@"%ld", (long)currentID]];

    BookEntity *entity = arr[index];
    
    if([LEADERSDK isBookDownloading:entity]){
        //正在下载，不处理
    }else{
        [LEADERSDK bookPressed:entity useNavigation:[AppDelegate delegate].globalNavi];
        itemView.bookDownloadUrl = entity.bookUrl;
    }
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
                [self.contentEntityArr removeAllObjects];
                NSArray *arr = [responseObject objectForKey:@"booksets"];
                for (NSDictionary *dict in arr)
                {
                    HBContentEntity *contentEntity = [[HBContentEntity alloc] initWithDictionary:dict];
                    [self.contentEntityArr addObject:contentEntity];
                }
 
                /** type: 1 - 学生； 10 - 老师*/
                NSInteger type = [[dict objectForKey:@"type"] integerValue];
                if (type == 1) {
                    //获取书本列表
                    for (HBContentEntity *contentEntity in self.contentEntityArr) {
                        if (contentEntity.bookId == currentID) {
                            //根据套餐id返回该套餐对应的books字符串,转换为数组格式,便于操作
                            NSArray *booksIDsArr=[contentEntity.books componentsSeparatedByString:@","];
                            [self getContentDetailEntitys:booksIDsArr];
                        }
                    }
                }else{
                    //老师获取所有可选套餐成功保存数据库
                    [[HBContentListDB sharedInstance] updateHBContentList:arr];
                    //获取书本列表
                    [self requestContentDetailEntity];
                }
            }
        }];
    }
}

-(void)requestContentDetailEntity
{
    //获取书本列表
    for (HBContentEntity *contentEntity in self.contentEntityArr) {
        if (contentEntity.bookId == currentID) {

            [LEADERSDK requestBookInfo:contentEntity.books onComplete:^(NSArray *booklist, NSInteger errorCode, NSString *errorMsg) {
                
                NSMutableArray *booklistTmp = [[NSMutableArray alloc] initWithCapacity:1];
                for (BookEntity *entityTmp in booklist) {
                    [booklistTmp addObject:entityTmp];
                }
                
                //如果缓存中有数据，先不要清空，可能这个时候缓存中的数据保存着正在下载书籍的URL等信息
                if (self.contentDetailEntityDic.count > 0) {
                    NSMutableArray *arr = [self.contentDetailEntityDic objectForKey:[NSString stringWithFormat:@"%ld", currentID]];
                    
                    for (BookEntity *entity in arr) {
                        for (NSInteger index = 0; index < booklistTmp.count; index++) {
                            BookEntity *newEntity = [booklistTmp objectAtIndex:index];
                            if ([entity.fileId isEqualToString:newEntity.fileId]) {
                                [booklistTmp replaceObjectAtIndex:index withObject:entity];
                                break;
                            }
                        }
                    }
                }
                
                [self.contentDetailEntityDic removeAllObjects];
                [self.contentDetailEntityDic setObject:booklistTmp forKey:[NSString stringWithFormat:@"%ld", (long)currentID]];
                
                [self reloadGrid];
            }];
            
            break;
        }
    }
}

-(void)reloadGrid
{
    [_gridView reloadData];
}

@end
