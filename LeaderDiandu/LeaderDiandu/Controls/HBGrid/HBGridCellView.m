//
//  HBGridCellView.m
//  HBGridView
//
//  Created by wxj wu on 12-7-23.
//  Copyright (c) 2012年 tt. All rights reserved.
//

#import "HBGridCellView.h"
#import "HBGridItemView.h"

@implementation HBGridCellView

// index从0开始算起
- (CGPoint)getGridItemViewOriginAtIndex:(NSInteger)index
{
    if (!index) 
    {
        return CGPointZero;
    }
    HBGridItemView *itemView = [_gridItemViewArray objectAtIndex:index - 1];
    CGPoint origin = itemView.frame.origin;
    origin.x += itemView.frame.size.width;
    origin.x += 0;
    return origin;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
        // 点击无任何效果
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addGridItemViewAtGridIndex:(GridIndex *)gridIndex withGridItemView:(HBGridItemView *)gridItemView
{
    // todo: 判断griditemview是否已经存在，如果存在，那么不执行任何操作
    if ([_gridItemViewArray containsObject:gridItemView]) 
    {
        return;
    }
    if (!_gridItemViewArray) 
    {
        _gridItemViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [_gridItemViewArray addObject:gridItemView];
    // 计算griditemview的起点位置
    CGPoint origin = [self getGridItemViewOriginAtIndex:[_gridItemViewArray count] - 1];
    CGSize size = gridItemView.frame.size;
    gridItemView.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
    [self addSubview:gridItemView];
}

- (HBGridItemView *)gridItemViewAtIndex:(NSInteger)index
{
    if (index >= [_gridItemViewArray count])
    {
        return nil;
    }
    return [_gridItemViewArray objectAtIndex:index];
}

- (NSInteger)indexOfGridItemView:(HBGridItemView *)gridItemView
{
    if (!gridItemView) 
    {
        return -1;
    }
    return [_gridItemViewArray indexOfObject:gridItemView];
}

@end
