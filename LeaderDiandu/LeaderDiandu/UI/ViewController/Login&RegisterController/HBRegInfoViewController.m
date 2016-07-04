//
//  HBRegInfoViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/12/14.
//  Copyright © 2015年 hxj. All rights reserved.
//

#import "HBRegInfoViewController.h"
#import "HBNLoginViewController.h"
#import "HBDataSaveManager.h"

@interface HBRegInfoViewController ()

@end

@implementation HBRegInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initMainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initMainView
{
    self.title = @"注册成功";
    
    CGFloat controlW = 88;
    CGFloat controlX = (ScreenWidth-controlW) / 2;
    CGFloat controlY = KHBNaviBarHeight + 21;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlW)];
    iconView.image = [UIImage imageNamed:@"icn-success"];
    [self.view addSubview:iconView];
    
    NSMutableArray *descArr = [NSMutableArray array];
    [descArr addObject:@"欢迎你来到课外宝，你的账号（ID）为"];
    [descArr addObject:self.userID];
    [descArr addObject:@"请牢记你的账号和密码"];
    [descArr addObject:@"你可以在“个人中心”内绑定手机号码"];
    [descArr addObject:@"方便你使用手机号码登录和找回密码。"];
    
    controlX = 18;
    controlY = CGRectGetMaxY(iconView.frame) + 21;
    controlW = self.view.frame.size.width - controlX*2;
    CGFloat controlH = 20;
    UIFont *fontBig = [UIFont boldSystemFontOfSize:24];
    UIFont *fontMiddle = [UIFont systemFontOfSize:16];
    UIFont *fontSmall = [UIFont systemFontOfSize:14];
    NSInteger count = [descArr count];
    UILabel *descLabel = nil;
    for (NSInteger i=0; i<count; i++) {
        NSString *descStr = [descArr objectAtIndex:i];
        if (i == 0) {
            descLabel = [self createTextLabel:CGRectMake(controlX, controlY, controlW, controlH) text:descStr font:fontMiddle];
            descLabel.textColor = [UIColor colorWithHex:0x4A4A4A];
            controlY += controlH+21;
        }
        else if (i == 1) {
            descLabel = [self createTextLabel:CGRectMake(controlX, controlY, controlW, controlH) text:descStr font:fontBig];
            descLabel.textColor = [UIColor colorWithHex:0xFF8903];
            controlY += controlH+21;
        }
        else {
            descLabel = [self createTextLabel:CGRectMake(controlX, controlY, controlW, controlH) text:descStr font:fontSmall];
            descLabel.textColor = [UIColor colorWithHex:0x9B9B9B];
            controlY += controlH+7;
        }
        [self.view addSubview:descLabel];
    }
    
    controlY += controlH+29;
    controlH = 45;
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"yellow-normal"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"yellow-press"] forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}

- (UILabel *)createTextLabel:(CGRect)frame text:(NSString *)text font:(UIFont *)font
{
    UILabel *textLabel = [[UILabel alloc] initWithFrame:frame];
    textLabel.font = font;
    textLabel.backgroundColor = [UIColor clearColor];
//    textLabel.textColor = RGB(168, 167, 172);
    textLabel.numberOfLines = 0;
    textLabel.text = text;
    textLabel.textAlignment = NSTextAlignmentCenter;
    return textLabel;
}

- (void)buttonAction:(id)sender
{
    myAppDelegate.loginVC.userID = self.userID;
    [Navigator pushLoginControllerNow];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
