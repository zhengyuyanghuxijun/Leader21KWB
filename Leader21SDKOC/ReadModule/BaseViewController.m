//
//  BaseViewController.m
//  magicEnglish
//
//  Created by jianjie.wu on 8/13/13.
//  Copyright (c) 2013 ilovedev.com. All rights reserved.
//

#import "BaseViewController.h"

#import "ViewCreatorHelper.h"
#import "CustomNavView.h"

@interface BaseViewController ()

@property (nonatomic, assign) BOOL isFirstAppear;

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _showNavBar = YES;
        _useAsRootController = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self resetBackground];

//    self.userId = [DE currentUserId];
    
    if ([[UIDevice currentDevice] systemVersionNotLowerThan:@"7.0"]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    self.view.layer.cornerRadius = 5;
//    self.view.layer.masksToBounds = YES;
    
    self.isFirstAppear = YES;
    
    CGFloat h = [BaseViewController navBarHeight];
    self.leftBarButtonRect = CGRectMake(0.0f, h - 44.0f, 44.0f, 44.0f);
    self.rightBarButtonRect = CGRectMake(self.view.width-44.0f, h - 44.0f, 44.0f, 44.0f);
    
    if (self.showNavBar) {
        self.navBarView = [[CustomNavView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, h)];
        [self.view addSubview:self.navBarView];
        
        if (self.navBarTitle != nil) {
            // 设置标题
            [self customNavBarSetTitle:self.navBarTitle];
        }
        
        // 默认加一个返回按钮，不需要的界面可以自行去掉
        if (!self.useAsRootController) {
            UIButton* button = [ViewCreatorHelper createIconButtonWithFrame:self.leftBarButtonRect
                                                                 normaImage:@"back_button.png"
                                                             highlitedImage:@"back_button_pressed.png"
                                                               disableImage:nil
                                                                     target:self
                                                                     action:@selector(goBack:)];
            [self setLeftCustomViews:[NSArray arrayWithObject:button]];
        }
    }
    
    [self resetContentViewrect];
    
//    self.isLastStatusLogin = [DE islogin];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isFirstAppear) {
        [self doSomethingInFirstAppear];
        self.isFirstAppear = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self resetContentViewrect];
}

- (void)resetBackground
{
    [self.view setBackgroundColor:BACKGROUNDCOLOUR];
    
    UIImage* bgImage = [UIImage resizebleImageNamed:@"bg.png"];
    self.bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.bgImageView.image = bgImage;
    [self.view addSubview:self.bgImageView];
    self.bgImageView.hidden = YES;
}


- (void)resetContentViewrect
{
    CGRect rc = self.view.bounds;
    CGFloat h = [BaseViewController navBarHeight];
    if (!self.showNavBar) {
        h = 0.0f;
    }
    rc.origin.y += h;
    rc.size.height -= h;
    self.contentViewRect = rc;
    
    rc = self.view.bounds;
    h = 0.0f;
    if ([[UIDevice currentDevice] systemVersionNotLowerThan:@"7.0"]) {
        h = 20.0f;
    }
    
    rc.origin.y += h;
    rc.size.height -= h;
    self.contentViewRectWithStatusBar = rc;
}

// IOS6.x 不再会调到此方法
- (void)viewDidUnload {
    [super viewDidUnload];
    
    [self handleMemoryWarning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidLoad
    if (![self isViewLoaded]) {
        return;
    }
    if ([[UIDevice currentDevice] systemVersionNotLowerThan:@"6.0"]) {
        if (self.view.window == nil)// 是否是正在使用的视图
        {
            [self handleMemoryWarning];
            
            self.view = nil;// 目的是再次进入时能够重新加载
        }
    }
}

- (void)handleMemoryWarning
{
    if (self.showNavBar) {
        self.navBarView = nil;
    }
}

- (void)customNavBarSetTitle:(NSString*)title
{
    if (self.navBarView != nil && title != nil) {
        CGFloat fontSize = [DE isPad] ? 24.0f : 18.0f;
        UILabel* tLabel = [ViewCreatorHelper createLabelWithTitle:title
                                                             font:[UIFont boldSystemFontOfSize:fontSize]
                                                            frame:self.navBarView.bounds
                                                        textColor:NAVBAR_TITLE_COLOR
                                                    textAlignment:NSTextAlignmentCenter];
        tLabel.numberOfLines = 2;
        [tLabel setShadowColor:[UIColor darkGrayColor]];
        [tLabel setShadowOffset:CGSizeMake(0.0f, 2.0f)];
        [self.navBarView setText:tLabel.text
                         onLabel:tLabel
                    leftCapWidth:10];
    
        

        [self.navBarView setTitleCustomView:tLabel];
    }
}

- (void)customNavBarSetTitleImage:(UIImage*)titleImage
{
    UIImageView * logoTitleImg =  [[UIImageView alloc] initWithImage:titleImage];
    
    [logoTitleImg setContentMode:UIViewContentModeCenter];
    [logoTitleImg setFrame:self.navBarView.bounds];
    
    
    [self.navBarView setTitleCustomView:logoTitleImg];
}

//
- (void)setLeftCustomViews:(NSArray*)leftCustomArray
{
    [self.navBarView setLeftCustomViews:leftCustomArray];
}

- (void)setRightCustomViews:(NSArray*)rightCustomArray
{
    [self.navBarView setRightCustomViews:rightCustomArray];
}

- (void)setNavBarTitle:(NSString*)title
{
    _navBarTitle = [title copy];
    if ([self isViewLoaded]) {
        [self customNavBarSetTitle:title];
    }
}

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doSomethingInFirstAppear
{
    ;
}


+ (CGFloat)navBarHeight
{
    if ([[UIDevice currentDevice] systemVersionNotLowerThan:@"7.0"]) {
        return 64.0f;
    }
    else {
        return 44.0f;
    }
}

+ (CGFloat)navBarHeight2
{
    if ([[UIDevice currentDevice] systemVersionNotLowerThan:@"7.0"]) {
        return 85.0f;
    }
    else {
        return 65.0f;
    }
}


@end
