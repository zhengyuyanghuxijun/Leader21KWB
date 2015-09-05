//
//  HBBaseViewController.h
//  LeaderDiandu
//
//  Created by hxj on 15/8/26.
//
//

#import <UIKit/UIKit.h>

#define KHBNaviBarHeight    64
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HBBaseViewController : UIViewController
{
    
}

-(void)willPop;
@end

@interface HBBaseViewController(CallBack)

@end
