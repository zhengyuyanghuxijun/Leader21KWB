//
//  MrLoadingView.h
//  MrLoadingView
//
//  Created by ChenHao on 2/11/15.
//  Copyright (c) 2015 xxTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HHAlertView.h"

/**
 *  button index
 */
typedef NS_ENUM(NSInteger, HHAlertButton){
    HHAlertButtonOk,
    HHAlertButtonCancel
};
/*
 *the style of the logo
 */
typedef NS_ENUM(NSInteger, HHAlertStyle)
{
    HHAlertStyleDefault,
    HHAlertStyleOk,
    HHAlertStyleError,
    HHAlertStyleWraing,
    HHAlertStyleInstructions,
};

/**
 *  the block to tell user whitch button is clicked
 *
 *  @param button button
 */
typedef void (^selectButton)(HHAlertButton buttonindex);


@protocol HHAlertSingleViewDelegate <NSObject>


@optional
/**
 *  the delegate to tell user whitch button is clicked
 *
 *  @param button button
 */
- (void)didClickButtonAnIndex:(HHAlertButton )button;

@end


@interface HHAlertSingleView : UIView

/**
 *  the singleton of the calss
 *
 *  @return the sington
 */
+ (instancetype)shared;

/**
 *  dismiss the alertview
 */
+ (void)Hide;

/**
 *  show the alertview and use delegate to know which button is clicked
 *
 *  @param HHAlertStyle style
 *  @param view         view
 *  @param title        title
 *  @param detail       etail
 *  @param cancel       cancelButtonTitle
 *  @param ok           okButtonTitle
 */
+ (void)showAlertWithStyle:(HHAlertStyle )hHAlertStyle
                    inView:(UIView *)view
                     Title:(NSString *)title
                    detail:(NSString *)detail
              cancelButton:(NSString *)cancel
                  Okbutton:(NSString *)ok;


/**
 *  show the alertview and use Block to know which button is clicked
 *
 *  @param HHAlertStyle style
 *  @param view         view
 *  @param title        title
 *  @param detail       etail
 *  @param cancel       cancelButtonTitle
 *  @param ok           okButtonTitle
 */
+ (void)showAlertWithStyle:(HHAlertStyle)hHAlertStyle
                    inView:(UIView *)view
                     Title:(NSString *)title
                    detail:(NSString *)detail
              cancelButton:(NSString *)cancel
                  Okbutton:(NSString *)ok
                     block:(selectButton)block;

/**
 *  show the alertview and use delegate to know which button is clicked
 *
 *  @param HHAlertStyle     style
 *  @param view             view
 *  @param title            title
 *  @param detailFirst      detailFirst
 *  @param detailSecond     detailSecond
 *  @param ok               okButtonTitle
 */
+ (void)showAlertWithStyle:(HHAlertStyle )hHAlertStyle
                    inView:(UIView *)view
                     Title:(NSString *)title
                    detailFirst:(NSString *)detailFirst
                    detailSecond:(NSString *)detailSecond
                  okButton:(NSString *)ok;

@property (nonatomic, weak) id<HHAlertSingleViewDelegate> delegate;

@end
