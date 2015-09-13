//
//  HBTestSelectViewController.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/13.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBaseViewController.h"
#import "HBContentDetailEntity.h"

@protocol HBTestSelectViewDelegate <NSObject>

- (void)selectedTest:(HBContentDetailEntity *)contentDetailEntity;

@end

@interface HBTestSelectViewController : HBBaseViewController

@property (nonatomic, assign)NSInteger bookset_id;
@property(nonatomic,weak) id <HBTestSelectViewDelegate> delegate;

@end
