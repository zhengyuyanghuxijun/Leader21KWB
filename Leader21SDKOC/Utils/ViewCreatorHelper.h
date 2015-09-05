//
//  ViewCreatorHelper.h
//  RenrenOfficial-iOS-Concept
//
//  Created by 田立彬 on 13-5-29.
//  Copyright (c) 2013年 . All rights reserved.
//

#import <Foundation/Foundation.h>


@class RTLabel1;
@class SevenSwitch;


@interface ViewCreatorHelper : NSObject


+ (UIButton*)createButtonWithTitle:(NSString*)title
                             frame:(CGRect)frame
                        normaImage:(NSString*)normalImageKey
                    highlitedImage:(NSString*)highlitedImageKey
                      disableImage:(NSString*)disableImageKey
                            target:(id)target
                            action:(SEL)action;

+ (UIButton*)createIconButtonWithFrame:(CGRect)frame
                            normaImage:(NSString*)normalImageKey
                        highlitedImage:(NSString*)highlitedImageKey
                          disableImage:(NSString*)disableImageKey
                                target:(id)target
                                action:(SEL)action;

+ (UIButton*)createButtonWithTitle:(NSString*)title
                             frame:(CGRect)frame
                             image:(UIImage*)normalImage
                           hlImage:(UIImage*)highlitedImage
                          disImage:(UIImage*)disableImage
                            target:(id)target
                            action:(SEL)action;

+ (UIButton*)createGreenButtonWithTitle:(NSString*)title
                                  frame:(CGRect)frame
                                 target:(id)target
                                 action:(SEL)action;

+ (UIButton*)createYellowButtonWithTitle:(NSString*)title
                                   frame:(CGRect)frame
                                  target:(id)target
                                  action:(SEL)action;
+ (UIButton*)createYellow2ButtonWithTitle:(NSString*)title
                                    frame:(CGRect)frame
                                   target:(id)target
                                   action:(SEL)action;
+ (UIButton*)createBlueButtonWithTitle:(NSString*)title
                                 frame:(CGRect)frame
                                target:(id)target
                                action:(SEL)action;
+ (UIButton*)createGrayButtonWithTitle:(NSString*)title
                                 frame:(CGRect)frame
                                target:(id)target
                                action:(SEL)action;


+ (UILabel*)createLabelWithTitle:(NSString*)title
                            font:(UIFont*)font
                           frame:(CGRect)frame
                       textColor:(UIColor*)textColor
                   textAlignment:(NSTextAlignment)textAlignment;

+ (UITextField*)createTextFiledWithFrame:(CGRect)frame
                                delegate:(id<UITextFieldDelegate>)delegate
                             placeHolder:(NSString*)placeHolder
                            keyboardType:(UIKeyboardType)keyboardType
                           returnKeyType:(UIReturnKeyType)returnKeyType;

+ (UIImageView*)lineBgViewForFrame:(CGRect)frame;
+ (UIImageView*)lineBgViewForFrameHl:(CGRect)frame;

+ (RTLabel1*)createRTLabelWithFrame:(CGRect)frame
                              font:(UIFont*)font
                         textColor:(UIColor*)textColor
                   backgroundColor:(UIColor*)backgroundColor;


+ (UIView*)lineWithWidth:(CGFloat)width;
+ (UIView*)vLineWithHeight:(CGFloat)width;

+ (UIView*)emptyViewWithWidth:(CGFloat)width;
+ (UIView*)emptyViewWithHeight:(CGFloat)height;
+ (UIView*)emptyViewWithFrame:(CGRect)frame;

+ (void)addBorderForView:(UIView*)view;


@end
