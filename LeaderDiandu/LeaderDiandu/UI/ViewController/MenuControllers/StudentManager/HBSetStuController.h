//
//  HBSetStuController.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/16.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBaseViewController.h"
#import "HBSetStuGroupCell.h"
#import "HBSetStuOtherCell.h"

@interface HBSetStuController : HBBaseViewController<UITableViewDataSource, UITableViewDelegate, QuitGroupDelegate, JoinGroupDelegate>
{
    UITableView *_tableView;
}

@property (copy, nonatomic) NSString *titleStr;
@property (assign, nonatomic) NSInteger classId;
@property (strong, nonatomic) NSMutableArray *groupStuArr;
@property (strong, nonatomic) NSMutableArray *otherStuArr;

@property (strong, nonatomic) NSMutableArray *joinGroupArr;

@end
