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
    HBUserEntity *entity = [[HBUserEntity alloc] initWithDictionary:dict];
    if (entity.token == nil) {
        entity.token = self.userEntity.token;
    }
    self.userEntity = entity;
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
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:dict forKey:KWBDefaultUser];
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

@end
