//
//  HBManageTaskEntity.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/7.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBManageTaskEntity : NSObject

@property (nonatomic, strong)NSString *bookName;
@property (nonatomic, strong)NSString *className;
@property (nonatomic, strong)NSString *taskTime;
@property (nonatomic, strong)NSString *fileId;
@property (nonatomic, assign)NSInteger submitted;
@property (nonatomic, assign)NSInteger total;
@property (nonatomic, assign)NSInteger examId;

@end
