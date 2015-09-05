//
//  DHSlideMenuViewController.h
//  ByqIOSApps
//
//  Created by DumbbellYang on 14/11/28.
//  Copyright (c) 2014年 DumbbellYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHSlideMenuViewController : UITableViewController

@property (nonatomic, strong) NSString *headerName;
@property (nonatomic, strong) NSString *headerPhone;
@property (nonatomic, strong) NSString *headerClassName;

//添加菜单项切换的TabBarControllers
- (id)initWithMenus:(NSArray *)titles MenuImages:(NSArray *)images TabBarControllers:(NSArray*)controllers;

@end
