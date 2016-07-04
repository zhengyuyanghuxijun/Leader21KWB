//
//  HBGridView.m
//  HBGridView
//
//  Created by wxj wu on 12-7-23.
//  Copyright (c) 2012年 tt. All rights reserved.
//

#import "HBGridView.h"
#import "HBGridCellView.h"

#import "RefreshTableHeaderView.h"

@interface HBGridView ()<RefreshTableHeaderDelegate>
{
    RefreshTableHeaderView *_headerView;
    BOOL _isRefresh;
}

@property (nonatomic, strong)RefreshTableHeaderView * headerView;//下拉加载
@property (nonatomic, assign)BOOL isRefresh;

@end

@implementation HBGridView

@synthesize
tableView = _tableView,
delegate = _delegate;

#pragma mark -
#pragma mark 内部调用方法

- (GridIndex *)gridIndexOfIndex:(NSInteger)index
{
    NSInteger columnCount = [_delegate columnNumberOfGridView:self];
    NSInteger column = index % columnCount;
    NSInteger row = index / columnCount;
    return [GridIndex gridIndexWithRow:row column:column];
}

// 初始化子视图
- (void)initSubControls
{
    // 初始化列表
    CGRect rect = self.frame;
    rect.origin = CGPointZero;
    _tableView = [[UITableView alloc] initWithFrame:rect];
    _tableView.delegate = self, _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
    _headerView = [[RefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -_tableView.frame.size.height, _tableView.frame.size.width, _tableView.frame.size.height)];
    _headerView.delegate = self;
    _headerView.hidden = YES;
    [_tableView addSubview:_headerView];
}

-(void)setHeaderViewHidden:(BOOL)hidden
{
    _headerView.hidden = hidden;
}

-(void)setBackgroundView:(NSString *)imgName
{
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
    [_tableView setBackgroundView:imageView];
}

-(void)setScrollEnabled:(BOOL)enabled
{
    [_tableView setScrollEnabled:enabled];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        [self initSubControls];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark -
#pragma mark 外部调用方法

- (HBGridItemView *)dequeueReusableGridItemAtGridIndex:(GridIndex *)gridIndex ofGridCellView:(HBGridCellView *)gridCellView
{
    return [gridCellView gridItemViewAtIndex:gridIndex.column];
}

- (HBGridItemView *)gridItemViewAtGridIndex:(GridIndex *)gridIndex
{
    HBGridCellView *cell = (HBGridCellView *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:gridIndex.row inSection:0]];
    return [cell gridItemViewAtIndex:gridIndex.column];
}

- (HBGridItemView *)gridItemViewAtIndex:(NSInteger)index
{
    return [self gridItemViewAtGridIndex:[self gridIndexOfIndex:index]];
}

- (GridIndex *)gridIndexOfGridItemView:(HBGridItemView *)gridItem
{
    HBGridCellView *cell = (HBGridCellView *)[gridItem superview];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if (indexPath) 
    {
        NSInteger itemIndex = [cell indexOfGridItemView:gridItem];
        return [GridIndex gridIndexWithRow:indexPath.row column:itemIndex];
    }
    return nil;
}

- (NSInteger)indexOfGridItemView:(HBGridItemView *)gridItem
{
    GridIndex *gridIndex = [self gridIndexOfGridItemView:gridItem];
    return [self indexOfGridIndex:gridIndex];
}

- (NSInteger)indexOfGridIndex:(GridIndex *)gridIndex
{
    return gridIndex.row * [_delegate columnNumberOfGridView:self] + gridIndex.column;
}

- (void)reloadData
{
    [_tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource

// todo：暂时只考虑一个section的情况
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_delegate rowNumberOfGridView:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *gridCellStr = @"gridCell";
    HBGridCellView *cellView = [tableView dequeueReusableCellWithIdentifier:gridCellStr];
    if (!cellView) 
    {
        cellView = [[HBGridCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:gridCellStr];
    }
    // 获取grid的总数
    NSInteger count = [_delegate gridNumberOfGridView:self];
    // 行数
    NSInteger rowCount = [_delegate rowNumberOfGridView:self];
    // 列数
    NSInteger columnCount = [_delegate columnNumberOfGridView:self];
    // 判断区域是否合法
    if (indexPath.row < rowCount) 
    {
        for (NSInteger index = 0; index < columnCount; index ++) 
        {
            GridIndex *gridIndex = [GridIndex gridIndexWithRow:indexPath.row column:index];
            if ([self indexOfGridIndex:gridIndex] >= count)
            {
                HBGridItemView *itemView = [cellView gridItemViewAtIndex:gridIndex.column];
                itemView.hidden = YES;
                continue;
            }
            // 暂时，griditeview的frame由delegate设置
            HBGridItemView *gridItemView = [_delegate gridView:self inGridCell:cellView gridItemViewAtGridIndex:gridIndex listIndex:[self indexOfGridIndex:gridIndex]];
            gridItemView.hidden = NO;
            // todo: 将griditemview添加到gridcellview中
            [cellView addGridItemViewAtGridIndex:gridIndex withGridItemView:gridItemView];
            //  给gridItemView添加点击事件
            [gridItemView setTarget:self action:@selector(didTap:)];
        }
    }
    cellView.backgroundColor = [UIColor clearColor];
    return cellView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_delegate gridView:self heightForRowAtIndexPath:indexPath];
}

- (void)didTap:(id)sender
{
    if ([_delegate respondsToSelector:@selector(gridView:didSelectGridItemAtIndex:)]) 
    {
        HBGridItemView *view = (HBGridItemView *)sender;
        self.selIndex = [self indexOfGridItemView:view];
        NSLog(@"tap index:%ld", self.selIndex);
        [_delegate gridView:self didSelectGridItemAtIndex:self.selIndex];
    }
}

#pragma mark - refreshTableHeaderViewDelegate

- (void)refreshTableHeaderDidTriggerRefresh:(RefreshTableHeaderView *)view{
    if(_isRefresh)return;
    _isRefresh = true;
    if ([_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh)])
    {
        [_delegate refreshTableHeaderDidTriggerRefresh];
    }
}
- (BOOL)refreshTableHeaderDataSourceIsLoading:(RefreshTableHeaderView*)view{
    
    return _isRefresh;
}

-(void)hideRefreshView
{
    if (_isRefresh) {
        _isRefresh = NO;
        [_headerView refreshScrollViewDataSourceDidFinishedLoading:_tableView];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
    if ([_delegate respondsToSelector:@selector(gridViewDidScroll:)])
    {
        [_delegate gridViewDidScroll:self];
    }
    
    if(scrollView == _tableView && ![_headerView isHidden]){
        //        isScroll = NO;
        [_headerView refreshScrollViewDidScroll:_tableView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([_delegate respondsToSelector:@selector(gridViewDidEndDragging:willDecelerate:)]) 
    {
        [_delegate gridViewDidEndDragging:self willDecelerate:decelerate];
    }
    
    if(scrollView == _tableView && ![_headerView isHidden]){
        [_headerView refreshScrollViewDidEndDragging:_tableView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([_delegate respondsToSelector:@selector(gridViewDidEndDecelerating:)])
    {
        [_delegate gridViewDidEndDecelerating:self];
    }
}

@end

@implementation GridIndex

@synthesize
row = _row,
column = _column;

- (id)initWithRow:(NSInteger)row column:(NSInteger)column
{
    if (self = [super init]) 
    {
        _row = row;
        _column = column;
    }
    return self;
}

+ (id)gridIndexWithRow:(NSInteger)row column:(NSInteger)column
{
    GridIndex *index = [[GridIndex alloc] initWithRow:row column:column];
    return index;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{row:%ld, column:%ld}", (long)_row, (long)_column];
}

@end
