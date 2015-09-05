//
//  ViewCreatorHelper.m
//  RenrenOfficial-iOS-Concept
//
//  Created by 田立彬 on 13-5-29.
//  Copyright (c) 2013年 . All rights reserved.
//

#import "ViewCreatorHelper.h"

#import "RTLabel1.h"


@implementation ViewCreatorHelper



+ (UIButton*)createButtonWithTitle:(NSString*)title
                             frame:(CGRect)frame
                        normaImage:(NSString*)normalImageKey
                    highlitedImage:(NSString*)highlitedImageKey
                      disableImage:(NSString*)disableImageKey
                            target:(id)target
                            action:(SEL)action
{
    UIImage* normalImage = [UIImage imageNamed:normalImageKey];

    UIImage* highlitedImage = nil;
    if (highlitedImageKey != nil) {
        highlitedImage = [UIImage imageNamed:highlitedImageKey];
    }
    
    UIImage* disableImage = nil;
    if (disableImageKey != nil) {
        disableImage = [UIImage imageNamed:disableImageKey];
    }

    
    return [self createButtonWithTitle:title frame:frame image:normalImage hlImage:highlitedImage disImage:disableImage target:target action:action];
}

+ (UIButton*)createButtonWithTitle:(NSString*)title
                             frame:(CGRect)frame
                             image:(UIImage*)normalImage
                           hlImage:(UIImage*)highlitedImage
                          disImage:(UIImage*)disableImage
                            target:(id)target
                            action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    if (title != nil) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    if (normalImage != nil) {
        CGSize size = normalImage.size;
        [button setBackgroundImage:[normalImage stretchableImageWithLeftCapWidth:size.width/2.0f
                                                                    topCapHeight:size.height/2.0f]
                          forState:UIControlStateNormal];
    }
    
    if (highlitedImage != nil) {
        CGSize size = highlitedImage.size;
        UIImage* image = [highlitedImage stretchableImageWithLeftCapWidth:size.width/2.0f
                                                             topCapHeight:size.height/2.0f];
        [button setBackgroundImage:image
                          forState:UIControlStateHighlighted];
        [button setBackgroundImage:image
                          forState:UIControlStateSelected];
    }
    
    if (disableImage != nil) {
        CGSize size = disableImage.size;
        [button setBackgroundImage:[disableImage stretchableImageWithLeftCapWidth:size.width/2.0f
                                                                     topCapHeight:size.height/2.0f]
                          forState:UIControlStateDisabled];
    }
    
    if (target != nil && action != nil) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([DE isPad]) {
        button.titleLabel.font = [UIFont systemFontOfSize:24.0f];
    }else
    {
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    
    return button;

}

+ (UIButton*)createGreenButtonWithTitle:(NSString*)title
                                  frame:(CGRect)frame
                                 target:(id)target
                                 action:(SEL)action
{
    UIButton* button = [self createButtonWithTitle:title
                                             frame:frame
                                        normaImage:@"button1.png"
                                    highlitedImage:nil
                                      disableImage:nil
                                            target:target
                                            action:action];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    return button;
}

+ (UIButton*)createYellowButtonWithTitle:(NSString*)title
                                   frame:(CGRect)frame
                                  target:(id)target
                                  action:(SEL)action
{
    UIButton* button = [self createButtonWithTitle:title
                                             frame:frame
                                        normaImage:@"button2.png"
                                    highlitedImage:nil
                                      disableImage:nil
                                            target:target
                                            action:action];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    return button;
}

+ (UIButton*)createYellow2ButtonWithTitle:(NSString*)title
                                    frame:(CGRect)frame
                                   target:(id)target
                                   action:(SEL)action
{
    UIButton* button = [self createButtonWithTitle:title
                                             frame:frame
                                        normaImage:@"big_button.png"
                                    highlitedImage:nil
                                      disableImage:nil
                                            target:target
                                            action:action];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    return button;
}
+ (UIButton*)createBlueButtonWithTitle:(NSString*)title
                                 frame:(CGRect)frame
                                target:(id)target
                                action:(SEL)action
{
    UIButton* button = [self createButtonWithTitle:title
                                             frame:frame
                                        normaImage:@"big_button2.png"
                                    highlitedImage:nil
                                      disableImage:nil
                                            target:target
                                            action:action];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    return button;
}

+ (UIButton*)createGrayButtonWithTitle:(NSString*)title
                                 frame:(CGRect)frame
                                target:(id)target
                                action:(SEL)action
{
    UIButton* button = [self createButtonWithTitle:title
                                             frame:frame
                                        normaImage:@"big_button3.png"
                                    highlitedImage:nil
                                      disableImage:nil
                                            target:target
                                            action:action];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    return button;
}



+ (UIButton*)createIconButtonWithFrame:(CGRect)frame
                            normaImage:(NSString*)normalImageKey
                        highlitedImage:(NSString*)highlitedImageKey
                          disableImage:(NSString*)disableImageKey
                                target:(id)target
                                action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    if (normalImageKey != nil) {
        UIImage* image = [UIImage imageNamed:normalImageKey];
        if (image != nil) {
            [button setImage:image forState:UIControlStateNormal];
        }
    }
    
    if (highlitedImageKey != nil) {
        UIImage* image = [UIImage imageNamed:highlitedImageKey];
        if (image != nil) {
            [button setImage:image forState:UIControlStateHighlighted];
        }
    }
    
    if (disableImageKey != nil) {
        UIImage* image = [UIImage imageNamed:disableImageKey];
        if (image != nil) {
            [button setImage:image forState:UIControlStateDisabled];
        }
    }
    
    if (target != nil && action != nil) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }

    return button;
}

+ (UILabel*)createLabelWithTitle:(NSString*)title
                            font:(UIFont*)font
                           frame:(CGRect)frame
                       textColor:(UIColor*)textColor
                   textAlignment:(NSTextAlignment)textAlignment
{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    if (font != nil) {
        label.font = font;
    }
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}


+ (UITextField*)createTextFiledWithFrame:(CGRect)frame
                                delegate:(id<UITextFieldDelegate>)delegate
                             placeHolder:(NSString*)placeHolder
                            keyboardType:(UIKeyboardType)keyboardType
                           returnKeyType:(UIReturnKeyType)returnKeyType
{
    UITextField* textField = [[UITextField alloc] initWithFrame:frame];
    textField.delegate = delegate;
    textField.placeholder = placeHolder;
    textField.keyboardType = keyboardType;
    textField.returnKeyType = returnKeyType;
    
    UIView* leftView = [self emptyViewWithWidth:10.0f];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
//    textField.rightViewMode = UITextFieldViewModeAlways;
//    textField.rightView = leftView;
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    textField.font = [UIFont systemFontOfSize:14.0f];
    textField.textColor = [UIColor blackColor];
    
    textField.background = [UIImage resizebleImageNamed:@"in_put.png"];
    
    return textField;
}



+ (UIImageView*)lineBgViewForFrame:(CGRect)frame
{
    CGRect rc = frame;
    CGFloat x = (frame.size.height - 4.0f);
    rc.origin.y += x;
    rc.size.height -= x;
    
    UIImageView* img = [[UIImageView alloc] initWithFrame:rc];
    img.image = [UIImage resizebleImageNamed:@"input.png"];
    
    return img;
}

+ (UIImageView*)lineBgViewForFrameHl:(CGRect)frame
{
    CGRect rc = frame;
    CGFloat x = (frame.size.height - 4.0f);
    rc.origin.y += x;
    rc.size.height -= x;
    
    UIImageView* img = [[UIImageView alloc] initWithFrame:rc];
    img.image = [UIImage resizebleImageNamed:@"input_focus.png"];
    
    return img;
}

+ (RTLabel1*)createRTLabelWithFrame:(CGRect)frame
                              font:(UIFont*)font
                         textColor:(UIColor*)textColor
                   backgroundColor:(UIColor*)backgroundColor
{
    RTLabel1* label = [[RTLabel1 alloc] initWithFrame:frame];
    [label setParagraphReplacement:@""];
    [label setTextColor:textColor];
    [label setFont:font];
    [label setBackgroundColor:backgroundColor];
    
    return label;
}

+ (UIView*)lineWithWidth:(CGFloat)width
{
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat h = 1.0f;
    if (screenScale > 0.0f) {
        h = 1.0f / screenScale;
    }
    
    CGRect rc = CGRectMake(0.0f, 0.0f, width, h);
    UIView* lineView = [[UIView alloc] initWithFrame:rc];
    lineView.backgroundColor = RGBCOLOR(200.0f, 200.0f, 200.0f);
    
    return lineView;
}

+ (UIView*)vLineWithHeight:(CGFloat)height
{
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat w = 1.0f;
    if (screenScale > 0.0f) {
        w = 1.0f / screenScale;
    }
    
    CGRect rc = CGRectMake(0.0f, 0.0f, w, height);
    UIView* lineView = [[UIView alloc] initWithFrame:rc];
    lineView.backgroundColor = RGBCOLOR(200.0f, 200.0f, 200.0f);
    
    return lineView;
}

+ (UIView*)emptyViewWithWidth:(CGFloat)width
{
    CGRect rc = CGRectMake(0.0f, 0.0f, width, 1.0f);
    return [self emptyViewWithFrame:rc];
}

+ (UIView*)emptyViewWithHeight:(CGFloat)height
{
    CGRect rc = CGRectMake(0.0f, 0.0f, 1.0f, height);
    return [self emptyViewWithFrame:rc];
}

+ (UIView*)emptyViewWithFrame:(CGRect)frame
{
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    return view;
}



+ (void)addBorderForView:(UIView *)view
{
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat h = 1.0f;
    if (screenScale > 0.0f) {
        h = 1.0f / screenScale;
    }
    UIColor* color = [UIColor lightGrayColor];
    view.layer.borderWidth = h;
    view.layer.borderColor = color.CGColor;

}
@end
