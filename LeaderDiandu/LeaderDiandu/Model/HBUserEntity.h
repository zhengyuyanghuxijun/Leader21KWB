//
//  HBUserEntity.h
//  LeaderDiandu
//
//  Created by xijun on 15/8/30.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBBaseEntity.h"

@interface HBUserEntity : HBBaseEntity

@property (nonatomic, assign)NSInteger userid;
@property (nonatomic, assign)NSInteger gender;/** gender 性别， 1-男，2-女 */
@property (nonatomic, assign)NSInteger type;/** type: 1 - 学生； 10 - 老师*/
@property (nonatomic, strong)NSString *display_name;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *phone;
@property (nonatomic, strong)NSString *token;

@property (nonatomic, strong)NSDictionary *myClass;
@property (nonatomic, strong)NSDictionary *teacher;

@end
