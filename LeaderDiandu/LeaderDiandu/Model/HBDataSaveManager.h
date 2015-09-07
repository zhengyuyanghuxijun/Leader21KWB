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

@interface HBDataSaveManager : NSObject

@property (nonatomic, strong)HBUserEntity *userEntity;

+ (id)defaultManager;

- (void)setUserEntityByDict:(NSDictionary *)dict;
- (void)updateDisplayName:(NSDictionary *)dict;

- (void)saveUserByDict:(NSDictionary *)dict;
- (NSDictionary *)loadUser;

- (void)clearUserData;

@end
