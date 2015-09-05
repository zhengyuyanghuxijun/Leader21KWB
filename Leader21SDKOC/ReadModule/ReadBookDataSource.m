//
//  ReadBookDataSource.m
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-11.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookDataSource.h"
#import "ReadBookOCController.h"
#import "ReadBookPRController.h"

@interface ReadBookDataSource()

@property (nonatomic, strong, readwrite) NSMutableArray *orignalResourceImageArr;
@property (nonatomic, strong) NSMutableArray *resourceImageArr;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, assign, readwrite) NSInteger currentIdx;
@property (nonatomic, strong, readwrite) ReadBookOCController *ocController;
@property (nonatomic, strong, readwrite) ReadBookPRController *prController;

@end

@implementation ReadBookDataSource

- (id)initWithIndexName:(NSString *)indexName readBookVC:(ReadBookViewController *)readBookVC
{
    self = [super init];
    if (self) {
        self.resourceModel = [[ReadBookResourceModel alloc] initWithBookIndexName:indexName];
        self.readBookVC = readBookVC;
        self.ocController = [[ReadBookOCController alloc] init];
        self.ocController.readBookViewController = self.readBookVC;
        
        self.prController = [[ReadBookPRController alloc] init];
        self.prController.readBookViewController = self.readBookVC;
    }
    return self;
}

- (void)ocModelStart
{
    [self.ocController readModelChange];
}

- (void)prModelStart
{
    [self.prController readModelChange];
}

- (void)ocModelEnd
{
    [self.ocController stopPlay];
}

- (void)prModelEnd
{
    [self.prController stopPlay];
}

- (void)setResourceModel:(ReadBookResourceModel *)resourceModel
{
    if (_resourceModel != resourceModel) {
        _resourceModel = resourceModel;
        self.orignalResourceImageArr = [NSMutableArray arrayWithArray:[_resourceModel screenReaderIndexList]];
        self.resourceImageArr = [self.orignalResourceImageArr mutableCopy];
    }
}

- (ReadBookContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return [self viewControllerAtIndex:index readType:READ_NORMAL_MODEL];
}

- (ReadBookContentViewController *)viewControllerAtIndex:(NSUInteger)index readType:(ReadType)readType
{
    if (([self.resourceImageArr count] == 0) || (index >= [self.resourceImageArr count])) {
        return nil;
    }
    ReadBookContentViewController *readBookContentViewController = [[ReadBookContentViewController alloc] init];
    if (readType == READ_NORMAL_MODEL) {
        [readBookContentViewController setViewFrame:self.readBookVC.pageViewController.view.frame];
    }
    else
    {
        [readBookContentViewController setViewFrame:CGRectMake(self.readBookVC.pageViewController.view.frame.origin.x, self.readBookVC.pageViewController.view.frame.origin.y, self.readBookVC.pageViewController.view.frame.size.width/2, self.readBookVC.pageViewController.view.frame.size.height)];
    }
    readBookContentViewController.resourceModel = self.resourceModel;
    readBookContentViewController.contentImageName = self.resourceImageArr[index];
    readBookContentViewController.coupleTag = index;
    readBookContentViewController.readType = readType;
    readBookContentViewController.ocController = self.ocController;
    readBookContentViewController.prController = self.prController;
    if (index == 0) {
        readBookContentViewController.isFirstPage = YES;
    }
    return readBookContentViewController;
}

- (NSUInteger)indexOfViewController:(ReadBookContentViewController *)viewController
{
    if ([viewController.contentImageName rangeOfString:@"0000"].location != NSNotFound) {
        if (viewController.isFirstPage) {
            NSUInteger idx = [self.resourceImageArr indexOfObject:@"blank"];
            if (idx != NSNotFound) {
                return idx;
            }
            return 0;
        }
        else
        {
            return self.resourceImageArr.count - 1;
        }
    }
    return [self.resourceImageArr indexOfObject:viewController.contentImageName];
}

- (NSUInteger)totalCount
{
    return self.resourceImageArr.count;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    return nil;
}

@end

@implementation ReadBookNormalModelSource

- (void)setResourceModel:(ReadBookResourceModel *)resourceModel
{
    [super setResourceModel:resourceModel];
    if ([self.resourceImageArr containsObject:@"blank"]) {
        [self.resourceImageArr removeObject:@"blank"];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(ReadBookContentViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    ReadBookContentViewController *contentViewController = [self viewControllerAtIndex:index];
    BOOL isOCModelEnable = [self.resourceModel isPageOCModelEnable:contentViewController.contentImageName];
    BOOL isPRModelEnable = [self.resourceModel isPagePRModelEnable:contentViewController.contentImageName]&&(index==0);//调整为仅在第一页时可用;
    self.readBookDataSourcePageChangeBlock(index, isOCModelEnable, isPRModelEnable);
    return contentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(ReadBookContentViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.resourceImageArr count]) {
        return nil;
    }
    ReadBookContentViewController *contentViewController = [self viewControllerAtIndex:index];
    BOOL isOCModelEnable = [self.resourceModel isPageOCModelEnable:contentViewController.contentImageName];
    BOOL isPRModelEnable = [self.resourceModel isPagePRModelEnable:contentViewController.contentImageName]&&(index==0);//调整为仅在第一页时可用;
    self.readBookDataSourcePageChangeBlock(index, isOCModelEnable, isPRModelEnable);
    return contentViewController;
}
@end

@implementation ReadBookSplitModelSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.coupleCount = 0;
    }
    return self;
}

- (NSArray *)viewControllersCoupleAtIndex:(NSInteger)index
{
    NSMutableArray *temArr = [NSMutableArray array];
    ReadBookContentViewController *firstVC = [self viewControllerAtIndex:index - 1 readType:READ_SPLIT_MODEL];
    if (firstVC) {
        firstVC.coupleTag = index;
        firstVC.readType = self.readType;
        [temArr addObject:firstVC];
    }
    
    ReadBookContentViewController *secondVC = [self viewControllerAtIndex:index readType:READ_SPLIT_MODEL];
    if (secondVC) {
        secondVC.coupleTag = index;
        secondVC.readType = self.readType;
        [temArr addObject:secondVC];
    }
    return temArr;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(ReadBookContentViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    
    ReadBookContentViewController *contentViewController = [self viewControllerAtIndex:index readType:self.readType];
    contentViewController.coupleTag = index + self.coupleCount;
    self.coupleCount += 1;
    if (self.coupleCount == 2) {
        self.coupleCount = 0;
    }
    BOOL isOCModelEnable = [self.resourceModel isPageOCModelEnable:contentViewController.contentImageName];
    BOOL isPRModelEnable = [self.resourceModel isPagePRModelEnable:contentViewController.contentImageName]&&(index==0);//调整为仅在第一页时可用;
    self.readBookDataSourcePageChangeBlock(index, isOCModelEnable, isPRModelEnable);
    return contentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(ReadBookContentViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    
    ReadBookContentViewController *contentViewController = [self viewControllerAtIndex:index readType:self.readType];
    contentViewController.coupleTag = index - self.coupleCount;
    
    self.coupleCount += 1;
    if (self.coupleCount >= 2) {
        self.coupleCount = 0;
    }
    if (index == [self.resourceImageArr count]) {
        return nil;
    }
    BOOL isOCModelEnable = [self.resourceModel isPageOCModelEnable:contentViewController.contentImageName];
    BOOL isPRModelEnable = [self.resourceModel isPagePRModelEnable:contentViewController.contentImageName]&&(index==0);//调整为仅在第一页时可用;
    self.readBookDataSourcePageChangeBlock(index, isOCModelEnable, isPRModelEnable);
    return contentViewController;
}
@end
