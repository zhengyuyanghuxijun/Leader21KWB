//
//  HBGroupSelectViewController.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/9.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBaseViewController.h"
#import "HBClassEntity.h"

@protocol HBGroupSelectViewDelegate <NSObject>

- (void)selectedGroup:(HBClassEntity *)classEntity;

@end

@interface HBGroupSelectViewController : HBBaseViewController

@property(nonatomic,weak) id <HBGroupSelectViewDelegate> delegate;

@end
