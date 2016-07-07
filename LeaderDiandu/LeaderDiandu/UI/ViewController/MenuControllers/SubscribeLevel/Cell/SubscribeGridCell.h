//
//  SubscribeGridCell.h
//  HBGridView
//
//  Created by zhengyuyang on 16-6-14.
//  Copyright (c) 2012年 tt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextGridCell.h"

@interface SubscribeGridCell : TextGridCell

//更新订阅图标和等级按钮
-(void)updateSubscribeImgView:(BOOL)isSubscribed
                  levelButton:(BOOL)isCurrentSelectIndex
                        index:(NSString *)index;

@end