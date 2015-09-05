//
//  ReadBookContentViewController.h
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-11.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "BaseViewController.h"
#import "ReadBookResourceModel.h"
#import "ReadBookViewController.h"

@class ReadBookOCController;
@class ReadBookPRController;

@interface ReadBookContentViewController : UIViewController

@property (nonatomic, strong) NSString *contentImageName;
@property (nonatomic, strong) ReadBookResourceModel *resourceModel;
@property (nonatomic, assign) NSInteger coupleTag;
@property (nonatomic, assign) ReadType readType;
@property (nonatomic, strong, readonly) UIImageView *contentImageView;
@property (nonatomic, assign) BOOL isFirstPage;
@property (nonatomic, weak) ReadBookOCController *ocController;
@property (nonatomic, weak) ReadBookPRController *prController;

- (void)reloadPageData;
- (void)setViewFrame:(CGRect)frame;
@end
