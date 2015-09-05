//
//  UIViewController+AddBackBtn.h
//  LeaderDiandu
//
//  Created by hxj on 15/8/2.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AddBackBtn) <UIGestureRecognizerDelegate>

- (void)addBackButton;
- (void)backButtonPressed:(id)sender;

@end
