//
//  HBCreatGroupController.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/15.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBBaseViewController.h"

@protocol CreatGroupDelegate <NSObject>

- (void)creatGroupComplete;

@end

@interface HBCreatGroupController : HBBaseViewController

@property (weak, nonatomic) id <CreatGroupDelegate> delegate;

@end
