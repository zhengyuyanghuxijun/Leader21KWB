//
//  ReadBookViewController.h
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-11.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "BaseViewController.h"
#import "BasePageViewController.h"
#import "ReadBookToolBar.h"
#import "ReadBookOrientationButton.h"

typedef NS_ENUM(NSInteger, ReadType){
    READ_NORMAL_MODEL = 0,
    READ_SPLIT_MODEL,
    READ_OC_MODEL,
    READ_PR_MODEL,
};

@interface ReadBookViewController : BaseViewController<UIPageViewControllerDelegate>

@property (nonatomic, copy) NSString *folderName;
@property (nonatomic, assign) long long bookID;
@property (nonatomic, strong, readonly) BasePageViewController *pageViewController;
@property (nonatomic, strong) ReadBookToolBar *readBookToolBar;
@property (nonatomic, strong) ReadBookOrientationButton *rotateButton;

- (void)goBack:(id)sender;

@end
