//
//  HBHTTPBaseRequest.h
//  LeaderDiandu
//
//  Created by hxj on 15/8/21.
//
//

#import <Foundation/Foundation.h>
#import "HBModelConst.h"

@interface HBHTTPBaseRequest : NSObject

+ (instancetype)requestWithSubUrl:(NSString *)url;

- (void)startWithMethod:(HBHTTPRequestType)methodType parameters:(id)param completion:(HBHTTPReqCompletionBlock)completionBlock;

@end
