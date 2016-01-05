//
//  HBGradeViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/8/26.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBGradeViewController.h"
#import "HBTitleView.h"
#import "DHSlideMenuController.h"
#import "HBGridView.h"
#import "TextGridItemView.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"
#import "HBContentManager.h"
#import "HBHeaderManager.h"

#import "HBContentEntity.h"
#import "HBReadprogressEntity.h"
#import "HBContentListDB.h"
#import "HBReadProgressDB.h"
#import "FTMenu.h"
#import "Leader21SDKOC.h"
#import "CoreDataHelper.h"
#import "ReadBookViewController.h"
#import "HBTaskEntity.h"
#import "HBMyWorkViewController.h"
#import "LocalSettings.h"
#import "TimeIntervalUtils.h"
#import "HBTestWorkManager.h"
#import "HBPayViewController.h"
#import "HBSystemMsgEntity.h"
#import "HBMsgEntityDB.h"
#import "HBExamIdDB.h"
#import "HBReadStatisticalViewController.h"
#import "HBRankingListViewController.h"
#import "HBTaskStatisticalViewController.h"

#import "AFNetworkReachabilityManager.h"

#define LEADERSDK [Leader21SDKOC sharedInstance]

#define DataSourceCount 10
#define saveReadProgress 0

@interface HBGradeViewController ()<HBGridViewDelegate, reloadGridDelegate>
{
    HBGridView *_gridView;
    NSInteger currentID;
    NSInteger subscribeId;
    NSString *readBookFromTime;
    NSString *readBookToTime;
}

@property (nonatomic, strong)NSMutableArray *contentEntityArr;
@property (nonatomic, strong)NSMutableDictionary *contentDetailEntityDic;
@property (nonatomic, strong)NSMutableDictionary *readProgressEntityDic;
@property (nonatomic, strong)NSMutableArray *taskEntityArr;

@property (nonatomic, strong)UIButton *leftButton;
@property (nonatomic, strong)UIButton *rightButton;
@property (nonatomic, strong)UIImageView *redPointImgView;
@property (nonatomic, strong)UIButton *optionButton;
@property (nonatomic, strong)UIView *backgroundView;

@property (nonatomic, assign)AFNetworkReachabilityStatus networkState;

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
        self.taskEntityArr = [[NSMutableArray alloc] initWithCapacity:1];
        currentID = 1;
        subscribeId = -1;
        readBookFromTime = @"0";
        
        //用户登录成功通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginSuccess) name:kNotification_LoginSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginOut) name:kNotification_LoginOut object:nil];
        
        //暂停全部下载通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseAllDownloadTask) name:kNotification_PauseAllDownload object:nil];
        //用户阅读书籍返回通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReadBookBack:) name:kNotification_ReadBookBack object:nil];
        
        //获取新消息列表成功通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMsgSuccess) name:kNotification_GetMsgSuccess object:nil];
        
        //学生获取作业列表成功通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getExamSuccess) name:kNotification_GetExamSuccess object:nil];
        
        //学生修改订阅等级成功通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSubscribeSuccess) name:kNotification_ChangeSubscribeSuccess object:nil];
        
        //学生购买VIP成功
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payVIPSuccess) name:kNotification_PayVIPSuccess object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pauseAllDownloadTask
{
    [LEADERSDK pauseAllDownloadTask];
}

-(void)getMsgSuccess
{
    //有新消息或者新作业，显示红点，都没有则不显示
    if ([AppDelegate delegate].hasNewMsg || [AppDelegate delegate].hasNewExam) {
        [self.leftButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.redPointImgView.hidden = NO;
    }else{
        [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.redPointImgView.hidden = YES;
    }
}

-(void)getExamSuccess
{
    //有新消息或者新作业，显示红点，都没有则不显示
    if ([AppDelegate delegate].hasNewMsg || [AppDelegate delegate].hasNewExam) {
        [self.leftButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.redPointImgView.hidden = NO;
    }else{
        [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.redPointImgView.hidden = YES;
    }
}

-(void)changeSubscribeSuccess
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    //获取用户当前订阅的套餐
    [[HBServiceManager defaultManager] requestUserBookset:userEntity.name completion:^(id responseObject, NSError *error) {
        if (responseObject) {
            //获取用户当前订阅的套餐成功
            id tmp = [responseObject objectForKey:@"bookset_id"];
            subscribeId = [tmp integerValue];
        }
    }];
}

- (void)payVIPSuccess
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    //重新获取个人资料
    [[HBServiceManager defaultManager] requestUserInfo:userEntity.name completion:^(id responseObject, NSError *error) {
        if (error == nil) {
            [[HBDataSaveManager defaultManager] setUserEntityByDict:responseObject];
        } else {
//            userEntity.account_status = 2;
        }
    }];
}

- (void)LoginSuccess
{
    //右下角功能模块
    [self resetStatisticalBtn];
    
    //用户是否首次登录(NO：首次登录 YES：非首次登录)
    BOOL notFirstLogin = [[HBDataSaveManager defaultManager] notFirstLogin];
    if (notFirstLogin) {
        //非首次登录，有新消息或者新作业显示红点
        [self requestSystemMsg];
    }else{
        //首次登录，不显示红点
    }
    
    [self.readProgressEntityDic removeAllObjects];
#if saveReadProgress
    //登录成功，先从本地读取一下当前用户数据库中保存的全部阅读进度
    self.readProgressEntityDic = [[HBReadProgressDB sharedInstance] getAllReadprogressDic];
#endif
    
    //只有学生有订阅等级，老师没有，初始化为-1
    subscribeId = -1;
    
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        /** type: 1 - 学生； 10 - 老师*/
        if (userEntity.type == 1) {
            [_gridView setHeaderViewHidden:NO];
            //获取用户当前订阅的套餐
            [[HBServiceManager defaultManager] requestUserBookset:userEntity.name completion:^(id responseObject, NSError *error) {
                if (responseObject) {
                    //获取用户当前订阅的套餐成功
                    id tmp = [responseObject objectForKey:@"bookset_id"];
                    subscribeId = [tmp integerValue];
                }
            }];
            //学生获取作业列表
            [self requestTaskListOfStudent];
            //从服务器拉取套餐信息
            [self requestAllBookset];
            //学生用户从服务器拉取最新的书籍阅读进度,老师用户直接从本地读取(本期老师不显示进度)
            NSString *user = userEntity.name;
            [[HBServiceManager defaultManager] requestBookProgress:user bookset_id:currentID completion:^(id responseObject, NSError *error) {
                if (responseObject) {
                    //获取阅读进度成功
                    [self requestBookProgressSuccess:responseObject];
                }
            }];
        } else {
            [_gridView setHeaderViewHidden:YES];
            //老师登录，将学生作业Id数组清空
            [self.taskEntityArr removeAllObjects];
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

- (void)handleLoginSuccess
{
    currentID = 1;
    [self.rightButton setTitle:@"1" forState:UIControlStateNormal];
    [self LoginSuccess];
}

- (void)LoginOut
{
    currentID = 1;
    subscribeId = -1;
    self.redPointImgView.hidden = YES;
    [_gridView setHeaderViewHidden:YES];
    [self.rightButton setTitle:@"1" forState:UIControlStateNormal];
    [self verifyLogin];
}

-(void)ReadBookBack:(NSNotification*)note
{
    //记录一下结束阅读时间
    NSDate *date = [NSDate date];
    readBookToTime = [NSString stringWithFormat:@"%.f",[date timeIntervalSince1970]];
    
    NSMutableDictionary *dic = (NSMutableDictionary *)[note userInfo];
    NSString *bookId = [dic objectForKey:@"book_id"];
    NSString *progress = [dic objectForKey:@"progress"];
    
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if ([progress integerValue] == 100) {
        if (userEntity) {
            /** type: 1 - 学生； 10 - 老师*/
            if (userEntity.type == 1) {
                [self requestTaskListOfStudent];
            }
        }
    }
    
    if (userEntity) {
        NSString *user = userEntity.name;
        
        /** type: 1 - 学生； 10 - 老师*/
        if (userEntity.type == 1) {
            [MBHudUtil showActivityView:nil inView:nil];
            //上报用户读书行为
            [self bookReadingReport:userEntity bookInfoDic:dic];
            //学生上报一本书的阅读进度
            [[HBServiceManager defaultManager] requestUpdateBookProgress:user book_id:[bookId integerValue] progress:[progress integerValue] completion:^(id responseObject, NSError *error) {
                [MBHudUtil hideActivityView:nil];
                NSString *book_id = [NSString stringWithFormat:@"%ld", (long)[responseObject integerForKey:@"book_id"]];
                NSString *progress = [NSString stringWithFormat:@"%ld", (long)[responseObject integerForKey:@"progress"]];
                BOOL exam_assigned = [[responseObject numberForKey:@"exam_assigned"] boolValue];
                
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
                
#if saveReadProgress
                NSMutableArray *progressArr = [[NSMutableArray alloc] initWithCapacity:1];
                [progressArr addObject:readprogressEntity];
                
                [[HBReadProgressDB sharedInstance] updateHBReadprogress:progressArr];
#endif
                
                [self reloadGrid];
            }];
        }else{
#if saveReadProgress
            
#endif
        }
    } else {
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

-(void)bookReadingReport:(HBUserEntity *)userEntity bookInfoDic:(NSMutableDictionary *)dic
{
    NSString *bookId = [dic objectForKey:@"book_id"];
    NSString *toPage = [dic objectForKey:@"toPage"];
    NSString *totalPage = [dic objectForKey:@"totalPage"];
    
    [[HBServiceManager defaultManager] requestReportBookProgress:userEntity.name book_id:[bookId integerValue] bookset_id:currentID from_time:readBookFromTime to_time:readBookToTime from_page:@"1" to_page:toPage total_page:totalPage completion:^(id responseObject, NSError *error) {
        //上报用户读书行为成功！！！
    }];
}

-(void)requestBookProgressSuccess:(id)responseObject
{
    NSArray *arr = [responseObject objectForKey:@"progress"];
    for (NSDictionary *dict in arr)
    {
        NSString *book_id = [NSString stringWithFormat:@"%ld", (long)[[dict objectForKey:@"id"] integerValue]];
        NSString *progress = [NSString stringWithFormat:@"%ld", (long)[[dict objectForKey:@"progress"] integerValue]];
        
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
    
#if saveReadProgress
    NSArray* keys = [self.readProgressEntityDic allKeys];
    NSMutableArray *progressArr = [[NSMutableArray alloc] initWithCapacity:1];
    for(NSString* str in keys)
    {
        [progressArr addObject:[self.readProgressEntityDic objectForKey:str]];
    }
    [[HBReadProgressDB sharedInstance] updateHBReadprogress:progressArr];
#endif
    
    [self reloadGrid];
}

- (HBContentEntity *)createDemoEntity:(NSString *)freeBooks bookid:(NSInteger)bookid
{
    HBContentEntity *contentEntity = [[HBContentEntity alloc] init];
    contentEntity.free_books = freeBooks;
    contentEntity.bookId = bookid;
    return contentEntity;
}

- (void)initDemoData
{
    NSMutableArray *entityArr = [[NSMutableArray alloc] initWithCapacity:2];
    [entityArr addObject:[self createDemoEntity:@"5,6,10,12,16,17" bookid:1]];
    [entityArr addObject:[self createDemoEntity:@"104,105,106,107,108,111,114" bookid:2]];
    [entityArr addObject:[self createDemoEntity:@"164,180,210,212,213,215" bookid:3]];
    [entityArr addObject:[self createDemoEntity:@"326,327,328,330,331,332" bookid:4]];
    [entityArr addObject:[self createDemoEntity:@"419,421,423,424,425,427,437,438" bookid:5]];
    [entityArr addObject:[self createDemoEntity:@"467,491,505,513,529,530,532,533,534" bookid:6]];
    [entityArr addObject:[self createDemoEntity:@"625,627,630,634,641,648" bookid:7]];
    [entityArr addObject:[self createDemoEntity:@"691,692,694,697,705,710,716,722,724" bookid:8]];
    [entityArr addObject:[self createDemoEntity:@"689,709,711,712,834,835" bookid:9]];
    self.contentEntityArr = entityArr;
    
    //未登录体验，先从本地读取一下当前用户数据库中保存的全部阅读进度
    self.readProgressEntityDic = [[HBReadProgressDB sharedInstance] getAllReadprogressDic];
    [[AppDelegate delegate] initDHSlideMenu];
}

- (void)requestDemoBookList
{
    //获取书本列表
    for (HBContentEntity *contentEntity in _contentEntityArr) {
        if (contentEntity.bookId == currentID) {
            [MBHudUtil showActivityView:nil inView:nil];
            [LEADERSDK requestBookInfo:contentEntity.free_books onComplete:^(NSArray *booklist, NSInteger errorCode, NSString *errorMsg) {
                [MBHudUtil hideActivityView:nil];
                NSMutableArray *booklistTmp = [[NSMutableArray alloc] initWithCapacity:1];
                for (BookEntity *entityTmp in booklist) {
                    [booklistTmp addObject:entityTmp];
                }
                
                //如果缓存中有数据，先不要清空，可能这个时候缓存中的数据保存着正在下载书籍的URL等信息
                if (self.contentDetailEntityDic.count > 0) {
                    NSMutableArray *arr = [self.contentDetailEntityDic objectForKey:[NSString stringWithFormat:@"%ld", (long)currentID]];
                    
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
                
                [_contentDetailEntityDic removeAllObjects];
                [_contentDetailEntityDic setObject:booklistTmp forKey:[NSString stringWithFormat:@"%ld", (long)currentID]];
                
                //筛选出free和vip的书籍 1:vip 0:free
                NSMutableDictionary *vipBookDic = [[HBDataSaveManager defaultManager] vipBookDic];
                [vipBookDic removeAllObjects];
                for (BookEntity *bookEntity in booklist) {
                    [vipBookDic setObject:@"0" forKey:bookEntity.bookId];
                }
                
                [self reloadGrid];
            }];
            
            break;
        }
    }
}

- (void)getDemoBookList
{
    for (HBContentEntity *contentEntity in _contentEntityArr) {
        if (contentEntity.bookId == currentID) {
            [self getDemoContentDetailEntitys:contentEntity.free_books];
        }
    }
}

-(void)getDemoContentDetailEntitys:(NSString *)bookIDs
{
    NSMutableArray *booklist = [[NSMutableArray alloc] initWithCapacity:1];
    NSArray *bookIDArr = [bookIDs componentsSeparatedByString:@","];
    //筛选出free和vip的书籍 1:vip 0:free
    NSMutableDictionary *vipBookDic = [[HBDataSaveManager defaultManager] vipBookDic];
    [vipBookDic removeAllObjects];
    for (NSString *bookId in bookIDArr) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"bookId == %@", bookId];
        BookEntity *bookEntity = (BookEntity*)[CoreDataHelper getFirstObjectWithEntryName:@"BookEntity" withPredicate:predicate];
        if (bookEntity != nil) {
            [vipBookDic setObject:@"0" forKey:bookEntity.bookId];
            [booklist addObject:bookEntity];
        }else{
            //获取书本列表
            [self requestDemoBookList];
            return;
        }
    }
    [self.contentDetailEntityDic removeAllObjects];
    [self.contentDetailEntityDic setObject:booklist forKey:[NSString stringWithFormat:@"%ld", (long)currentID]];
    
    [_gridView hideRefreshView];
    [self reloadGrid];
}

- (void)verifyLogin
{
    NSDictionary *dict = [[HBDataSaveManager defaultManager] loadDefaultAccount];
    if (dict) {
        NSString *phone = dict[KWBDefaultUser];
        NSString *pwd = dict[KWBDefaultPwd];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBHudUtil showActivityView:nil inView:nil];
            [[HBServiceManager defaultManager] requestLogin:phone pwd:pwd completion:^(id responseObject, NSError *error) {
                [MBHudUtil hideActivityView:nil];
                if (error.code == 0) {
                    //登录成功
                    [[HBDataSaveManager defaultManager] loadFirstLogin];
                    [[HBDataSaveManager defaultManager] saveFirstLogin];
                    [[HBDataSaveManager defaultManager] loadSettings];
                    
                    [[AppDelegate delegate] initDHSlideMenu];
                    
                    NSString *message = [NSString stringWithFormat:@"用户%@登录成功", phone];
                    [MBHudUtil showTextViewAfter:message];
                    
                    //用户登录成功后发送通知
//                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_LoginSuccess object:nil];
                    [self handleLoginSuccess];
                } else {
                    NSString *message = [NSString stringWithFormat:@"用户%@登录失败", phone];
                    [MBHudUtil showTextViewAfter:message];
                    
                    [self initDemoData];
                    [self getDemoBookList];
                }
            }];
        });
    } else {
        [self initDemoData];
        [self getDemoBookList];
    }
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
    
    [self verifyLogin];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
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
    
    //筛选出free和vip的书籍 1:vip 0:free
    HBContentEntity *contentEntity = [self.contentEntityArr objectAtIndex:currentID - 1];
    NSArray *freeBooksArr = [contentEntity.free_books componentsSeparatedByString:@","];
    NSMutableDictionary *vipBookDic = [[HBDataSaveManager defaultManager] vipBookDic];
    [vipBookDic removeAllObjects];
    for (BookEntity *bookEntity in booklist) {
        if ([freeBooksArr containsObject:[NSString stringWithFormat:@"%@", bookEntity.bookId]]) {
            [vipBookDic setObject:@"0" forKey:bookEntity.bookId];
        }else{
            [vipBookDic setObject:@"1" forKey:bookEntity.bookId];
        }
    }
    
    [_gridView hideRefreshView];
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
        [_gridView setBackgroundView:@"bookshelf-bg-body"];
        
        HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
        if (userEntity) {
            /** type: 1 - 学生； 10 - 老师*/
            if (userEntity.type == 1) {
                [_gridView setHeaderViewHidden:NO];
            }else{
                [_gridView setHeaderViewHidden:YES];
            }
        }
        
        [self.view addSubview:_gridView];
    }
}

-(void)showPullView
{
    NSMutableArray *menuItems = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (HBContentEntity *contentEntity in self.contentEntityArr) {
        NSString * bookIdStr = [NSString stringWithFormat:@"%ld", (long)contentEntity.bookId];
        KxMenuItem *item = [KxMenuItem
                            menuItem:bookIdStr
                            image:nil
                            target:self
                            action:@selector(pushMenuItem:)];
        [menuItems addObject:item];
    }
    
    CGRect menuFrame = CGRectMake(ScreenWidth - 70, 70, 60, 50 * self.contentEntityArr.count);
    
    [FTMenu showMenuWithFrame:menuFrame inView:self.navigationController.view menuItems:menuItems currentID:subscribeId];
}

- (void) pushMenuItem:(KxMenuItem *)sender
{
    currentID = [sender.title integerValue];
    
    [self.rightButton setTitle:sender.title forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity == nil) {
        [self getDemoBookList];
        return;
    }

    //获取书本列表
    for (HBContentEntity *contentEntity in self.contentEntityArr) {
        if (contentEntity.bookId == currentID) {
            //根据套餐id返回该套餐对应的books字符串,转换为数组格式,便于操作
            NSMutableArray *books = (NSMutableArray *)[contentEntity.books componentsSeparatedByString:@","];
            NSArray *assigned_books = [contentEntity.assigned_books componentsSeparatedByString:@","];
            for (NSString * content in assigned_books) {
                [books addObject:content];
            }
            NSSet *set = [NSSet setWithArray:(NSArray *)books];
            
            NSMutableArray *sortArray = [[NSMutableArray alloc] initWithCapacity:1];
            for (NSString * str in set) {
                [sortArray addObject:str];
            }
            
            NSArray *destArr = [sortArray sortedArrayUsingComparator:cmptr];
            
            [self getContentDetailEntitys:destArr];
        }
    }
    
    /** type: 1 - 学生； 10 - 老师*/
    if (userEntity.type == 1) {
        //学生用户从服务器拉取最新的书籍阅读进度,老师用户直接从本地读取(本期老师不显示进度)
        NSString *user = userEntity.name;
        [[HBServiceManager defaultManager] requestBookProgress:user bookset_id:currentID completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                //获取阅读进度成功
                [self requestBookProgressSuccess:responseObject];
            }
        }];
    }
}

- (void)initButton
{
    //左按钮
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 20, 44, 44)];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"bookshelf-btn-menu"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(ToggleMenuPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftButton];
    
    //左按钮上的红点
    self.redPointImgView = [[UIImageView alloc] initWithFrame:CGRectMake(44 - 15, 5, 15, 15)];
    self.redPointImgView.image = [UIImage imageNamed:@"msg_tips_new"];
    self.redPointImgView.hidden = YES;
    [self.leftButton addSubview:self.redPointImgView];
    
    //右按钮
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 8 - 44, 20, 44, 44)];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"bookshelf-btn-class"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitle:@"1" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.rightButton];
}

-(void)resetStatisticalBtn
{
    //右下角调出统计菜单的按钮
    if (!self.optionButton) {
        self.optionButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 50, ScreenHeight - 60, 40, 40)];
        [self.optionButton setBackgroundImage:[UIImage imageNamed:@"pop-btn-menu"] forState:UIControlStateNormal];
        [self.optionButton addTarget:self action:@selector(optionButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.optionButton];
    }
    
    //统计菜单
    if (!self.backgroundView) {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 80)];
        self.backgroundView.backgroundColor = RGBEQA(0, 0.8);
        [self.view addSubview:self.backgroundView];
        
        //统计菜单上的三个按钮
        NSArray *optionTextArr = @[@"阅读统计", @"排行榜", @"作业统计"];
        NSArray *imgViewArr = @[@"pop-icn-reading", @"pop-icn-ranking", @"pop-icn-homework"];
        for (NSInteger index = 0; index < 3; index++) {
            UIButton *statisticalBtn = [[UIButton alloc] initWithFrame:CGRectMake(index * ScreenWidth/3, 0, ScreenWidth/3, 80)];
            
            UIImageView *readingImgView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth/3-40)/2, 5, 40, 40)];
            readingImgView.image = [UIImage imageNamed:[imgViewArr objectAtIndex:index]];
            [statisticalBtn addSubview:readingImgView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth/3, 40)];
            label.text = [optionTextArr objectAtIndex:index];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [statisticalBtn addSubview:label];
            
            UILabel *verticalLine = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/3 + 2, 15, 2, 80 - 15 - 15)];
            verticalLine.backgroundColor = [UIColor colorWithHex:0x484848];
            [statisticalBtn addSubview:verticalLine];
            
            statisticalBtn.tag = index;
            [statisticalBtn addTarget:self action:@selector(statisticalBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.backgroundView addSubview:statisticalBtn];
        }
    }
    
    self.optionButton.frame = CGRectMake(ScreenWidth - 50, ScreenHeight - 60, 40, 40);
    self.backgroundView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 80);
    
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        /** type: 1 - 学生； 10 - 老师*/
        if (userEntity.type == 1) {
            self.optionButton.hidden = YES;
            self.backgroundView.hidden = YES;
        }else{
            self.optionButton.hidden = NO;
            self.backgroundView.hidden = NO;
        }
    }
}

-(void)optionButtonPressed
{
    if (self.backgroundView.frame.origin.y == ScreenHeight) {
        self.optionButton.frame = CGRectMake(ScreenWidth - 50, ScreenHeight - 80 - 50, 40, 40);
        self.backgroundView.frame = CGRectMake(0, ScreenHeight - 80, ScreenWidth, 80);
    }else{
        self.optionButton.frame = CGRectMake(ScreenWidth - 50, ScreenHeight - 60, 40, 40);
        self.backgroundView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 80);
    }
}

-(void)statisticalBtnPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (0 == btn.tag) {
        HBReadStatisticalViewController *controller = [[HBReadStatisticalViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else if(1 == btn.tag){
        HBRankingListViewController *controller = [[HBRankingListViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        HBTaskStatisticalViewController *controller = [[HBTaskStatisticalViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
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
    NSMutableArray *arr = [self.contentDetailEntityDic objectForKey:[NSString stringWithFormat:@"%ld", (long)currentID]];
    if (arr) {
        if ([[HBDataSaveManager defaultManager] userEntity]) {
            return arr.count;
        } else {
            return arr.count+1;
        }
    }
    return 0;
}

// 获取gridview每行显示的grid数
- (NSInteger)columnNumberOfGridView:(HBGridView *)gridView
{
    return 3;
}

// 获取单元格的行数
- (NSInteger)rowNumberOfGridView:(HBGridView *)gridView
{
    NSMutableArray *arr = [self.contentDetailEntityDic objectForKey:[NSString stringWithFormat:@"%ld", (long)currentID]];
    NSInteger count = arr.count;
    if ([[HBDataSaveManager defaultManager] userEntity] == nil) {
        count += 1;
    }
    
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

    NSMutableArray *arr = [self.contentDetailEntityDic objectForKey:[NSString stringWithFormat:@"%ld", (long)currentID]];
    if (listIndex==[arr count]) {
        //默认封皮
        [itemView setDemoImage:@"cover_get_more"];
        return itemView;
    }
    
    BookEntity *entity = arr[listIndex];
    NSString *bookTitle = entity.bookTitleCN;
    if ([[HBDataSaveManager defaultManager] showEnBookName]) {
        bookTitle = entity.bookTitle;
    }
    
    NSMutableDictionary *vipBookDic = [[HBDataSaveManager defaultManager] vipBookDic];
    NSDictionary * targetData = [[NSDictionary alloc]initWithObjectsAndKeys:
                                 bookTitle, TextGridItemView_BookName,entity.fileId, TextGridItemView_BookCover, @"mainGrid_download", TextGridItemView_downloadState, [vipBookDic objectForKey:entity.bookId], TextGridItemView_isVip, nil];
    
    [itemView updateFormData:targetData];
    
    itemView.bookDownloadUrl = entity.bookUrl;
    
    NSString *book_id = [NSString stringWithFormat:@"%@", entity.bookId];
    HBReadprogressEntity *readprogressEntity = [self.readProgressEntityDic objectForKey:book_id];
    NSString *progress = readprogressEntity.progress;
    
    if ([LEADERSDK isBookDownloaded:entity]) {
        HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
        if (userEntity) {
            /** type: 1 - 学生； 10 - 老师*/
            if (userEntity.type == 1) {
                //已下载（阅读完成,并且在作业列表里面，显示“作业”；阅读完成,不在作业列表里面显示“100%”；阅读未完成显示进度条）
                BOOL flag = YES;
                for (HBTaskEntity *taskentity in self.taskEntityArr) {
                    if (taskentity.bookId == [entity.bookId integerValue]) {
                        [itemView bookDownloaded:entity progress:progress isTask:YES];
                        flag = NO;
                        break;
                    }
                }
                if (flag) {
                    [itemView bookDownloaded:entity progress:progress isTask:NO];
                }
            }else{
                [itemView teacherBookDownloaded:entity];
            }
        } else {
            [itemView bookDownloaded:entity progress:progress isTask:NO];
        }
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
    if (index == arr.count) {
        [self showLoginAlert:@"获取更多内容，请登录。"];
        return;
    }
    
    BookEntity *entity = arr[index];
    
    //VIP书籍，需要提示用户
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        /** type: 1 - 学生； 10 - 老师*/
        if (userEntity.type == 1) {
            NSMutableDictionary *vipBookDic = [[HBDataSaveManager defaultManager] vipBookDic];
            if ([[vipBookDic objectForKey:entity.bookId] isEqualToString:@"1"]) {
                if (userEntity.account_status == 1) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你尚未开通VIP，无权下载阅读此书，请开通VIP后再试。" delegate:self cancelButtonTitle:@"再等等" otherButtonTitles:@"现在激活", nil];
                    alertView.tag = 0;
                    
                    [alertView show];
                    
                    return;
                } else if (userEntity.account_status == 3){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的VIP已过期，无权下载阅读此书，请重新激活后再试。" delegate:self cancelButtonTitle:@"再等等" otherButtonTitles:@"现在激活", nil];
                    alertView.tag = 0;
                    
                    [alertView show];
                    
                    return;
                }
            }
        }
    }
    
    if (itemView.isTest && [LEADERSDK isBookDownloading:entity]==NO) {
        //跳转作业逻辑
        [self jumpToTestWork:[entity.bookId integerValue]];
    } else {
        //记录一下开始阅读时间
        NSDate *date = [NSDate date];
        readBookFromTime = [NSString stringWithFormat:@"%.f",[date timeIntervalSince1970]];
        
        BOOL isDownloaded = [LEADERSDK bookPressed:entity useNavigation:[AppDelegate delegate].globalNavi];
        if (isDownloaded == NO) {
            [self handleDownload:entity];
        }
        itemView.bookDownloadUrl = entity.bookUrl;
    }
}

- (void)handleDownload:(BookEntity *)entity
{
    BOOL wifiDownload = [[HBDataSaveManager defaultManager] wifiDownload];
    if (_networkState == AFNetworkReachabilityStatusReachableViaWiFi) {
        [LEADERSDK startDownloadBook:entity];
//        [LEADERSDK unzipBookByPath:nil entity:entity block:^(NSString *bookDir) {
//            [LEADERSDK readBook:entity folder:nil useNavigation:self.navigationController];
//        }];
    } else {
        if (wifiDownload) {
            //提示非wifi
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"WiFi设置" message:@"已开启仅用WiFi下载，请连接WiFi网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            alertView.tag = 1;
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
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            HBPayViewController *controller = [[HBPayViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [self jumpToSetting];
        }
    } else if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            [Navigator pushLoginControllerNow];
        }
    }
}

- (void)jumpToSetting
{
    //开启设置wifi页面
    if (SYSTEM_VERSION >= 9.0) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
    }
}

#pragma mark --跳转作业逻辑--

- (void)jumpToTestWork:(NSInteger)bookId
{
    HBTaskEntity *taskEntity = nil;
    for (taskEntity in _taskEntityArr) {
        if (taskEntity.bookId == bookId) {
            break;
        }
    }
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        NSString *user = userEntity.name;
        [MBHudUtil showActivityView:nil inView:nil];
        [[HBServiceManager defaultManager] requestBookInfo:user book_id:bookId completion:^(id responseObject, NSError *error) {
            // to do ...
            if (responseObject) {
                NSDictionary *dict = responseObject;
                if (dict == nil) {
                    [MBHudUtil hideActivityView:nil];
                    [MBHudUtil showTextViewAfter:@"服务器资源缺失，敬请期待"];
                } else {
                    NSString *url = dict[@"url"];
                    [self downloadTestWork:url onSelect:taskEntity];
                }
            }
        }];
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
            HBTestWorkManager *workManager = [[HBTestWorkManager alloc] init];
            [workManager parseTestWork:path];
            HBMyWorkViewController *controller = [[HBMyWorkViewController alloc] init];
            controller.workManager = workManager;
            controller.taskEntity = taskEntity;
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            [MBHudUtil showTextViewAfter:@"服务器资源缺失，敬请期待"];
        }
    }];
}

-(void)refreshTableHeaderDidTriggerRefresh
{
    //下拉加载 加载数据 (从服务器拉取套餐信息）
    //    [self requestAllBookset];
    
    [self LoginSuccess];
}

- (void)requestAllBookset
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        NSString *user = userEntity.name;
        //获取所有可选套餐
        [[HBServiceManager defaultManager] requestAllBookset:user completion:^(id responseObject, NSError *error) {
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
                if (userEntity.type == 1) {
                    //获取书本列表
                    for (HBContentEntity *contentEntity in self.contentEntityArr) {
                        if (contentEntity.bookId == currentID) {
                            //根据套餐id返回该套餐对应的books字符串,转换为数组格式,便于操作
                            NSMutableArray *books = (NSMutableArray *)[contentEntity.books componentsSeparatedByString:@","];
                            NSArray *assigned_books = [contentEntity.assigned_books componentsSeparatedByString:@","];
                            for (NSString * content in assigned_books) {
                                [books addObject:content];
                            }
                            NSSet *set = [NSSet setWithArray:(NSArray *)books];
                            
                            NSMutableArray *sortArray = [[NSMutableArray alloc] initWithCapacity:1];
                            for (NSString * str in set) {
                                [sortArray addObject:str];
                            }
                            
                            NSArray *destArr = [sortArray sortedArrayUsingComparator:cmptr];
                            
                            [self getContentDetailEntitys:destArr];
                        }
                    }
                } else {
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
            
            NSMutableArray *books = (NSMutableArray *)[contentEntity.books componentsSeparatedByString:@","];
            NSArray *assigned_books = [contentEntity.assigned_books componentsSeparatedByString:@","];
            for (NSString * content in assigned_books) {
                [books addObject:content];
            }
            NSSet *set = [NSSet setWithArray:(NSArray *)books];
            
            NSMutableArray *sortArray = [[NSMutableArray alloc] initWithCapacity:1];
            for (NSString * str in set) {
                [sortArray addObject:str];
            }
            
            NSArray *destArr = [sortArray sortedArrayUsingComparator:cmptr];
            
            NSString *destBooksStr = [destArr componentsJoinedByString:@","];
            
            [LEADERSDK requestBookInfo:destBooksStr onComplete:^(NSArray *booklist, NSInteger errorCode, NSString *errorMsg) {
                
                NSMutableArray *booklistTmp = [[NSMutableArray alloc] initWithCapacity:1];
                for (BookEntity *entityTmp in booklist) {
                    [booklistTmp addObject:entityTmp];
                }
                
                //如果缓存中有数据，先不要清空，可能这个时候缓存中的数据保存着正在下载书籍的URL等信息
                if (self.contentDetailEntityDic.count > 0) {
                    NSMutableArray *arr = [self.contentDetailEntityDic objectForKey:[NSString stringWithFormat:@"%ld", (long)currentID]];
                    
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
                
                //筛选出free和vip的书籍 1:vip 0:free
                HBContentEntity *contentEntity = [self.contentEntityArr objectAtIndex:currentID - 1];
                NSArray *freeBooksArr = [contentEntity.free_books componentsSeparatedByString:@","];
                NSMutableDictionary *vipBookDic = [[HBDataSaveManager defaultManager] vipBookDic];
                [vipBookDic removeAllObjects];
                for (BookEntity *bookEntity in booklist) {
                    if ([freeBooksArr containsObject:[NSString stringWithFormat:@"%@", bookEntity.bookId]]) {
                        [vipBookDic setObject:@"0" forKey:bookEntity.bookId];
                    }else{
                        [vipBookDic setObject:@"1" forKey:bookEntity.bookId];
                    }
                }
                
                [_gridView hideRefreshView];
                [self reloadGrid];
            }];
            
            break;
        }
    }
}

-(void)reloadGridView
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        /** type: 1 - 学生； 10 - 老师*/
        if (userEntity.type == 1) {
            [self requestTaskListOfStudent];
        }
    }
    [self reloadGrid];
}

-(void)reloadGrid
{
    [_gridView reloadData];
}

-(void)requestTaskListOfStudent
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        NSString *user = userEntity.name;
        [[HBServiceManager defaultManager] requestTaskListOfStudent:user from:0 count:100 completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                //学生获取作业列表成功
                [self.taskEntityArr removeAllObjects];
                NSArray *arr = [responseObject objectForKey:@"exams"];
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
                }
                
                [self reloadGrid];
                
                //用户是否首次登录(NO：首次登录 YES：非首次登录)
                BOOL notFirstLogin = [[HBDataSaveManager defaultManager] notFirstLogin];
                if (notFirstLogin) {    //非首次登录，有新消息或者新作业显示红点
                    //从数据库获取所有作业ID
                    NSMutableArray *examIdArr = [[HBExamIdDB sharedInstance] getAllExamId];
                    NSString *localMaxExamId = @"";
                    NSString *newMaxExamId = @"";
                    
                    if (examIdArr.count > 0) {
                        NSArray *destArr = [examIdArr sortedArrayUsingComparator:cmptr];
                        localMaxExamId = [destArr objectAtIndex:destArr.count - 1];
                    }
                    
                    if (self.taskEntityArr.count > 0) {
                        HBTaskEntity *taskEntity = [self.taskEntityArr objectAtIndex:0];
                        newMaxExamId = [NSString stringWithFormat:@"%ld", (long)taskEntity.exam_id];
                    }
                    
                    //如果新的作业ID值大于数据库中保存的最大作业ID值，则说明有新作业，需要显示红点
                    if ([newMaxExamId integerValue] > [localMaxExamId integerValue]) {
                        [AppDelegate delegate].hasNewExam = YES;
                    }else{
                        [AppDelegate delegate].hasNewExam = NO;
                    }
                    
                    //学生获取作业列表成功后发送通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_GetExamSuccess object:nil];
                }else{
                    //首次登录，不显示红点
                }
            }
        }];
    }
}

-(void)requestSystemMsg
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    //1433248966 是临时用来测试的时间，后续需要改成正式的！
    [[HBServiceManager defaultManager] requestSystemMsg:userEntity.name from_time:@"1433248966" completion:^(id responseObject, NSError *error) {
        if (responseObject) {
            
            //从数据库读取本地所有消息内容
            NSMutableArray *localMsgArr = [[HBMsgEntityDB sharedInstance] getAllMsgEntity];
            NSString *localMaxMsgId = @"";
            NSString *newMaxMsgId = @"";
            if (localMsgArr.count > 0) {
                HBSystemMsgEntity *msgEntity = [localMsgArr objectAtIndex:0];
                localMaxMsgId = msgEntity.systemMsgId;
            }
            
            NSArray *array = [responseObject arrayForKey:@"messages"];
            for (NSDictionary *dic in array)
            {
                newMaxMsgId = [NSString stringWithFormat:@"%ld", (long)[dic integerForKey:@"id"]];
                break;
            }
            
            //如果新的消息ID值大于数据库中保存的最大消息ID值，则说明有新消息，需要显示红点
            if ([newMaxMsgId integerValue] > [localMaxMsgId integerValue]) {
                [AppDelegate delegate].hasNewMsg = YES;
            }else{
                [AppDelegate delegate].hasNewMsg = NO;
            }
            
            //获取新消息列表成功后发送通知
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_GetMsgSuccess object:nil];
        }
    }];
}

#pragma mark --network


-(void)addObserverNet
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - 更新网络
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


NSComparator cmptr = ^(id obj1, id obj2){
    if ([obj1 integerValue] > [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    
    if ([obj1 integerValue] < [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
};

@end
