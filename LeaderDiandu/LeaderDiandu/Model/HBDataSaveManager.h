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
@property (nonatomic, assign)BOOL firstLogin;   //是否首次登录

+ (id)defaultManager;

- (void)setUserEntityByDict:(NSDictionary *)dict;
- (void)updateDisplayName:(NSDictionary *)dict;

- (void)saveUserByDict:(NSDictionary *)dict;
- (NSDictionary *)loadUser;

- (void)saveSettingsByDict:(NSDictionary *)dict;
- (void)loadSettings;

- (void)saveFirstLogin;
- (void)loadFirstLogin;

- (void)clearUserData;

@end
