//
//  ReadBookToolBar.h
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-12.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonType) {
    PRE_PAGE_BUTTON    = 1 << 0,
    NEXT_PAGE_BUTTON   = 1 << 1,
    OC_MODEL_BUTTON    = 1 << 2,
    PR_MODEL_BUTTON    = 1 << 3,
    AUTO_PLAY_BUTTON   = 1 << 4,
};

typedef NS_ENUM(NSInteger, ToolBarType) {
    BAR_TYPE_NORMAL = 0,
    BAR_TYPE_SPLIT,
    BAR_TYPE_PR,
};

typedef void (^ToolButtonClickBlock)(ButtonType buttonType);

@interface ReadBookToolBar : UIView

@property (nonatomic, copy) ToolButtonClickBlock toolButtonClickBlock;
@property (nonatomic, assign) ToolBarType toolBarType;

- (void)enableOCModel:(BOOL)isEnable;
- (void)enablePRModel:(BOOL)isEnable;
- (void)enableAutoPlay:(BOOL)isEnable;
- (void)setCurrentIndex:(NSInteger)currentIndex;
@end
