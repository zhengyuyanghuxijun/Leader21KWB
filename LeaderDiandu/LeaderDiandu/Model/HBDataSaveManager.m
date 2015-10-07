//
//  HBDataSaveManager.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/1.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBDataSaveManager.h"

@implementation HBDataSaveManager

+ (id)defaultManager
{
    static HBDataSaveManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HBDataSaveManager alloc] init];
    });
    return manager;
}

- (void)setUserEntityByDict:(NSDictionary *)dict
{
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    if (newDict[@"token"] == nil) {
        newDict[@"token"] = _userEntity.token;
    }
    [self saveUserByDict:newDict];
}

- (void)updateDisplayName:(NSDictionary *)dict
{
    self.userEntity.display_name = dict[@"display_name"];
    NSDictionary *userDict = [self loadUser];
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:userDict];
    mutDict[@"display_name"] = dict[@"display_name"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:mutDict forKey:KWBDefaultUser];
    [userDefault synchronize];
}

- (void)saveUserByDict:(NSDictionary *)dict
{
    self.userEntity = [[HBUserEntity alloc] initWithDictionary:dict];
    
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dict];
    id phone = newDic[@"phone"];
    if ([phone isKindOfClass:[NSNull class]]) {
        [newDic setValue:@"" forKey:@"phone"];
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:newDic forKey:KWBDefaultUser];
    [userDefault synchronize];
}

- (NSDictionary *)loadUser
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefault objectForKey:KWBDefaultUser];
    self.userEntity = [[HBUserEntity alloc] initWithDictionary:dict];
    return dict;
}

- (void)clearUserData
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:KWBDefaultUser];
    [userDefault synchronize];
}

- (void)saveSettingsByDict:(NSDictionary *)dict
{
    NSString *wifiDownloadStr = [dict objectForKey:@"wifidownload"];
    NSString *showEnBookNameStr = [dict objectForKey:@"showenbookname"];
    
    self.wifiDownload = [wifiDownloadStr boolValue];
    self.showEnBookName = [showEnBookNameStr boolValue];
    
    NSString *settingDataKey = [NSString stringWithFormat:@"%@"@"_"@"%ld", KHBSettingData,self.userEntity.userid];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:dict forKey:settingDataKey];
    [userDefault synchronize];
}

- (void)loadSettings
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *settingDataKey = [NSString stringWithFormat:@"%@"@"_"@"%ld", KHBSettingData,self.userEntity.userid];
    NSDictionary *dict = [userDefault objectForKey:settingDataKey];
    
    NSString *wifiDownloadStr = [dict objectForKey:@"wifidownload"];
    NSString *showEnBookNameStr = [dict objectForKey:@"showenbookname"];
    
    self.wifiDownload = [wifiDownloadStr boolValue];
    self.showEnBookName = [showEnBookNameStr boolValue];
}

@end
