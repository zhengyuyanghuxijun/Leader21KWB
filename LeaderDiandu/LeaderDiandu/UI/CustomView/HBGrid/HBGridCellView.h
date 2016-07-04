//
//  HBGridCellView.h
//  HBGridView
//
//  Created by wu on 12-7-23.
//  Copyright (c) 2012年 tt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridIndex;
@class HBGridItemView;

@interface HBGridCellView : UITableViewCell
{
    NSMutableArray *_gridItemViewArray;             // 保存griditemview
}

- (void)addGridItemViewAtGridIndex:(GridIndex *)gridIndex withGridItemView:(HBGridItemView *)gridItemView;
- (HBGridItemView *)gridItemViewAtIndex:(NSInteger)index;
- (NSInteger)indexOfGridItemView:(HBGridItemView *)gridItemView;

@end
