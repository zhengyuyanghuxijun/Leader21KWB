//
//  DHSlideMenuViewController.h
//  ByqIOSApps
//
//  Created by DumbbellYang on 14/11/28.
//  Copyright (c) 2014年 DumbbellYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBBaseViewController.h"

//@interface DHSlideMenuViewController : UITableViewController
@interface DHSlideMenuViewController : HBBaseViewController
{
    UITableView *_tableView;
}

@property (nonatomic, strong) NSString *headerClassName;
@property (nonatomic, assign) NSInteger viewWidth;

//添加菜单项切换的TabBarControllers
- (void)setMenus:(NSArray *)titles MenuImages:(NSArray *)images TabBarControllers:(NSArray*)controllers;

@end
