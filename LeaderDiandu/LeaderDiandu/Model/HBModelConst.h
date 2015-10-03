//
//  HBModelConst.h
//  LeaderDiandu
//
//  Created by xijun on 15/8/30.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#ifndef LeaderDiandu_HBModelConst_h
#define LeaderDiandu_HBModelConst_h

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
    HBRequestSmsByForgetPwd,//废弃
    HBRequestSmsByBindPhone,
} HBRequestSmsType;

#endif
