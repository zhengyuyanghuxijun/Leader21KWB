//
//  MBHudUtil.m
//  magicEnglish
//
//  Created by libin.tian on 1/6/14.
//  Copyright (c) 2014 ilovedev.com. All rights reserved.
//

#import "MBHudUtil.h"

#import "AppDelegate.h"
#import "MBProgressHUD.h"


@implementation MBHudUtil

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
		if ([v isKindOfClass:[MBProgressHUD class]]) {
			viewExist = v;
            break;
		}
	}
    
    MBProgressHUD *HUD = (MBProgressHUD *)viewExist;
    if (HUD == nil) {
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    HUD.labelText = @"";
    HUD.detailsLabelText = ([text length]>0)?text:@"正在载入...";

}

+ (void)hideActivityView:(UIView *)view
{
    if (view == nil) {
        view = [self defaultView];
    }
    [MBProgressHUD hideHUDForView:view animated:YES];

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
		if ([v isKindOfClass:[MBProgressHUD class]]) {
			viewExist = v;
            break;
		}
	}
    
    MBProgressHUD *HUD = (MBProgressHUD *)viewExist;
    if (HUD == nil) {
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage retina4ImageNamed:@"hudd_successed.png"]];
//    HUD.backgroundBg = [UIImage imageWithName:@"window_bg.png" size:HUD.size];
    HUD.mode = MBProgressHUDModeCustomView;
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
		if ([v isKindOfClass:[MBProgressHUD class]]) {
			viewExist = v;
            break;
		}
	}
    
    MBProgressHUD *HUD = (MBProgressHUD *)viewExist;
    if (HUD == nil) {
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage retina4ImageNamed:@"hud_failed.png"]];
//    HUD.backgroundBg = [UIImage imageWithName:@"window_bg.png" size:HUD.size];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"";
    HUD.detailsLabelText = text;
    [HUD hide:YES afterDelay:time];
}

+ (void)showTextViewAfter:(NSString *)text
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showTextView:text inView:nil];
    });
}

+ (void)showTextView:(NSString *)text
              inView:(UIView *)view
{
    if (view == nil) {
        view = [self defaultView];
    }
    UIView *viewExist = nil;
	for (UIView *v in [view subviews]) {
		if ([v isKindOfClass:[MBProgressHUD class]]) {
			viewExist = v;
            break;
		}
	}
    
    MBProgressHUD *HUD = (MBProgressHUD *)viewExist;
    if (HUD == nil) {
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    //HUD.customView = [[UIImageView alloc] initWithImage:[UIImage retina4ImageNamed:@""]];// 不显不图标
    //    HUD.backgroundBg = [UIImage imageWithName:@"window_bg.png" size:HUD.size];
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = text;
    HUD.yOffset = 150.0f;
    HUD.detailsLabelText = @"";
    [HUD hide:YES afterDelay:Http_ErrorMsgDisplay_Interval];
}


+ (void)showTextAlert:(NSString*)msg delegate:(id)delegate
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:delegate
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

@end
