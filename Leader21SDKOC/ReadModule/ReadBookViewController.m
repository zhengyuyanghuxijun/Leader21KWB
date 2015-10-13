//
//  ReadBookViewController.m
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-11.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookViewController.h"
#import "ReadBookDataSource.h"
#import "ReadBookContentViewController.h"
#import "DataEngine.h"
#import "ReadBookSwitchModel.h"
#import "ReadBookOCController.h"
#import "ReadBookPRController.h"

#import "BookEntity.h"


#define ANIMATION_TIME (0.2f)

#define READ_BOOK_TOOLBAR_HEIGHT  ([DE isPad]?64:44)

#define kNotification_ReadBookBack       @"kNotification_ReadBookBack"

@interface ReadBookViewController ()<UIGestureRecognizerDelegate, BasePageViewControllerDelegate>

@property (nonatomic, strong, readwrite) BasePageViewController *pageViewController;
@property (nonatomic, strong) ReadBookDataSource *readBookDataSource;
@property (nonatomic, assign) ReadType readType;
@property (nonatomic, assign) ReadType preReadType;

@property (nonatomic, copy) NSString *bookIndexName;
@property (nonatomic, assign) CGRect orignalFrame;
@property (nonatomic, strong) NSTimer *toolbarTimer;
@property (nonatomic, strong) NSDate* startTime;

- (void)setReadModel:(ReadType)readType;

@end

@implementation ReadBookViewController

- (void)dealloc
{
    NSInteger index = [self currentIndex];
    NSInteger count = [self.readBookDataSource totalCount];
    if (index > 0 && count > 0) {
        NSInteger progress = 100*index/count;
        if (index + 1 >= count) {
            progress = 100;
        }
        if (progress < 0 || progress > 100) {
            progress = 0;
        }
        // 计算阅阅读时间
//        NSString* readTime = [DE getReadHourFrom:self.startTime];
//        if ([DE islogin]) {
//            [[DataEngine sharedInstance] updateBookProgress:self.bookID
//                                                   progress:progress
//                                                  readHours:readTime
//                                                 onComplete:nil];
//        }
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"bookId == %lld", self.bookID];
        BookEntity* book = (BookEntity*)[CoreDataHelper getFirstObjectWithEntryName:@"BookEntity" withPredicate:predicate];
        if (book != nil) {
//            if (book.readProgress.integerValue < progress) {
//                book.readProgress = @(progress);
//                
//                if (book.forList1 != nil) {
//                    book.forList1.sortId = book.forList1.sortId;
//                }
//                else if (book.forList2 != nil) {
//                    book.forList2.sortId = book.forList2.sortId;
//                }
//                else if (book.forList3 != nil) {
//                    book.forList3.sortId = book.forList3.sortId;
//                }
//                else if (book.forList4 != nil) {
//                    book.forList4.sortId = book.forList4.sortId;
//                }
//                
//            }
        }
        
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(OCModelFinish:)
                                                     name:@"OCModelFinish"
                                                   object:nil];
        self.startTime = [NSDate date];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bgImageView.hidden = NO;
    
    self.orignalFrame = self.view.frame;
    
    //    NSArray *bookNameArr = [self.folderName componentsSeparatedByString:@"/"];
    
    //    self.bookIndexName = [bookNameArr lastObject];
    self.bookIndexName = self.folderName;
    
    __weak ReadBookViewController *wSelf = self;
    
    self.rotateButton = [[ReadBookOrientationButton alloc] initOriButton];
    self.rotateButton.origin = CGPointMake(self.view.width - 50, 5);
    if ([[UIDevice currentDevice] systemVersionNotLowerThan:@"7.0"]) {
        self.rotateButton.top = self.rotateButton.top + 64;
    }
    [self.rotateButton addTarget:self action:@selector(rotateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rotateButton];
    
    
    
    self.readBookToolBar = [[ReadBookToolBar alloc] initWithFrame:CGRectMake(0, self.view.bottom - READ_BOOK_TOOLBAR_HEIGHT, self.view.width, READ_BOOK_TOOLBAR_HEIGHT)];
    [self.readBookToolBar enableAutoPlay:[[ReadBookSwitchModel sharedInstance] isAutoPlayEnable]];
    self.readBookToolBar.toolButtonClickBlock = ^(ButtonType buttonType){
        [wSelf toolButtonClickBlockFunction:buttonType];
    };
    [self.view addSubview:self.readBookToolBar];
    
    [self setReadModel:READ_NORMAL_MODEL];
}

- (void)toolButtonClickBlockFunction:(ButtonType)buttonType
{
    [self.toolbarTimer invalidate];
    self.toolbarTimer = [NSTimer timerWithTimeInterval:3.0f
                                                target:self
                                              selector:@selector(hideToolBar)
                                              userInfo:nil
                                               repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.toolbarTimer forMode:NSRunLoopCommonModes];
    
    
    switch (buttonType) {
        case PRE_PAGE_BUTTON:
            [self jumpPrePage];
            break;
        case NEXT_PAGE_BUTTON:
            [self jumpNextPage];
            break;
        case OC_MODEL_BUTTON:
            [self OCModelPlay];
            break;
        case PR_MODEL_BUTTON:
            [self PRModelPlay];
            break;
        case AUTO_PLAY_BUTTON:
            [self autoPlay];
            break;
            
        default:
            break;
    }
}

- (NSInteger)currentIndex
{
    ReadBookContentViewController *readBookContentVC = nil;
    
    if ([[self pageViewController] viewControllers].count > 0) {
        if (self.readType == READ_NORMAL_MODEL) {
            readBookContentVC = [self.pageViewController.viewControllers objectAtIndex:0];
        }
        else
        {
            if ([[self pageViewController] viewControllers].count > 0) {
                if ([[self pageViewController] viewControllers].count <= 1) {
                    readBookContentVC = [self.pageViewController.viewControllers objectAtIndex:0];
                }
                else
                {
                    readBookContentVC = [self.pageViewController.viewControllers objectAtIndex:1];
                }
            }
        }
    }
    if (readBookContentVC) {
        return [self.readBookDataSource indexOfViewController:readBookContentVC];
    }
    else
    {
        return -1;
    }
}

- (void)jumpPrePage
{
    if (self.readType == READ_NORMAL_MODEL) {
        NSInteger curIdx = [self currentIndex];
        NSInteger preIdx = curIdx - 1;
        if (preIdx >= 0) {
            [self setSinglePage:preIdx direction:UIPageViewControllerNavigationDirectionReverse];
        }
        else
        {
            if (curIdx == 0) {
                return;
            }
            [self setSinglePage:0 direction:UIPageViewControllerNavigationDirectionReverse];
        }
    }
    else
    {
        NSInteger curIdx = [self currentIndex];
        NSInteger preIdx = curIdx - 2;
        
        if (self.readType == READ_PR_MODEL) {
            preIdx = [self getPreAvailPrPage:preIdx];
            if (preIdx==-1) {
                return;
            }
        }
        
        if (preIdx >= 1) {
            [self setSplitPage:preIdx direction:UIPageViewControllerNavigationDirectionReverse];
        }
        else
        {
            if (curIdx == 1) {
                return;
            }
            [self setSplitPage:1 direction:UIPageViewControllerNavigationDirectionReverse];
        }
    }
}

- (void)jumpNextPage
{
    if (self.readType == READ_NORMAL_MODEL) {
        NSInteger curIdx = [self currentIndex];
        if (curIdx >= 0) {
            NSInteger nextIdx = ++curIdx;
            [self setSinglePage:nextIdx direction:UIPageViewControllerNavigationDirectionForward];
        }
    }
    else
    {
        NSInteger curIdx = [self currentIndex];
        NSInteger nextIdx = curIdx + 2;
        
        if (self.readType == READ_PR_MODEL) {
            nextIdx = [self getNextAvailPrPage:nextIdx];
            if (nextIdx==-1) {
                return;
            }
        }
        
        if(nextIdx <= [self.readBookDataSource totalCount]) {
            [self setSplitPage:nextIdx direction:UIPageViewControllerNavigationDirectionForward];
        }
    }
}

- (NSInteger)getPreAvailPrPage:(NSInteger)page
{
    for (int index = page;index>0; index-=2) {
        
        NSArray *readBookContentVCArray = [(ReadBookSplitModelSource *)self.readBookDataSource viewControllersCoupleAtIndex:index];
        ReadBookContentViewController *readBookContentViewController = [readBookContentVCArray lastObject];
        
        if ([self.readBookDataSource.resourceModel isPagePRModelEnable:readBookContentViewController.contentImageName]) {
            return index;
        }
        
    }
    
    return -1;
}

- (NSInteger)getNextAvailPrPage:(NSInteger)page
{
    for (int index = page;index<[self.readBookDataSource totalCount]-1; index+=2) {
        
        NSArray *readBookContentVCArray = [(ReadBookSplitModelSource *)self.readBookDataSource viewControllersCoupleAtIndex:index];
        ReadBookContentViewController *readBookContentViewController = [readBookContentVCArray lastObject];
        
        if ([self.readBookDataSource.resourceModel isPagePRModelEnable:readBookContentViewController.contentImageName]) {
            return index;
        }
        
    }
    
    return -1;
}

- (void)autoPlay
{
    BOOL isAutoPlayEnable = [[ReadBookSwitchModel sharedInstance] isAutoPlayEnable];
    [[ReadBookSwitchModel sharedInstance] setAutoPlayEnable:!isAutoPlayEnable];
    [self.readBookToolBar enableAutoPlay:!isAutoPlayEnable];
    
    for (ReadBookContentViewController *vc in self.pageViewController.viewControllers) {
        [vc reloadPageData];
    }
}

- (void)insertFakeBG
{
    UIImage* bgImage = [UIImage resizebleImageNamed:@"bg.png"];
    UIImageView * abgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.height, self.view.width)];
    abgImageView.image = bgImage;
    abgImageView.tag = 1024;
    [self.view addSubview:abgImageView];
    
}

- (void)OCModelPlay
{
    [UIView animateWithDuration:ANIMATION_TIME
                     animations:^{
                         [self.view setTransform: CGAffineTransformMakeRotation(M_PI / 2)];
                         [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                         self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height);
                         
                         [self insertFakeBG];
                         
                         [self setReadModel:READ_OC_MODEL isFirstTime:NO];
                     }];
}

- (void)PRModelPlay
{
    [UIView animateWithDuration:ANIMATION_TIME
                     animations:^{
                         [self.view setTransform: CGAffineTransformMakeRotation(M_PI / 2)];
                         [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                         self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height);
                         
                         [self insertFakeBG];
                         
                         [self setReadModel:READ_PR_MODEL isFirstTime:NO];
                     }];
}

- (void)rotateButtonPressed:(id)sender
{
    if (self.readType == READ_NORMAL_MODEL) {
        [UIView animateWithDuration:ANIMATION_TIME
                         animations:^{
                             [self.view setTransform: CGAffineTransformMakeRotation(M_PI / 2)];
                             [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                             self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height);
                             
                             [self insertFakeBG];
                             
                             [self setReadModel:READ_SPLIT_MODEL isFirstTime:NO];
                         }];
    }
    else if((self.readType == READ_OC_MODEL  || self.readType == READ_PR_MODEL) && self.preReadType != READ_NORMAL_MODEL)
    {
        [self setReadModel:READ_SPLIT_MODEL isFirstTime:NO];
        
    }else
    {
        [UIView animateWithDuration:ANIMATION_TIME
                         animations:^{
                             [self.view setTransform: CGAffineTransformMakeRotation(0)];
                             [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                             self.view.frame = self.orignalFrame;
                             
                             for (UIView *subv in [self view].subviews) {
                                 if (subv.tag == 1024) {
                                     [subv removeFromSuperview];
                                 }
                             }
                             
                             [self setReadModel:READ_NORMAL_MODEL isFirstTime:NO];
                         }];
    }
}

- (void)setReadModel:(ReadType)readType
{
    [self setReadModel:readType isFirstTime:YES];
}

- (void)setReadModel:(ReadType)readType isFirstTime:(BOOL)isFirstTime
{
    self.preReadType = self.readType;
    self.readType = readType;
    
    __weak ReadBookViewController *wSelf = self;
    
    [self.readBookDataSource ocModelEnd];
    [self.readBookDataSource prModelEnd];
    
    if (self.toolbarTimer) {
        [self.toolbarTimer invalidate];
        self.toolbarTimer = nil;
    }
    
    if (readType == READ_NORMAL_MODEL) {
        [self.rotateButton setOriType:ORI_LANDSCAPE];
        [self.readBookToolBar setFrame:CGRectMake(0, self.view.bottom - READ_BOOK_TOOLBAR_HEIGHT, self.view.width, READ_BOOK_TOOLBAR_HEIGHT)];
        self.rotateButton.right = self.view.width - 10;
        
        self.rotateButton.top = 5;
        if ([[UIDevice currentDevice] systemVersionNotLowerThan:@"7.0"]) {
            self.rotateButton.top = self.rotateButton.top + 64;
        }
        
        [self.readBookToolBar setToolBarType:BAR_TYPE_NORMAL];
    }
    else
    {
        [self.rotateButton setOriType:ORI_PORTRAIT];
        [self.readBookToolBar setFrame:CGRectMake(0, self.view.width - READ_BOOK_TOOLBAR_HEIGHT, self.view.height, READ_BOOK_TOOLBAR_HEIGHT)];
        self.rotateButton.right = self.view.height - 10;
        
        self.rotateButton.top = 5;
        
        if (readType == READ_PR_MODEL) {
            [self.readBookToolBar setToolBarType:BAR_TYPE_PR];
        }
        else if(readType == READ_SPLIT_MODEL)
        {
            self.toolbarTimer = [NSTimer timerWithTimeInterval:3.0f
                                                        target:self
                                                      selector:@selector(hideToolBar)
                                                      userInfo:nil
                                                       repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.toolbarTimer forMode:NSRunLoopCommonModes];
            [self.toolbarTimer fire];
            [self.readBookToolBar setToolBarType:BAR_TYPE_SPLIT];
        }
        else if(readType == READ_OC_MODEL)
        {
            [self.readBookToolBar setToolBarType:BAR_TYPE_NORMAL];
        }
    }
    
    if (readType == READ_NORMAL_MODEL)
    {
        NSInteger curIdx = [self currentIndex];
        self.readBookToolBar.alpha = 1;
        self.pageViewController = [[BasePageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                  options:nil];
        self.pageViewController.delegate = self;
        
        CGFloat showHeight = self.view.height - 64 - READ_BOOK_TOOLBAR_HEIGHT;
        
        if ((self.view.width/showHeight)>(993.f/1200.f)) {//width larger
            CGFloat moveOzi = (self.view.width - showHeight*(993.f/1200.f))/2;
            [self.pageViewController.view setFrame:CGRectMake(0+moveOzi, 64 , showHeight*(993.f/1200.f), showHeight)];
        }else{
            CGFloat moveOzi = (showHeight - self.view.width/(993.f/1200.f))/2;
            [self.pageViewController.view setFrame:CGRectMake(0, 64 + moveOzi, self.view.width, self.view.width/((993.f/1200.f)))];
        }
        
        
        self.readBookDataSource = [[ReadBookNormalModelSource alloc] initWithIndexName:self.bookIndexName
                                                                            readBookVC:self];
        
        self.pageViewController.dataSource = self.readBookDataSource;
        
        if (isFirstTime) {
            [self setSinglePage:0 direction:UIPageViewControllerNavigationDirectionForward];
        }
        else
        {
            if ([[self readBookDataSource].orignalResourceImageArr containsObject:@"blank"]) {
                curIdx -= 1;
                if(curIdx < 0){
                    curIdx = 0;
                }
            }
            [self setSinglePage:curIdx direction:UIPageViewControllerNavigationDirectionForward];
        }
        
        [self.readBookToolBar setFrame:CGRectMake(0, self.view.bottom - READ_BOOK_TOOLBAR_HEIGHT, self.view.width, READ_BOOK_TOOLBAR_HEIGHT)];
        self.rotateButton.right = self.view.width - 10;
    }
    else
    {
        NSInteger curIdx = [self currentIndex];
        
        if (self.preReadType == READ_SPLIT_MODEL||self.preReadType == READ_OC_MODEL || self.preReadType == READ_PR_MODEL) {
            curIdx -=1;
        }
        
        NSDictionary * options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMid] forKey:UIPageViewControllerOptionSpineLocationKey];
        self.pageViewController = [[BasePageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                  options:options];
        
        self.pageViewController.delegate = self;
        
        if (readType == READ_OC_MODEL || readType == READ_PR_MODEL)
        {
            self.readBookToolBar.alpha = 0;
            [self.rotateButton setOriType:FNC_EXIT];

        }
        else
        {
            self.readBookToolBar.alpha = 1;
            self.pageViewController.aDelegate = self;
        }
        
        if (self.view.width/self.view.height<1200.f/(993.f*2)) {
            [self.pageViewController.view setFrame:CGRectMake((self.view.height - self.view.width*(1/0.604f))/2, 0, self.view.width*(1/0.604), self.view.width)];
        }else{
            [self.pageViewController.view setFrame:CGRectMake(0, (self.view.width - self.view.height*0.604f)/2, self.view.height, self.view.height*0.604f)];
        }
        
        //[self.pageViewController.view setFrame:CGRectMake(0, 0, self.view.height, self.view.width)];
        
        self.readBookDataSource = [[ReadBookSplitModelSource alloc] initWithIndexName:self.bookIndexName
                                                                           readBookVC:self];
        ((ReadBookSplitModelSource *)self.readBookDataSource).readType = readType;
        self.pageViewController.dataSource = self.readBookDataSource;
        
        if (isFirstTime) {
            [self setSplitPage:1 direction:UIPageViewControllerNavigationDirectionForward];
        }
        else
        {
            if ([[self readBookDataSource].orignalResourceImageArr containsObject:@"blank"]) {
                curIdx += 1;
            }
            
            if (curIdx%2 == 0) {
                
//                if((curIdx + 1)>[self.readBookDataSource totalCount])
//                {
//                    curIdx = [self.readBookDataSource totalCount]-2;
//                }
                
                [self setSplitPage:curIdx + 1 direction:UIPageViewControllerNavigationDirectionForward];
            }
            else
            {
                [self setSplitPage:curIdx direction:UIPageViewControllerNavigationDirectionForward];
            }
        }
        [self.readBookToolBar setFrame:CGRectMake(0, self.view.width - READ_BOOK_TOOLBAR_HEIGHT, self.view.height, READ_BOOK_TOOLBAR_HEIGHT)];
        self.rotateButton.right = self.view.height - 10;
    }
    
    self.readBookDataSource.readBookDataSourcePageChangeBlock = ^(NSInteger curIdx, BOOL ocModelEnable, BOOL prModelEnable){
        [wSelf setToolBarStatus:curIdx
                  ocModelEnable:ocModelEnable
                  prModelEnable:prModelEnable];
    };
    
    
    
    for (UIView *subv in [self view].subviews) {
        if (subv && [subv isKindOfClass:[self.pageViewController.view class]]) {
            [subv removeFromSuperview];
        }
    }
    [self.view addSubview:self.pageViewController.view];
    [self.view bringSubviewToFront:self.readBookToolBar];
    [self.view bringSubviewToFront:self.rotateButton];
    
    if (readType == READ_PR_MODEL) {
        [self.readBookDataSource prModelStart];
    }
    else if(readType == READ_OC_MODEL)
    {
        [self.readBookDataSource ocModelStart];
    }
}

- (void)OCModelFinish:(id)sender
{
    if (self.preReadType == READ_SPLIT_MODEL) {
        [self setReadModel:READ_SPLIT_MODEL isFirstTime:NO];
    }else
    {
        [self rotateButtonPressed:nil];
    }

}

- (void)setToolBarStatus:(NSInteger)curIdx ocModelEnable:(BOOL)ocModelEnable prModelEnable:(BOOL)prModelEnable
{
    [self.readBookToolBar setCurrentIndex:curIdx];
    [self.readBookToolBar enableOCModel:ocModelEnable];
    if (self.readType == READ_NORMAL_MODEL) {
        if (curIdx == 0) {
            [self.readBookToolBar enablePRModel:YES];
        }
        else
        {
            [self.readBookToolBar enablePRModel:prModelEnable];
        }
    }
    else if(self.readType == READ_SPLIT_MODEL)
    {
        if (curIdx == 0 || curIdx == 1) {
            [self.readBookToolBar enablePRModel:YES];
        }
        else
        {
            [self.readBookToolBar enablePRModel:prModelEnable];
        }
    }
    
}

- (void)setSinglePage:(NSInteger)index direction:(UIPageViewControllerNavigationDirection)direction
{
    ReadBookContentViewController *readBookContentViewController = [self.readBookDataSource viewControllerAtIndex:index];
    if (readBookContentViewController) {
        [self.pageViewController setViewControllers:@[readBookContentViewController]
                                          direction:direction
                                           animated:YES
                                         completion:nil];
        BOOL isOCModelEnable = [self.readBookDataSource.resourceModel isPageOCModelEnable:readBookContentViewController.contentImageName];
        BOOL isPRModelEnable = [self.readBookDataSource.resourceModel isPagePRModelEnable:readBookContentViewController.contentImageName] && (index==0);//调整为仅在第一页时可用
        [self setToolBarStatus:index ocModelEnable:isOCModelEnable prModelEnable:isPRModelEnable];
    }
}

- (void)setSplitPage:(NSInteger)index direction:(UIPageViewControllerNavigationDirection)direction
{
    NSArray *readBookContentVCArray = [(ReadBookSplitModelSource *)self.readBookDataSource viewControllersCoupleAtIndex:index];
    if (readBookContentVCArray) {
        [self.pageViewController setViewControllers:readBookContentVCArray
                                          direction:direction
                                           animated:YES
                                         completion:nil];
        ReadBookContentViewController *readBookContentViewController = [readBookContentVCArray lastObject];
        BOOL isOCModelEnable = [self.readBookDataSource.resourceModel isPageOCModelEnable:readBookContentViewController.contentImageName];
        BOOL isPRModelEnable = [self.readBookDataSource.resourceModel isPagePRModelEnable:readBookContentViewController.contentImageName]&&(index==0);//调整为仅在第一页时可用;
        [self setToolBarStatus:index ocModelEnable:isOCModelEnable prModelEnable:isPRModelEnable];
    }
}

- (void)pageViewControllerTap:(CGPoint)touchPoint
{
    if (self.readType == READ_SPLIT_MODEL) {
        
        if ([DE isPad]) {
            if (touchPoint.x < 120 || touchPoint.x > 904)
                return;
        }else
        {
            if (touchPoint.x < 60 || touchPoint.x > 508)
                return;
        }
        
        
        [self.toolbarTimer invalidate];
        self.toolbarTimer = [NSTimer timerWithTimeInterval:3.0f
                                                    target:self
                                                  selector:@selector(hideToolBar)
                                                  userInfo:nil
                                                   repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.toolbarTimer forMode:NSRunLoopCommonModes];
        
        [UIView animateWithDuration:1.0f animations:^{
            if (self.readBookToolBar.alpha == 1) {
                self.readBookToolBar.alpha = 0;
            }
            else
            {
                self.readBookToolBar.alpha = 1;
            }
        }];
    }
}

- (void)hideToolBar
{
    if (self.readType == READ_SPLIT_MODEL) {
        if (self.readBookToolBar.alpha == 1) {
            [UIView animateWithDuration:1.0f animations:^{
                self.readBookToolBar.alpha = 0;
            }];
        }
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    [self.readBookToolBar setCurrentIndex:[self currentIndex]];
}

- (void)goBack:(id)sender
{
    NSInteger index = [self currentIndex];
    NSInteger count = [self.readBookDataSource totalCount];
    if (index >= 0 && count > 0) {
        if (index + 1 >= count) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
            [dic setObject:[NSString stringWithFormat:@"%d", 100] forKey:@"progress"];
            [dic setObject:[NSString stringWithFormat:@"%lld", self.bookID] forKey:@"book_id"];
            [dic setObject:[NSString stringWithFormat:@"%ld", index + 1] forKey:@"toPage"];
            [dic setObject:[NSString stringWithFormat:@"%ld", count] forKey:@"totalPage"];
            
            //用户阅读书籍返回发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_ReadBookBack object:nil userInfo:dic];
            
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"阅读尚未完成，是否中断阅读？" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"继续阅读", nil];
    alertView.tag = 0;
    
    [alertView show];
}

#pragma mark - actionSheetDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        //退出
        NSInteger index = [self currentIndex];
        NSInteger count = [self.readBookDataSource totalCount];
        if (index >= 0 && count > 0) {
            NSInteger progress = 100*index/count;
            if (index + 1 >= count) {
                progress = 100;
            }
            if (progress == 0) {
                progress = 8;
            }
            if (progress < 0 || progress > 100) {
                progress = 0;
            }
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
            [dic setObject:[NSString stringWithFormat:@"%ld", progress] forKey:@"progress"];
            [dic setObject:[NSString stringWithFormat:@"%lld", self.bookID] forKey:@"book_id"];
            [dic setObject:[NSString stringWithFormat:@"%ld", index + 1] forKey:@"toPage"];
            [dic setObject:[NSString stringWithFormat:@"%ld", count] forKey:@"totalPage"];
            
            //用户阅读书籍返回发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_ReadBookBack object:nil userInfo:dic];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //继续阅读
    }
}

@end
