//
//  HBExamEntity.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/11/7.
//  Copyright © 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBExamEntity : NSObject

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *display_name;
@property (nonatomic, assign)NSInteger total_count;
@property (nonatomic, assign)NSInteger submitted_count;

@end
