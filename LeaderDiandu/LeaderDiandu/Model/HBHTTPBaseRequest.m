//
//  HBHTTPBaseRequest.m
//  LeaderDiandu
//
//  Created by hxj on 15/8/21.
//
//

#import "HBHTTPBaseRequest.h"
#import "AFNetworking.h"

#define SERVICEAPI  @"http://teach.61dear.cn:9080"

@interface HBHTTPBaseRequest ()

@property (nonatomic, strong)AFHTTPSessionManager *httpManager;

@property (nonatomic, strong)NSString *subURLString;

@property (nonatomic, copy) HBHTTPReqCompletionBlock completionBlock;

@end

@implementation HBHTTPBaseRequest

-(AFHTTPSessionManager *)httpManager{
    
    _httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SERVICEAPI]];
    //添加http头
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    [_httpManager.requestSerializer setValue:identifier forHTTPHeaderField:@"X-Requested-By"];
    
    //when the reponse type is "text/html",AF will be error,so need to set responseSerialier
    _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/x-javascript",@"application/json", nil];
    return _httpManager;
}

+(instancetype)requestWithSubUrl:(NSString *)url
{
    HBHTTPBaseRequest *instance = [[[self class] alloc] init];
    instance.subURLString = url;
    return instance;
}

-(void)handleRequestResponseWithData:(id)responseObject
{
    if (responseObject) {    //success
        self.completionBlock(responseObject, nil);
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
