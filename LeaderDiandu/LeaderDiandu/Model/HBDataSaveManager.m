//
//  HBDataSaveManager.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/1.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBDataSaveManager.h"
#import "AFNetworkReachabilityManager.h"

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

- (id)init
{
    self = [super init];
    if (self) {
        self.wifiDownload = YES;
        self.vipBookDic = [[NSMutableDictionary alloc] init];
        
        self.freeBookIDArr = @[@"5,6,10,12,16,17", @"104,105,106,107,108,111,114", @"164,180,210,212,213,215", @"326,327,328,330,331,332", @"419,421,423,424,425,427,437,438", @"467,491,505,513,529,530,532,533,534", @"625,627,630,634,641,648", @"691,692,694,697,705,710,716,722,724", @"689,709,711,712,834,835"];
    }
    return self;
}

- (void)saveDefaultUser:(NSDictionary *)dict
{
#if KSaveDefaultUser
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:dict forKey:KWBDefaultUser];
    [userDefault synchronize];
#endif
}

- (void)setUserEntityByDict:(NSDictionary *)dict
{
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    if (newDict[@"token"] == nil) {
        newDict[@"token"] = _userEntity.token;
    }
    [self saveUserByDict:newDict pwd:self.userEntity.pwd];
}

- (void)updateDisplayName:(NSDictionary *)dict
{
    self.userEntity.display_name = dict[@"display_name"];
#if KSaveDefaultUser
    NSDictionary *userDict = [self loadUser];
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:userDict];
    mutDict[@"display_name"] = dict[@"display_name"];
    [self saveDefaultUser:mutDict];
#endif
}

- (void)updatePhoneByStr:(NSString *)phone
{
    self.userEntity.phone = phone;
#if KSaveDefaultUser
    NSDictionary *userDict = [self loadUser];
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:userDict];
    mutDict[@"phone"] = phone;
    [self saveDefaultUser:mutDict];
#endif
}

- (void)saveDefaultAccount:(NSString *)user pwd:(NSString *)pwd
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:user forKey:KWBDefaultUser];
    [dic setObject:pwd forKey:KWBDefaultPwd];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:dic forKey:KWBDefaultAccount];
    [userDefault synchronize];
}

- (NSDictionary *)loadDefaultAccount
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefault objectForKey:KWBDefaultAccount];
    return dict;
}

- (void)saveUserByDict:(NSDictionary *)dict pwd:(NSString *)pwd
{
    NSInteger subscribeId = self.userEntity.subscribeId;
    self.userEntity = [[HBUserEntity alloc] initWithDictionary:dict];
    self.userEntity.pwd = pwd;
    self.userEntity.subscribeId = subscribeId;
    
#if KSaveDefaultUser
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dict];
    [newDic setValue:pwd forKey:@"pwd"];
    id phone = newDic[@"phone"];
    if ([phone isKindOfClass:[NSNull class]]) {
        [newDic setValue:@"" forKey:@"phone"];
    }
    NSDictionary *director = [newDic dicForKey:@"director"];
    if (director) {
        NSMutableDictionary *directorNew = [NSMutableDictionary dictionaryWithDictionary:director];
        id phone = directorNew[@"phone"];
        if ([phone isKindOfClass:[NSNull class]]) {
            [directorNew setValue:@"" forKey:@"phone"];
        }
        [newDic setValue:directorNew forKey:@"director"];
    }
    
    [self saveDefaultUser:newDic];
#endif
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
    self.userEntity = nil;
//    self.vipBookDic = nil;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:KWBDefaultUser];
    [userDefault removeObjectForKey:KWBDefaultAccount];
    [userDefault synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_LoginOut object:nil];
}

- (void)saveSettingsByDict:(NSDictionary *)dict
{
    NSString *wifiDownloadStr = [dict objectForKey:@"wifidownload"];
    NSString *showEnBookNameStr = [dict objectForKey:@"showenbookname"];
    
    self.wifiDownload = [wifiDownloadStr boolValue];
    self.showEnBookName = [showEnBookNameStr boolValue];
    
    NSString *settingDataKey = [NSString stringWithFormat:@"%@"@"_"@"%ld", KHBSettingData, (long)self.userEntity.userid];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:dict forKey:settingDataKey];
    [userDefault synchronize];
}

- (void)loadSettings
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *settingDataKey = [NSString stringWithFormat:@"%@"@"_"@"%ld", KHBSettingData, (long)self.userEntity.userid];
    NSDictionary *dict = [userDefault objectForKey:settingDataKey];
    
    NSString *wifiDownloadStr = [dict objectForKey:@"wifidownload"];
    NSString *showEnBookNameStr = [dict objectForKey:@"showenbookname"];
    
    if (wifiDownloadStr) {
        self.wifiDownload = [wifiDownloadStr boolValue];
    }
    self.showEnBookName = [showEnBookNameStr boolValue];
    
    myAppDelegate.hasNewMsg = NO;
    myAppDelegate.hasNewExam = NO;
}

- (void)saveFirstLogin
{
    NSString *firstLoginKey = [NSString stringWithFormat:@"%@"@"_"@"%ld", KHBFirstLogin, (long)self.userEntity.userid];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"YES" forKey:firstLoginKey];
    [userDefault synchronize];
}

- (void)loadFirstLogin
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *firstLoginKey = [NSString stringWithFormat:@"%@"@"_"@"%ld", KHBFirstLogin, (long)self.userEntity.userid];
    NSString *firstLoginStr = [userDefault objectForKey:firstLoginKey];

    self.notFirstLogin = [firstLoginStr boolValue];
}

-(void)addObserverNet
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - 更新网络
- (void)networkStateChange
{
//    NSString *state = [self getNetWorkStates];
    
    [self isNetworkEnable];
}

- (BOOL)isNetworkEnable
{
    BOOL flag = YES;
    AFNetworkReachabilityStatus state=  [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    switch (state) {
        case AFNetworkReachabilityStatusNotReachable:
            flag = NO;
            NSLog(@"没网络");
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:;{
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
//            NSLog(@"WiFi网络");
            break;
        default:
            break;
    }
    return flag;
}

- (NSString *)getNetWorkStates
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    
    NSString *state = [[NSString alloc] init];
    int netType = 0;
    
    //获取到网络返回码
    for (id child in children) {
        
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            switch (netType) {
                case 0:
                    //无网模式
                    state = @"无网络";
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                    state = @"WIFI";
                    break;
                default:
                    break;
            }
        }
    }
    
    return state;
}

@end
