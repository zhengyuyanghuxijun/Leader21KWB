//
//  HBContentBaseRequest.h
//  LeaderDiandu
//
//  Created by xijun on 15/9/2.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBModelConst.h"

@interface HBContentBaseRequest : NSObject

+ (instancetype)requestWithSubUrl:(NSString *)url;

- (void)startWithMethod:(HBHTTPRequestType)methodType parameters:(id)param completion:(HBHTTPReqCompletionBlock)completionBlock;

@end
