//
//  HBSystemMsgEntity.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/7.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBSystemMsgEntity : NSObject

@property (nonatomic, strong)NSNumber *systemMsgId;
@property (nonatomic, strong)NSString *user_id;
@property (nonatomic, strong)NSString *type;
@property (nonatomic, strong)NSString *subject;
@property (nonatomic, strong)NSString *body;
@property (nonatomic, strong)NSString *created_time;

@end
