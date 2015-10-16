//
//  HBUserEntity.h
//  LeaderDiandu
//
//  Created by xijun on 15/8/30.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBBaseEntity.h"

@interface HBUserEntity : HBBaseEntity

/** 1-普通用户；2-VIP用户；3-VIP过期用户 */
@property (nonatomic, assign)NSInteger account_status;
@property (nonatomic, assign)NSInteger userid;
/** gender 性别， 1-男，2-女 */
@property (nonatomic, assign)NSInteger gender;
/** type: 1 - 学生； 10 - 老师*/
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, strong)NSString *display_name;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *phone;
@property (nonatomic, strong)NSString *pwd;
@property (nonatomic, strong)NSString *token;
@property (nonatomic, assign)NSTimeInterval vip_time;

@property (nonatomic, strong)NSDictionary *myClass;
@property (nonatomic, strong)NSDictionary *teacher;

@end
