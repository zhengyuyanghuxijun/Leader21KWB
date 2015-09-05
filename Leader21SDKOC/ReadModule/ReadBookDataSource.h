//
//  ReadBookDataSource.h
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-11.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadBookContentViewController.h"
#import "ReadBookViewController.h"
#import "ReadBookResourceModel.h"

typedef void (^ReadBookDataSourcePageChangeBlock)(NSInteger curIdx, BOOL ocModelEnable, BOOL prModelEnable);

@interface ReadBookDataSource : NSObject<UIPageViewControllerDataSource>

@property (nonatomic, copy) ReadBookDataSourcePageChangeBlock readBookDataSourcePageChangeBlock;
@property (nonatomic, weak) ReadBookViewController *readBookVC;
@property (nonatomic, strong) ReadBookResourceModel *resourceModel;
@property (nonatomic, strong, readonly) NSMutableArray *orignalResourceImageArr;

- (void)ocModelStart;
- (void)prModelStart;
- (void)ocModelEnd;
- (void)prModelEnd;
- (ReadBookContentViewController *)viewControllerAtIndex:(NSUInteger)index;
- (ReadBookContentViewController *)viewControllerAtIndex:(NSUInteger)index readType:(ReadType)readType;
- (NSUInteger)indexOfViewController:(ReadBookContentViewController *)viewController;
- (NSUInteger)totalCount;
- (id)initWithIndexName:(NSString *)indexName readBookVC:(ReadBookViewController *)readBookVC;
@end

@interface ReadBookNormalModelSource : ReadBookDataSource

@end

@interface ReadBookSplitModelSource : ReadBookDataSource

@property (nonatomic, assign) NSInteger coupleCount;
@property (nonatomic, assign) ReadType readType;

- (NSArray *)viewControllersCoupleAtIndex:(NSInteger)index;

@end
