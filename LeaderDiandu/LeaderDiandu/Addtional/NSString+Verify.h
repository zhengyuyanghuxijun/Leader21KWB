//
//  NSString+Verify.h
//  MoJing
//
//  Created by Lee on 14/12/3.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Verify)




+ (BOOL)checkTextNULL:(NSString *)string;
+ (NSString *)devicePlatform;
+ (NSString *)getDocumentPath;
+ (NSString *)rsaEncryptStr:(NSString *)keyStr; ////RSA加密字符串
+ (NSString *)stringWithNewUUID;

- (BOOL)isEmail;
- (BOOL)isAvatar;
- (BOOL)isPasswordInput;
- (BOOL)isPhoneNumInput;
- (BOOL)isValidNicknameInput;
- (BOOL)isValidPassword;
- (NSString*) URLEncode;

@end
