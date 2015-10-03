//
//  HBForgetPwdViewController.h
//  LeaderDiandu
//
//  Created by hxj on 15/8/12.
//
//

typedef enum : NSUInteger {
    KLeaderViewTypeNull,
    KLeaderViewTypeRegister,
    KLeaderViewTypeForgetPwd,
} KLeaderViewType;

#import "HBBaseViewController.h"

@interface HBForgetPwdViewController : HBBaseViewController

@property (nonatomic, assign)KLeaderViewType viewType;

@end
