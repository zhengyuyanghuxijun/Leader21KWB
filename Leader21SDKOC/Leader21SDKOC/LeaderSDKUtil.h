//
//  LeaderSDKUtil.h
//  Leader21SDKOC
//
//  Created by xijun on 15/9/19.
//  Copyright (c) 2015年 leader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadEntity.h"

@interface LeaderSDKUtil : NSObject

+ (instancetype)defaultSDKUtil;

-(DownloadEntity *)queryEntityByUrl:(NSString *)url;

@end
