//
//  ScrollLayoutViewController.m
//  magicEnglish
//
//  Created by dajie on 2/8/14.
//  Copyright (c) 2014 wangliang. All rights reserved.
//

#import "ScrollLayoutViewController.h"

@interface ScrollLayoutViewController ()

@end

@implementation ScrollLayoutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _whiteSpace = 2.0f;
        _topSpace = 10.0f;
        _leftSpace = 20.0f;
        if ([DE isPad]) {
            _leftSpace = 100.0f;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.contentViewRect];
    self.mainScrollView.delegate = self;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.mainScrollView];
    
    // 排版view
    self.layoutViewArray = [NSMutableArray arrayWithCapacity:32];
    [self createLayoutViews];
    
    [self layoutCustomViews];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.mainScrollView.frame = self.contentViewRect;
    [self layoutCustomViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////
// 子类一般不用重写，特殊需求再重写的方法
- (void)layoutCustomViews
{
    NSUInteger count = [self.layoutViewArray count];
    CGFloat height = 0.0f;
    for (NSInteger i = 0; i< count; i++) {
        UIView* view = [self.layoutViewArray objectAtIndex:i];
        if (i > 0) {
            UIView* vv = [self.layoutViewArray objectAtIndex:i-1];
            view.top = vv.bottom + self.whiteSpace;
        }
        else {
            view.top = self.topSpace;
        }
        
        height = view.bottom + self.whiteSpace;
    }
    
    if (height <= self.mainScrollView.height) {
        height = self.mainScrollView.height + 1.0f;
    }

    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.width, height);
}

- (void)addToLayoutView:(UIView*)view
{
    if (view != nil) {
        [self.mainScrollView addSubview:view];
        [self.layoutViewArray addObject:view];
    }
}

- (void)addEmptyViewWithHeight:(CGFloat)height
{
    UIView* emptyView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1.0f, height)];
    [self addToLayoutView:emptyView];
}


//////////////////////////////////////////
// 子类一定要重写的方法
- (void)createLayoutViews
{
    // 这里需要把所创建的，需要自动排版的子view放到 layoutViewArray数组当中
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    if ([self isEditing]) {
        [self.view endEditing:YES];
//    }
}

@end
