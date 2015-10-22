//
//  HBExamAbilityEntity.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/23.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBExamAbilityEntity : NSObject

@property (nonatomic, strong)NSString *ability;
@property (nonatomic, assign)NSInteger total;
@property (nonatomic, assign)NSInteger correct;
@property (nonatomic, strong)NSString *tag;

@end
