//
//  HBContentBaseRequest.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/2.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBContentBaseRequest.h"
#import "AFNetworking.h"

@interface HBContentBaseRequest ()

@property (nonatomic, strong)AFHTTPSessionManager *httpManager;

@property (nonatomic, strong)NSString *subURLString;

@property (nonatomic, copy) HBHTTPReqCompletionBlock completionBlock;

@end

@implementation HBContentBaseRequest

-(AFHTTPSessionManager *)httpManager{
    
    _httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:CONTENTAPI]];
    //添加http头
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    [_httpManager.requestSerializer setValue:identifier forHTTPHeaderField:@"X-Requested-By"];
    
    //when the reponse type is "text/html",AF will be error,so need to set responseSerialier
    _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/x-javascript",@"application/json", nil];
    return _httpManager;
}

+(instancetype)requestWithSubUrl:(NSString *)url
{
    HBContentBaseRequest *instance = [[[self class] alloc] init];
    instance.subURLString = url;
    return instance;
}

-(void)handleRequestResponseWithData:(id)responseObject
{
    if ([responseObject[@"status"] integerValue] == 1) {    //success
        
        self.completionBlock(responseObject,nil);
    } else {
        NSInteger error_code = [responseObject[@"status"] integerValue];
        NSError *error = [NSError errorWithDomain:@"HBHTTPRequestError"
                                             code:error_code
                                         userInfo: (NSDictionary *)responseObject //@{NSLocalizedDescriptionKey:responseObject[@"info"]}
                          ];
        
        self.completionBlock(responseObject, error);
    }
}

-(void)startWithMethod:(HBHTTPRequestType)methodType
            parameters:(id)param
            completion:(HBHTTPReqCompletionBlock)completionBlock
{
    self.completionBlock = completionBlock;
    
    if (methodType == HBHTTPRequestMethodPOST) {
        
        [self.httpManager POST:self.subURLString
                    parameters:param
                       success:^(NSURLSessionDataTask *task, id responseObject) {
                           [self handleRequestResponseWithData:responseObject];
                           
                       } failure:^(NSURLSessionDataTask *task, NSError *error) {
                           if (completionBlock) {
                               self.completionBlock(nil,error);
                           }
                       }];
        
    }
    else if (methodType == HBHTTPRequestMethodGET) {
        
        [self.httpManager GET:self.subURLString
                   parameters:param
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                          
                          [self handleRequestResponseWithData:responseObject];
                          
                      } failure:^(NSURLSessionDataTask *task, NSError *error) {
                          
                          if (completionBlock) {
                              completionBlock(nil,error);
                          }
                      }];
    }
}

@end
