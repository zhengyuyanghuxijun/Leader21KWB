//
//  TableViewController.h
//  magicEnglish
//
//  Created by libin.tian on 9/13/13.
//  Copyright (c) 2013 ilovedev.com. All rights reserved.
//

#import "BaseViewController.h"

#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
#import "TableViewDataSource.h"


@class EmptyView;

@interface TableViewController : BaseViewController
<UITableViewDelegate,
TableViewDataProcessDelegate,
EGORefreshTableHeaderDelegate,
LoadMoreTableFooterDelegate>

@property (nonatomic, assign) BOOL needPullToRefresh;
@property (nonatomic, assign) BOOL needPullupLoadMore;

@property (nonatomic, assign) BOOL isRefreshingData;
@property (nonatomic, assign) BOOL isLoadingMoreData;

@property (nonatomic, strong) UITableView* mainTableView;
@property (nonatomic, strong) TableViewDataSource* dataSource;

@property (nonatomic, strong) EGORefreshTableHeaderView* refreshHeadView;
@property (nonatomic, strong) LoadMoreTableFooterView* loadMoreFootView;


@property (strong, nonatomic) EmptyView *emptyView;




////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
// 以下一定要得写
// 需要子类复写的方法
- (Class)dataSourceClass;

- (void)didSelectObject:(id)obj atIndexPath:(NSIndexPath *)indexPath;


////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
// 以下方法，在不需要上拉下拉刷新时要重写
// 初始化基础参数
- (void)configBaseParamInit;


////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
//供子类调用的方法，当然用的不爽，也可以重写
- (void)manualRefreshData;

- (void)showEmptyView:(NSString*)text;
- (void)hideEmptyView;

- (TableViewDataSource*)createDataSource;
- (void)createTableView;

- (void)createPullToRefreshView;
- (void)createLoadMoreView;

@end
