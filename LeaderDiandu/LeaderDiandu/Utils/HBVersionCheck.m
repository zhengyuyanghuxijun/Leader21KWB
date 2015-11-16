//
//  HBVersionCheck.m
//  LeaderDiandu
//
//  Created by xijun on 15/11/9.
//  Copyright © 2015年 hxj. All rights reserved.
//

#import "HBVersionCheck.h"

@interface HBVersionCheck ()<UIAlertViewDelegate>

@end

@implementation HBVersionCheck

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - 实现升级功能

//检测软件是否需要升级
- (void)checkVersion
{
    NSString *newVersion;
    NSURL *url = [NSURL URLWithString:kAppLookupUrl];
    
    //通过url获取数据
    NSString *jsonResponseString =   [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"通过appStore获取的数据是：%@",jsonResponseString);
    
    //解析json数据为数据字典
    NSDictionary *loginAuthenticationResponse = [self dictionaryFromJsonFormatOriginalData:jsonResponseString];
    
    //从数据字典中检出版本号数据
    NSArray *configData = [loginAuthenticationResponse valueForKey:@"results"];
    for(id config in configData)
    {
        newVersion = [config valueForKey:@"version"];
    }
    
    NSLog(@"通过appStore获取的版本号是：%@",newVersion);
    
    //获取本地软件的版本号
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *mainVersion = [dict objectForKey:@"CFBundleShortVersionString"];
    NSString *buildVersion = [dict objectForKey:@"CFBundleVersion"];
    NSString *localVersion = [NSString stringWithFormat:@"%@.%@", mainVersion, buildVersion];
    
    NSString *msg = [NSString stringWithFormat:@"你当前的版本是V%@，发现新版本V%@，是否下载新版本？",localVersion,newVersion];
    
    //对比发现的新版本和本地的版本
    if ([newVersion floatValue] > [localVersion floatValue])
    {
        UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:@"升级提示!" message:msg delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles: @"现在升级", nil];
        [createUserResponseAlert show];
    }
}

//响应升级提示按钮
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //如果选择“现在升级”
    if (buttonIndex == 1)
    {
        //打开iTunes  方法一
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreUrl]];
        
        /*
         // 打开iTunes 方法二:此方法总是提示“无法连接到itunes”，不推荐使用
         NSString *iTunesLink = @"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=692579125&mt=8";
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
         */
    }
}

#pragma mark - 辅助方法：将json 格式的原始数据转解析成数据字典
//将json 格式的原始数据转解析成数据字典
-(NSMutableDictionary *)dictionaryFromJsonFormatOriginalData:(NSString *)str
{
    if (str == nil) {
        return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *tempDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    return tempDictionary;
}

@end
