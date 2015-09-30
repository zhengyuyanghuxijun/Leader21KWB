//
//  HBTaskEntity.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/5.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBTaskEntity : NSObject

@property (nonatomic, strong)NSString *bookName;
@property (nonatomic, strong)NSString *teacherName;
@property (nonatomic, strong)NSString *createdTime;
@property (nonatomic, strong)NSString *modifiedTime;
@property (nonatomic, strong)NSString *score;
@property (nonatomic, strong)NSString *fileId;

@property (nonatomic, assign)NSInteger bookId;
@property (nonatomic, assign)NSInteger exam_id;

@end
