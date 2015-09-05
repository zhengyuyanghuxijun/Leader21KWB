//
//  SegmentViewController.m
//  magicEnglish
//
//  Created by libin.tian on 9/17/13.
//  Copyright (c) 2013 ilovedev.com. All rights reserved.
//

#import "SegmentViewController.h"


static     CGFloat tabViewHeight = 40.0f;

@interface SegmentViewController ()

@property (nonatomic, strong) UIView* currentView;

@property (nonatomic, assign) CGRect viewRect;

@end

@implementation SegmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.bgImageView.hidden = NO;
    
    CGFloat height = tabViewHeight;
    if ([DE isPad]) {
        height = tabViewHeight * 2.0f;
    }
    
    
    [self createHeaderView];
    
    CGRect rc = self.contentViewRect;
    if (self.headerView != nil) {
        rc.origin.y = self.headerView.bottom;
    }
    rc.size.height = height;
    //
    self.tabView = [[SegmentControlView alloc] initWithFrame:rc];
    self.tabView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	self.tabView.delegate = self;
    self.tabView.clipsToBounds = NO;
    
    [self.view addSubview:self.tabView];
    
    //
    rc.origin.y += height;
    rc.size.height = self.contentViewRect.size.height - height;
    NSInteger count = [self.controllerArray count];
    if (count == 0) {
        return;
    }
    
    
    rc = CGRectMake(0.0f, self.tabView.bottom, self.view.width, self.view.size.height - self.tabView.bottom);
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:rc];
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.contentSize = CGSizeMake(rc.size.width * count, rc.size.height);
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.delegate = self;
    self.mainScrollView.backgroundColor = BACKGROUNDCOLOUR;
//    self.mainScrollView.scrollEnabled = NO;

    rc = self.contentViewRect;
    CGFloat tabTop = self.contentViewRect.origin.y;
    if (self.headerView != nil) {
        rc.origin.y = self.headerView.bottom;
        rc.size.height -= self.headerView.height;
        tabTop = self.headerView.bottom;
    }
    rc.origin.y += height;
    rc.size.height -= height;
    CGFloat viewH = rc.size.height;
    
    rc = CGRectMake(0.0f, tabTop, self.contentViewRect.size.width, height);
    self.tabView.frame = rc;
    
    self.viewRect = CGRectMake(0.0f, 0.0f, self.contentViewRect.size.width, viewH);

    NSInteger index = 0;
    for (BaseViewController* vc in self.controllerArray) {
        [self addChildViewController:vc];
    
        CGRect rc1 = self.viewRect;
        rc1.origin.x = index * vc.view.width;
        vc.view.frame = rc1;
        [self.mainScrollView addSubview:vc.view];
        
        index++;
    }


    if (self.currentIndex >= [self.childViewControllers count]) {
        self.currentIndex = 0;
    }
    [self showNewController:self.currentIndex];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat height = tabViewHeight;
    if ([DE isPad]) {
        height = tabViewHeight * 2.0f;
    }
    CGRect rc = self.contentViewRect;
    CGFloat tabTop = self.contentViewRect.origin.y;
    if (self.headerView != nil) {
        rc.origin.y = self.headerView.bottom;
        rc.size.height -= self.headerView.height;
        tabTop = self.headerView.bottom;
    }
    rc.origin.y += height;
    rc.size.height -= height;
    CGFloat viewH = rc.size.height;
    
    rc = CGRectMake(0.0f, tabTop, self.contentViewRect.size.width, height);
    self.tabView.frame = rc;
    
    self.viewRect = CGRectMake(0.0f, 0.0f, self.contentViewRect.size.width, viewH);
    self.currentView.frame = self.viewRect;
    
    [self.view bringSubviewToFront:self.tabView];
}

- (void)createHeaderView
{
    //
}


- (void)showNewController:(NSInteger)index
{
    if (index < [self.childViewControllers count]) {
        BaseViewController* vc = [self.childViewControllers objectAtIndex:index];
        CGRect rc = self.viewRect;
        rc.origin.x = index * vc.view.width;
        self.currentView = vc.view;
        
        [self.mainScrollView scrollRectToVisible:rc animated:YES];
    }
}

#pragma mark - SegmentControlViewDelegate
- (void)segmentControl:(SegmentControlView*)segment didSelectedIndex:(NSInteger)index
{
    if (index < [self.childViewControllers count]) {
        [self showNewController:index];
        self.currentIndex = index;
        [self.view endEditing:YES];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    NSInteger index = x / scrollView.width;
    [self.tabView selectIndex:index animated:YES];
    
    [self.view endEditing:YES];
}
@end
