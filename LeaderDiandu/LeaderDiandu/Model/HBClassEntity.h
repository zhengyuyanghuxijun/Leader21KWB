//
//  HBClassEntity.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/10.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBClassEntity : NSObject

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *createdTime;
@property (nonatomic, assign)NSInteger booksetId;
@property (nonatomic, assign)NSInteger classId;
@property (nonatomic, assign)NSInteger stuCount;

@end
