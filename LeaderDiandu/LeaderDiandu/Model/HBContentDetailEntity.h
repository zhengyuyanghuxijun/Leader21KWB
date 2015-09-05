//
//  HBContentDetailEntity.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/2.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBaseEntity.h"

@interface HBContentDetailEntity : HBBaseEntity

@property (nonatomic, strong)NSString *BOOK_LEVEL;
@property (nonatomic, strong)NSString *BOOK_SRNO;
@property (nonatomic, strong)NSString *BOOK_TITLE;
@property (nonatomic, strong)NSString *BOOK_TITLE_CN;
@property (nonatomic, strong)NSString *BOOK_TYPE;
@property (nonatomic, strong)NSString *FILE_ID;
@property (nonatomic, strong)NSString *GRADE;
@property (nonatomic, assign)NSInteger ID;
@property (nonatomic, assign)NSInteger UNIT;

//- (NSString *)getBookImageUrl;

@end
