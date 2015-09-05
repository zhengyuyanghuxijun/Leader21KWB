//
//  HBModelConst.h
//  LeaderDiandu
//
//  Created by xijun on 15/8/30.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#ifndef LeaderDiandu_HBModelConst_h
#define LeaderDiandu_HBModelConst_h

#define KWBAppKey       @"app_key"
#define KAppKeyStudy    @"a8cffcee338038dd35d9e81ad93540d9c1b13e5d"
#define KAppKeyKWB      @"3164809f635225668555a168d42b8f4c908aa02e"

typedef void(^HBFailureBlock)(NSError *error);

typedef void(^HBHTTPReqCompletionBlock)(id responseObject, NSError *error);

typedef NS_ENUM(NSInteger, HBHTTPRequestType){
    
    HBHTTPRequestMethodGET = 0,
    HBHTTPRequestMethodPOST,
    HBHTTPRequestMethodUPLOAD,
    HBHTTPRequestMethodDOWNLOAD
};

typedef enum : NSUInteger {
    HBRequestSmsByRegister = 1,
    HBRequestSmsByModifyPwd,
    HBRequestSmsByForgetPwd,
    HBRequestSmsByBindPhone,
} HBRequestSmsType;

#endif
