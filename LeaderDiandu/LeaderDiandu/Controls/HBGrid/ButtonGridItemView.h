//
//  ButtonGridItemView.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/4.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBGridItemView.h"

@interface ButtonGridItemView : HBGridItemView

//更新订阅图标和等级按钮
-(void)updateSubscribeImgView:(BOOL)isSubscribed
                  levelButton:(BOOL)isCurrentSelectIndex
                        index:(NSString *)index;

@end
