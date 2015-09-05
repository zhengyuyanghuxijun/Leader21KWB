//
//  TableViewController.m
//  magicEnglish
//
//  Created by libin.tian on 9/13/13.
//  Copyright (c) 2013 ilovedev.com. All rights reserved.
//

#import "TableViewController.h"

#import "EmptyView.h"
#import "MBHudUtil.h"

@interface TableViewController ()


@end


@implementation TableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _needPullToRefresh = YES;
        _needPullupLoadMore = YES;
        [self configBaseParamInit];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        _needPullToRefresh = YES;
        _needPullupLoadMore = YES;
        [self configBaseParamInit];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self createTableView];
    
    if (self.needPullToRefresh) {
        [self createPullToRefreshView];
    }
    
    if (self.needPullupLoadMore) {
        [self createLoadMoreView];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.mainTableView.frame = self.contentViewRect;
}

- (void)manualRefreshData
{
    [self.mainTableView setContentOffset:CGPointMake(0.0f, -90.0f) animated:NO];
    [self.refreshHeadView egoRefreshScrollViewDidEndDragging:self.mainTableView];
}

// 需要子类复写的方法
#pragma mark - need rewrite

- (Class)dataSourceClass
{
    return [TableViewDataSource class];
}

- (void)configBaseParamInit
{
}


#pragma mark - create base views
- (TableViewDataSource*)createDataSource
{
    if (_dataSource == nil) {
        Class c = [self dataSourceClass];
        if (![c isSubclassOfClass:[TableViewDataSource class]]) {
            c = [TableViewDataSource class];
        }
        _dataSource = [[c alloc] initWithDelegate:self];
    }
    
    return _dataSource;
}

- (void)createTableView
{
    self.mainTableView = [[UITableView alloc] initWithFrame:self.contentViewRect style:UITableViewStylePlain];
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = [self createDataSource];
}

- (void)createPullToRefreshView
{
    self.refreshHeadView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f-self.mainTableView.height, self.mainTableView.width, self.mainTableView.height)];
    self.refreshHeadView.delegate = self;
    self.refreshHeadView.backgroundColor = [UIColor clearColor];
    [self.mainTableView addSubview:self.refreshHeadView];
//    [self.view insertSubview:self.refreshHeadView belowSubview:self.mainTableView];
}

- (void)createLoadMoreView
{
    self.loadMoreFootView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.mainTableView.height, self.mainTableView.width, self.mainTableView.height)];
    self.loadMoreFootView.backgroundColor = [UIColor clearColor];
    self.loadMoreFootView.delegate = self;
    [self.mainTableView addSubview:self.loadMoreFootView];
}

- (void)didSelectObject:(id)obj atIndexPath:(NSIndexPath *)indexPath
{
    // sub class implement
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 7.0f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView* vv = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 7.0f)];
//    vv.backgroundColor = [UIColor clearColor];
//    return vv;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id obj = [self.dataSource objectOnIndexPath:indexPath];
    if (obj != nil) {
        [self didSelectObject:obj atIndexPath:indexPath];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.needPullToRefresh) {
        if(scrollView.contentOffset.y < 0) {
            [self.refreshHeadView egoRefreshScrollViewDidScroll:scrollView];
        }
    }
    if (self.needPullupLoadMore) {
        if (scrollView.contentOffset.y >= 0 && self.dataSource.hasMore) {
            [self.loadMoreFootView loadMoreScrollViewDidScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.needPullToRefresh) {
        if(scrollView.contentOffset.y < 0) {
            [self.refreshHeadView egoRefreshScrollViewDidEndDragging:scrollView];
        }
    }
    if (self.needPullupLoadMore) {
        if (scrollView.contentOffset.y >= 0 && self.dataSource.hasMore) {
            [self.loadMoreFootView loadMoreScrollViewDidEndDragging:scrollView];
        }
    }
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if (self.needPullToRefresh) {
//        if (scrollView.contentOffset.y < 0) {
//            [self.refreshHeadView egoRefreshScrollViewDidEndDecelerating:scrollView];
//        }
//    }
//}

#pragma mark - EGORefreshTableHeaderDelegate
- (UIEdgeInsets)egoRefreshTableViewEdgeInsets:(EGORefreshTableHeaderView*)view
{
    return UIEdgeInsetsZero;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self.dataSource refreshAllData];
}

- (UIEdgeInsets)egoRefreshTableHeaderDataTalbeViewInset:(EGORefreshTableHeaderView*)view
{
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}


- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return self.isRefreshingData;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

#pragma mark - LoadMoreTableFooterDelegate
- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreTableFooterView *)view
{
    [self.dataSource loadMoreData];
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view
{
    return self.isLoadingMoreData;
}

#pragma mark - TableViewDataProcessDelegate
//
- (void)dataSourceDidStartRefreshing:(TableViewDataSource*)ds
{
    self.isRefreshingData = YES;
}

- (void)dataSourceDidStartLoadingMore:(TableViewDataSource*)ds
{
    self.isLoadingMoreData = YES;
}

- (void)dataSource:(TableViewDataSource *)ds didEndRefreshing:(tableDataSourceProcessStatus)status message:(NSString*)message
{
    if (self.isRefreshingData) {
        self.isRefreshingData = NO;
        [self.refreshHeadView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mainTableView];
        
        if ([self.dataSource isEmpty]) {
            // 显示空界面
            [self showEmptyView:nil];
        }
        else {
            [self hideEmptyView];
        }
        if (status == tableDataSourceProcessStatusFailed) {
            // 提示错误信息
            [MBHudUtil showFailedActivityView:message inView:self.view];
        }
        else {
            if (self.dataSource.fetchedResultsController == nil && self.dataSource.dataArray != nil) {
                [self.mainTableView reloadData];
            }
        }
    }
}

- (void)dataSource:(TableViewDataSource *)ds didEndLoadingMore:(tableDataSourceProcessStatus)statuss message:(NSString*)message
{
    if (self.isLoadingMoreData) {
        self.isLoadingMoreData = NO;
        [self.loadMoreFootView loadMoreScrollViewDataSourceDidFinishedLoading:self.mainTableView];
        
        if ([self.dataSource isEmpty]) {
            // 显示空界面
        }
        if (statuss == tableDataSourceProcessStatusFailed) {
            // 提示错误信息
            [MBHudUtil showFailedActivityView:message
                                       inView:self.view];
        }
        else {
            if (self.dataSource.fetchedResultsController == nil && self.dataSource.dataArray != nil) {
                [self.mainTableView reloadData];
            }
        }
    }
}

- (void)dataSourceReloadData:(TableViewDataSource*)ds
{
    [self.mainTableView reloadData];
    
    if ([self.dataSource isEmpty]) {
        // 显示空界面
        [self showEmptyView:nil];
    }
    else {
        [self hideEmptyView];
    }
}

- (UITableView*)getTableView:(TableViewDataSource*)ds
{
    return self.mainTableView;
}


#pragma mark - empty view
- (void)showEmptyView:(NSString*)text
{
    if (self.emptyView == nil) {
        self.emptyView = [[EmptyView alloc] initWithFrame:self.contentViewRect];
        [self.view addSubview:self.emptyView];
        [self.view sendSubviewToBack:self.emptyView];
    }
    self.emptyView.hidden = NO;

    if (text != nil) {
        [self.emptyView resetLabelText:text];
    }
    else {
        [self.emptyView setNeedsLayout];
    }
}

- (void)hideEmptyView
{
    if (self.emptyView != nil) {
        self.emptyView.hidden = YES;
    }
}

@end
