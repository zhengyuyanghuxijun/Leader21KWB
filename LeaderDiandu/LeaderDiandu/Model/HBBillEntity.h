//
//  HBBillEntity.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/12.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBBillEntity : NSObject

//1-支付宝；2-微信支付；3-VIP码支付
@property (nonatomic, strong)NSString *type;
@property (nonatomic, strong)NSString *subject;
@property (nonatomic, strong)NSString *body;
@property (nonatomic, strong)NSString *created_time;
//0-未支付；1-已支付
@property (nonatomic, strong)NSString *status;

@end
