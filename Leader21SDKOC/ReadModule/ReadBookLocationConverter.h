//
//  ReadBookHelper.h
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-18.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadBookContentViewController.h"

//xml文件坐标场合款系数为宽522 高630

#define XML_X_FACTOR (522.0f)
#define XML_Y_FACTOR (630.0f)

@interface ReadBookLocationConverter : NSObject

+ (CGPoint)locationConverter:(NSString *)iconxy targetView:(UIView *)targetView;
+ (CGPoint)splitLocationConverterPoint:(CGPoint)iconPoint targetView:(UIView *)targetView;
+ (CGPoint)locationConverterPoint:(CGPoint)iconPoint targetView:(UIView *)targetView;
+ (CGSize)sizeConvert:(CGSize)size targetView:(UIView *)targetView;
+ (CGSize)normalSizeConvert:(CGSize)size targetView:(UIView *)targetView;
@end
