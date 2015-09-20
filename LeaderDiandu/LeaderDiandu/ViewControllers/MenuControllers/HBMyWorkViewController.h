//
//  HBMyWorkViewController.h
//  LeaderDiandu
//
//  Created by xijun on 15/9/20.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBBaseViewController.h"

@class HBTestWorkManager;
@class HBTaskEntity;

@interface HBMyWorkViewController : HBBaseViewController

@property (nonatomic ,strong)HBTaskEntity *taskEntity;
@property (nonatomic, strong)HBTestWorkManager *workManager;

@end
