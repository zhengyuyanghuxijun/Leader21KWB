//
//  HBReadprogressEntity.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/25.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBaseEntity.h"

@interface HBReadprogressEntity : HBBaseEntity

@property (nonatomic, strong)NSString   *book_id;
@property (nonatomic, strong)NSString   *progress;
@property (nonatomic, assign)BOOL       exam_assigned;

@end
