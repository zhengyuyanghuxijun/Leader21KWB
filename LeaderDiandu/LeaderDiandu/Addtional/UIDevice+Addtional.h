//
//  UIDevice+Addtional.h
//
//
//  Created by TLB.
//  Copyright (c) 2012年 ilovedev.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Addtional)

// 是否是iPhone
+ (BOOL)isiPhone;

// 是否是iPad
+ (BOOL)isiPad;

// 是否是iTouch
+ (BOOL)isiPodTouch;

- (BOOL)hasMultitasking;

- (BOOL)isIphone5;

- (NSString *)platformString;

// 支持拔打电话
+ (BOOL)supportTelephone;

// 支持发送短信
+ (BOOL)supportSendSMS;

// 支持发送邮件
+ (BOOL)supportSendMail;

// 支持摄像头取景
+ (BOOL)supportCamera;

// 以全小写的形式返回设备名称
- (NSString*)modelNameLowerCase;

// 系统版本，以float形式返回
- (CGFloat)systemVersionByFloat;

// 系统版本比较
- (BOOL)systemVersionLowerThan:(NSString*)version;
- (BOOL)systemVersionNotHigherThan:(NSString *)version;
- (BOOL)systemVersionHigherThan:(NSString*)version;
- (BOOL)systemVersionNotLowerThan:(NSString *)version;

- (NSString *) macaddress;

- (NSString *) deviceIdentifier;


// 内存信息
+ (unsigned int)freeMemory;
+ (unsigned int)usedMemory;

@end
