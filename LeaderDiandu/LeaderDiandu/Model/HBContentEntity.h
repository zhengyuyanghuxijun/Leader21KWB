//
//  HBContentEntity.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/2.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBaseEntity.h"

@interface HBContentEntity : HBBaseEntity

@property (nonatomic, assign)NSInteger bookId;
@property (nonatomic, assign)NSInteger total;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *description;
@property (nonatomic, strong)NSString *books;
@property (nonatomic, strong)NSString *free_books;
@property (nonatomic, strong)NSString *assigned_books;
@property (nonatomic, assign)BOOL subscribed;
@property (nonatomic, assign)BOOL sub_status;


@end
