//
//  UIViewController+HBExt.h
//  LediKWB
//
//  Created by ChunGuo on 15/12/11.
//  Copyright © 2016年 huxijun. All rights reserved.
//

//点击空白处，键盘消失
@interface UIViewController (DismissKeyboard)

//该方法可加在RootViewController的viewDidLoad中
- (void)setupForDismissKeyboard;

@end


@interface UIViewController (AddBackBtn) <UIGestureRecognizerDelegate>

- (void)addBackButton;
- (void)backButtonPressed:(id)sender;

@end

