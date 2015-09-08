//
//  HBStudentEntity.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/8.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBStudentEntity : NSObject

@property (nonatomic, strong)NSString *displayName;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *phone;
@property (nonatomic, strong)NSString *vipTime;
@property (nonatomic, assign)NSInteger classId;
@property (nonatomic, assign)NSInteger studentId;
@property (nonatomic, assign)NSInteger gender;
@property (nonatomic, assign)NSInteger type;

@end
