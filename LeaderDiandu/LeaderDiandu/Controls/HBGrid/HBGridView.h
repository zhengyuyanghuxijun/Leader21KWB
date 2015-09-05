//
//  HBGridView.h
//  HBGridView
//
//  Created by wxj wu on 12-7-23.
//  Copyright (c) 2012年 tt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBGridItemView.h"

// row和column均从0开始算起
@interface GridIndex : NSObject 
{
    NSInteger _row;
    NSInteger _column;
}

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;

- (id)initWithRow:(NSInteger)row column:(NSInteger)column;
+ (id)gridIndexWithRow:(NSInteger)row column:(NSInteger)column;

@end

@class HBGridCellView;
@protocol HBGridViewDelegate;

@interface HBGridView : UIView<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
}

@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, assign) id<HBGridViewDelegate> delegate;

// 一个cell中的grid在内部是可以反复使用
- (HBGridItemView *)dequeueReusableGridItemAtGridIndex:(GridIndex *)gridIndex ofGridCellView:(HBGridCellView *)gridCellView;
// 获取某一位置出的griditem
- (HBGridItemView *)gridItemViewAtGridIndex:(GridIndex *)gridIndex;
- (HBGridItemView *)gridItemViewAtIndex:(NSInteger)index;
// 根据griditemview获取gridindex
- (GridIndex *)gridIndexOfGridItemView:(HBGridItemView *)gridItem;
- (NSInteger)indexOfGridItemView:(HBGridItemView *)gridItem;
- (NSInteger)indexOfGridIndex:(GridIndex *)gridIndex;
- (void)reloadData;

@end

@protocol HBGridViewDelegate <NSObject>

- (CGFloat)gridView:(HBGridView *)gridView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
// 获取单元格的总数
- (NSInteger)gridNumberOfGridView:(HBGridView *)gridView;
// 获取单元格的行数
- (NSInteger)rowNumberOfGridView:(HBGridView *)gridView;
// 获取gridview每行显示的grid数
- (NSInteger)columnNumberOfGridView:(HBGridView *)gridView;
// 获取特定位置的单元格视图
- (HBGridItemView *)gridView:(HBGridView *)gridView inGridCell:(HBGridCellView *)gridCell gridItemViewAtGridIndex:(GridIndex *)gridIndex listIndex:(NSInteger)listIndex;
@optional
// 点击某一个单元格的回调
- (void)gridView:(HBGridView *)gridView didSelectGridItemAtIndex:(NSInteger)index;
- (void)gridViewDidScroll:(HBGridView *)gridView;
- (void)gridViewDidEndDragging:(HBGridView *)gridView willDecelerate:(BOOL)decelerate;
- (void)gridViewDidEndDecelerating:(HBGridView *)gridView;

@end