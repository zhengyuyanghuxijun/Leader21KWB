//
//  HBSetStuController.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/16.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBaseViewController.h"

@interface HBSetStuController : HBBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (copy, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSMutableArray *groupStuArr;
@property (strong, nonatomic) NSMutableArray *otherStuArr;

@end
