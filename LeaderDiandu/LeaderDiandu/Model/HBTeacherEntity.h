//
//  HBTeacherEntity.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/25.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBTeacherEntity : NSObject

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *display_name;
@property (nonatomic, strong)NSString *associate_time;
@property (nonatomic, assign)NSInteger total;
@property (nonatomic, assign)NSInteger vip;

@end
