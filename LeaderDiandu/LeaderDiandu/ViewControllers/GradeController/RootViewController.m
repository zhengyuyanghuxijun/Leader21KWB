//
//  RootViewController.m
//  magicEnglish
//
//  Created by libin.tian on 3/5/14.
//  Copyright (c) 2014 ilovedev.com. All rights reserved.
//

#import "RootViewController.h"

#import "GradeSelectViewController.h"
#import "LoginViewController.h"
#import "UserCenterViewController.h"
#import "BookListViewController.h"
#import "ReadBookViewController.h"
#import "ReadBookXMLParser.h"
#import "LOLProgressOverlayView.h"
#import "UserHeaderButton.h"
#import "MyBookShelfViewController.h"

#import "AppUser.h"
#import "LocalSettings.h"

#import "GradeSelectView.h"
#import "UIButton+WebCache.h"

static const CGFloat headerViewHeight = 80.0f;

@interface RootViewController ()<GradeSelectViewDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger currentGrade;
@property (nonatomic, strong) UIButton* userButton;

@property (nonatomic, strong) GradeSelectView* headerView;
@property (nonatomic, strong) UIScrollView* mainScrollView;
@property (nonatomic, strong) NSArray* controllerArray;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.useAsRootController = YES;
        self.currentGrade = -1;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.bgImageView.hidden = NO;
    [self customNavBarSetTitleImage:[UIImage imageNamed:@"logo"]];
    
    self.userButton = [ViewCreatorHelper createIconButtonWithFrame:self.leftBarButtonRect
                                                        normaImage:@"account.png"
                                                    highlitedImage:@""
                                                      disableImage:nil
                                                            target:self
                                                            action:@selector(userButtonPressed:)];
    self.userButton.width -= 4.0f;
    self.userButton.height -= 4.0f;
    [self setLeftCustomViews:@[self.userButton]];

    UIButton* bookButton = [ViewCreatorHelper createIconButtonWithFrame:self.rightBarButtonRect
                                                             normaImage:@"icon_shelf.png"
                                                         highlitedImage:@""
                                                           disableImage:nil
                                                                 target:self
                                                                 action:@selector(bookButtonPressed:)];
    [self setRightCustomViews:@[bookButton]];

    // 初始化六个年级的子类界
    const NSInteger subControllerCount = 6;
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:subControllerCount];
    for (NSInteger i=0; i < subControllerCount; i++) {
        GradeSelectViewController* vc = [[GradeSelectViewController alloc] init];
        vc.currentGrade = i;
        [array addObject:vc];
    }
    self.controllerArray = [NSArray arrayWithArray:array];
    
    CGRect rc = self.contentViewRect;
    
    rc.size.height = headerViewHeight;
    self.headerView = [[GradeSelectView alloc] initWithFrame:rc];
    self.headerView.delegate = self;
    
    rc.size.height = self.contentViewRect.size.height;
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:rc];
    self.mainScrollView.scrollsToTop = NO;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.delegate = self;
    
    [self.view addSubview:self.mainScrollView];

    [self.view addSubview:self.headerView];
    
//    self.mainScrollView.backgroundColor = [UIColor yellowColor];
    
    rc.origin.y = 0.0f;
    for (GradeSelectViewController* vc in self.controllerArray) {
        vc.topSpace = headerViewHeight;
        [self addChildViewController:vc];
        vc.view.frame = rc;
        [self.mainScrollView addSubview:vc.view];
        
        rc.origin.x += rc.size.width;
    }
    
    if (self.currentGrade < examGradeLevel0) {
        self.currentGrade = examGradeLevel0;
    }
    
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.width*subControllerCount, self.mainScrollView.height);
    self.mainScrollView.contentOffset = CGPointMake(self.mainScrollView.width*self.currentGrade, 0.0f);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoutByForce:)
                                                 name:kNotification_logoutByForce
                                               object:nil];
}

- (void)logoutByForce:(NSNotification*)notification
{
    if ([self isViewLoaded]) {
        [self resetStatusForUnlogin];
    }
}

- (void)resetStatusForUnlogin
{
    UIImage* img = [UIImage imageNamed:@"account.png"];
    CGPoint center = self.userButton.center;

    self.userButton.size = self.leftBarButtonRect.size;
    self.userButton.clipsToBounds = YES;
    self.userButton.layer.cornerRadius = 0.0f;
    self.userButton.layer.borderWidth = 0.0f;
    [self.userButton setImage:img forState:UIControlStateNormal];
    [self.userButton setImage:img forState:UIControlStateSelected];
    [self.userButton setImage:img forState:UIControlStateHighlighted];
    
    UIImageView* imgView = self.userButton.imageView;
    imgView.clipsToBounds = YES;
    imgView.layer.cornerRadius = 0.0f;
    imgView.layer.borderWidth = 0.0f;


    self.userButton.center = center;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([DE islogin]) {
        UIImage* img = [UIImage imageNamed:@"account.png"];
        CGPoint center = self.userButton.center;
        self.userButton.size = CGSizeMake(32.0f, 32.0f);
        NSString* url = DE.me.userImageUrl;
        __block UIButton* button = self.userButton;
        [self.userButton setImageWithURL:[NSURL URLWithString:url]
                        placeholderImage:img
                                 success:^(UIImage *image) {
                                     UIColor* color = RGBCOLOR(1, 114, 151);
                                     button.layer.borderColor = color.CGColor;
                                     button.clipsToBounds = YES;
                                     button.layer.cornerRadius = button.width/2.0f;
                                     button.layer.borderWidth = 2.0f;
                                     
                                     UIImageView* imgView = button.imageView;
                                     imgView.layer.borderColor = color.CGColor;
                                     imgView.clipsToBounds = YES;
                                     imgView.layer.cornerRadius = button.width/2.0f;
                                     imgView.layer.borderWidth = 2.0f;
                                     
                                 }
                                 failure:^(NSError *error) {
                                     ;
                                 }];
        
        self.userButton.center = center;
        
        // 调下接口，看上是否还在登录状态
        NSString* uid = [DE.me.userID stringValue];
        [DE getUserBaseInfo:uid onComplete:nil];
    }
    else {
        [self resetStatusForUnlogin];
    }
}

- (void)userButtonPressed:(id)sender
{
    // 跳到用户中心
    UserCenterViewController* vc = [[UserCenterViewController alloc] init];
    [Navigator pushController:vc];
}

- (void)bookButtonPressed:(id)sender
{
    MyBookShelfViewController* vc = [[MyBookShelfViewController alloc] init];
    [Navigator pushController:vc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GradeSelectViewDelegate

- (void)segmentControl:(GradeSelectView*)view didSelectedIndex:(NSInteger)index
{
    CGFloat offsetX = self.mainScrollView.width * index;
    CGPoint offset = CGPointMake(offsetX, 0.0f);
    [self.mainScrollView setContentOffset:offset animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetx = scrollView.contentOffset.x;
    NSInteger index = (NSInteger)((NSInteger)(offsetx+1.0f) / scrollView.width);
    [self.headerView selectIndex:index animated:YES];
}

@end
