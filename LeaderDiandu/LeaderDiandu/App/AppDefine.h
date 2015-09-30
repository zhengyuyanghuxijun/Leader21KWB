//
//  AppDefine.h
//  LeaderDiandu
//
//  Created by xijun on 15/10/1.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#ifndef LeaderDiandu_AppDefine_h
#define LeaderDiandu_AppDefine_h


#define SYSTEM_VERSION ([[UIDevice currentDevice].systemVersion floatValue])


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define isRetina ([[UIScreen mainScreen] scale] > 1.0 ? YES : NO)

#define FETION_APP_DELEGATE ((FetionAppDelegate *)[UIApplication sharedApplication].delegate)


#define KLeaderRGB [UIColor colorWithHex:0xff8903]

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]

//适用于RGB颜色相同的场景
#define RGBEQ(rgb) [UIColor colorWithRed:rgb/255.0 green:rgb/255.0 blue:rgb/255.0 alpha:1.0f]

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define RGBEQA(rgb,a) [UIColor colorWithRed:rgb/255.0 green:rgb/255.0 blue:rgb/255.0 alpha:a]


#endif
