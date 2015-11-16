//
//  HBDataSaveManager.h
//  LeaderDiandu
//
//  Created by xijun on 15/9/1.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBUserEntity.h"

#define KWBDefaultUser      @"KWBDefaultUser"
#define KHBSettingData      @"KHBSettingData"
#define KHBFirstLogin       @"KHBFirstLogin"

@interface HBDataSaveManager : NSObject

@property (nonatomic, strong)HBUserEntity *userEntity;

@property (nonatomic, assign)BOOL wifiDownload; //仅在wifi下下载
@property (nonatomic, assign)BOOL showEnBookName;   //显示英文书名
@property (nonatomic, assign)BOOL notFirstLogin;   //是否首次登录(NO：首次登录 YES：非首次登录)

//vip书籍
@property (nonatomic, strong)NSMutableDictionary *vipBookDic;

+ (id)defaultManager;

- (void)setUserEntityByDict:(NSDictionary *)dict;
- (void)updateDisplayName:(NSDictionary *)dict;
- (void)updatePhoneByStr:(NSString *)phone;

- (void)saveUserByDict:(NSDictionary *)dict pwd:(NSString *)pwd;
- (NSDictionary *)loadUser;

- (void)saveSettingsByDict:(NSDictionary *)dict;
- (void)loadSettings;

- (void)saveFirstLogin;
- (void)loadFirstLogin;

- (void)clearUserData;

@end
