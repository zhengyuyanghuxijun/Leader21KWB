//
//  LDHudUtil.m
//  magicEnglish
//
//  Created by libin.tian on 1/6/14.
//  Copyright (c) 2014 ilovedev.com. All rights reserved.
//

#import "LDHudUtil.h"

#import "LDProgressHUD.h"


@implementation LDHudUtil

+ (UIView*)defaultView
{
    UIWindow* window = [UIApplication sharedApplication].delegate.window;
    return window;
}

+ (void)showActivityView:(NSString *)text
                  inView:(UIView *)view
{
    if (view == nil) {
        view = [self defaultView];
    }
    UIView *viewExist = nil;
	for (UIView *v in [view subviews]) {
		if ([v isKindOfClass:[LDProgressHUD class]]) {
			viewExist = v;
            break;
		}
	}
    
    LDProgressHUD *HUD = (LDProgressHUD *)viewExist;
    if (HUD == nil) {
        HUD = [LDProgressHUD showHUDAddedTo:view animated:YES];
    }
    HUD.labelText = @"";
    HUD.detailsLabelText = ([text length]>0)?text:@"正在载入...";

}

+ (void)hideActivityView:(UIView *)view
{
    if (view == nil) {
        view = [self defaultView];
    }
    [LDProgressHUD hideHUDForView:view animated:YES];

}

+ (void)showFinishActivityView:(NSString *)text
{
    [self showFinishActivityView:text
                        interval:Http_ErrorMsgDisplay_Interval];
}

+ (void)showFinishActivityView:(NSString *)text
                        inView:(UIView *)view
{
    [self showFinishActivityView:text
                        interval:Http_ErrorMsgDisplay_Interval
                          inView:view];
}


+ (void)showFinishActivityView:(NSString *)text
                      interval:(NSTimeInterval)time
{
    [self showFinishActivityView:text
                        interval:time
                          inView:nil];
}

+ (void)showFinishActivityView:(NSString *)text
                      interval:(NSTimeInterval)time
                        inView:(UIView *)view
{
    if (view == nil) {
        view = [self defaultView];
    }
    UIView *viewExist = nil;
	for (UIView *v in [view subviews]) {
		if ([v isKindOfClass:[LDProgressHUD class]]) {
			viewExist = v;
            break;
		}
	}
    
    LDProgressHUD *HUD = (LDProgressHUD *)viewExist;
    if (HUD == nil) {
        HUD = [LDProgressHUD showHUDAddedTo:view animated:YES];
    }
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage retina4ImageNamed:@"hudd_successed.png"]];
//    HUD.backgroundBg = [UIImage imageWithName:@"window_bg.png" size:HUD.size];
    HUD.mode = LDProgressHUDModeCustomView;
    HUD.labelText = @"";
    HUD.detailsLabelText = text;
    [HUD hide:YES afterDelay:time];
}

+ (void)showFailedActivityView:(NSString *)text
{
    [self showFailedActivityView:text
                        interval:Http_ErrorMsgDisplay_Interval];
}

+ (void)showFailedActivityView:(NSString *)text
                        inView:(UIView *)view
{
    [self showFailedActivityView:text
                        interval:Http_ErrorMsgDisplay_Interval
                          inView:view];
}

+ (void)showFailedActivityView:(NSString *)text
                      interval:(NSTimeInterval)time
{
    [self showFailedActivityView:text
                        interval:time
                          inView:nil];
}


+ (void)showFailedActivityView:(NSString *)text
                      interval:(NSTimeInterval)time
                        inView:(UIView *)view
{
    if (view == nil) {
        view = [self defaultView];
    }
    UIView *viewExist = nil;
	for (UIView *v in [view subviews]) {
		if ([v isKindOfClass:[LDProgressHUD class]]) {
			viewExist = v;
            break;
		}
	}
    
    LDProgressHUD *HUD = (LDProgressHUD *)viewExist;
    if (HUD == nil) {
        HUD = [LDProgressHUD showHUDAddedTo:view animated:YES];
    }
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage retina4ImageNamed:@"hud_failed.png"]];
//    HUD.backgroundBg = [UIImage imageWithName:@"window_bg.png" size:HUD.size];
    HUD.mode = LDProgressHUDModeCustomView;
    HUD.labelText = @"";
    HUD.detailsLabelText = text;
    [HUD hide:YES afterDelay:time];
}

+ (void)showTextView:(NSString *)text
              inView:(UIView *)view
{
    if (view == nil) {
        view = [self defaultView];
    }
    UIView *viewExist = nil;
	for (UIView *v in [view subviews]) {
		if ([v isKindOfClass:[LDProgressHUD class]]) {
			viewExist = v;
            break;
		}
	}
    
    LDProgressHUD *HUD = (LDProgressHUD *)viewExist;
    if (HUD == nil) {
        HUD = [LDProgressHUD showHUDAddedTo:view animated:YES];
    }
    //HUD.customView = [[UIImageView alloc] initWithImage:[UIImage retina4ImageNamed:@""]];// 不显不图标
    //    HUD.backgroundBg = [UIImage imageWithName:@"window_bg.png" size:HUD.size];
    HUD.mode = LDProgressHUDModeText;
    HUD.labelText = text;
    HUD.yOffset = 150.0f;
    HUD.detailsLabelText = @"";
    [HUD hide:YES afterDelay:Http_ErrorMsgDisplay_Interval];
}


+ (void)showTextAlert:(NSString*)msg
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

@end
