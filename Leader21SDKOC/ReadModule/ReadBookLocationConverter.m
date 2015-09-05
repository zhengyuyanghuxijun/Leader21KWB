//
//  ReadBookHelper.m
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-18.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookLocationConverter.h"

@implementation ReadBookLocationConverter

+ (CGPoint)locationConverter:(NSString *)iconxy targetView:(UIView *)targetView
{
    NSArray *iconPos = [iconxy componentsSeparatedByString:@","];
    CGPoint locPoint = CGPointMake(-1, -1);
    if (iconPos.count == 2) {
        CGFloat x = [[iconPos objectAtIndex:0] floatValue];
        CGFloat y = [[iconPos objectAtIndex:1] floatValue];
        
        CGFloat cX = (x * targetView.width)/XML_X_FACTOR;
        CGFloat cY = (y * targetView.height)/XML_Y_FACTOR;
        
        locPoint = CGPointMake(cX, cY);
    }
    return locPoint;
}

+ (CGPoint)locationConverterPoint:(CGPoint)iconPoint targetView:(UIView *)targetView
{
    CGFloat x = iconPoint.x;
    CGFloat y = iconPoint.y;
    
    CGFloat cX = (x * targetView.width)/XML_X_FACTOR;
    CGFloat cY = (y * targetView.height)/XML_Y_FACTOR;
    
    return CGPointMake(cX, cY);
}

+ (CGPoint)splitLocationConverterPoint:(CGPoint)iconPoint targetView:(UIView *)targetView
{
    CGFloat x = iconPoint.x;
    CGFloat y = iconPoint.y;
    
    CGFloat cX = (x * targetView.width)/(XML_X_FACTOR * 2);
    CGFloat cY = (y * targetView.height)/(XML_Y_FACTOR);
    
    return CGPointMake(cX, cY);
}

+ (CGSize)normalSizeConvert:(CGSize)size targetView:(UIView *)targetView
{
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CGFloat cWidth = (width * targetView.width)/(XML_X_FACTOR);
    CGFloat cHeight = (height *targetView.height)/XML_Y_FACTOR;
    
    return CGSizeMake(cWidth, cHeight);
}

+ (CGSize)sizeConvert:(CGSize)size targetView:(UIView *)targetView
{
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CGFloat cWidth = (width * targetView.width)/(XML_X_FACTOR * 2);
    CGFloat cHeight = (height *targetView.height)/XML_Y_FACTOR;
    
    return CGSizeMake(cWidth, cHeight);
}

+ (BOOL)compareCGPoint:(CGPoint)point1 withPoint:(CGPoint)point2
{
    if ((point1.x == point2.x) && (point1.y == point2.y)) {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
