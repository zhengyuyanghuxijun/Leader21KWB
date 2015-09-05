//
//  BaseTableViewCell.h
//  magicEnglish
//
//  Created by libin.tian on 9/13/13.
//  Copyright (c) 2013 ilovedev.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    tableViewCellPositionMiddle = 0,
    tableViewCellPositionTop = 1,
    tableViewCellPositionBottom = 2
}tableViewCellPosition;

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView* lineView;
@property (nonatomic, strong) UIColor* lineViewColor;

@property (nonatomic, strong) UIView* customAccessoryView;

@property (nonatomic, assign) BOOL showUnderLine;

@property (nonatomic, strong) id itemData;

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
// 子类重写
- (void)configCellWithData:(id)data atIndex:(NSIndexPath*)indexPath positionType:(tableViewCellPosition)pos;

+ (CGFloat)cellHeightForObject:(id)obj;

@end
