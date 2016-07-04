//
//  HBForgetPwdViewController.h
//  LeaderDiandu
//
//  Created by hxj on 15/8/12.
//
//

#import "HBBaseViewController.h"

typedef enum : NSUInteger {
    KLeaderViewTypeNull,
    KLeaderViewTypeRegister,
    KLeaderViewTypeForgetPwd,
} KLeaderViewType;

@interface HBForgetPwdViewController : HBBaseViewController

@property (nonatomic, assign)KLeaderViewType viewType;

@end
