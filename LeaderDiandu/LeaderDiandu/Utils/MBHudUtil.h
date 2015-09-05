//
//  MBHudUtil.h
//  magicEnglish
//
//  Created by libin.tian on 1/6/14.
//  Copyright (c) 2014 ilovedev.com. All rights reserved.
//

#import <Foundation/Foundation.h>


#define Http_ErrorMsgDisplay_Interval 1.5f


@interface MBHudUtil : NSObject

+ (void)showActivityView:(NSString *)text
                  inView:(UIView *)view;

+ (void)hideActivityView:(UIView *)view;

+ (void)showFinishActivityView:(NSString *)text;

+ (void)showFinishActivityView:(NSString *)text
                        inView:(UIView *)view;

+ (void)showFinishActivityView:(NSString *)text
                      interval:(NSTimeInterval)time;

+ (void)showFinishActivityView:(NSString *)text
                      interval:(NSTimeInterval)time
                        inView:(UIView *)view;

+ (void)showFailedActivityView:(NSString *)text;

+ (void)showFailedActivityView:(NSString *)text
                        inView:(UIView *)view;

+ (void)showFailedActivityView:(NSString *)text
                      interval:(NSTimeInterval)time;

+ (void)showFailedActivityView:(NSString *)text
                      interval:(NSTimeInterval)time
                        inView:(UIView *)view;

+ (void)showTextView:(NSString *)text
              inView:(UIView *)view;

+ (void)showTextAlert:(NSString*)msg;

@end
