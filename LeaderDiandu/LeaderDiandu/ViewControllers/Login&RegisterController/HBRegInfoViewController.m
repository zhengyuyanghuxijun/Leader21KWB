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
    
    NSMutableArray *descArr = [NSMutableArray array];
    [descArr addObject:@"欢迎你来到课外宝，"];
    [descArr addObject:@"你的账号（ID）为"];
    [descArr addObject:self.userID];
    [descArr addObject:@"请牢记你的账号和密码。"];
    [descArr addObject:@"你可以在“个人中心”内，"];
    [descArr addObject:@"绑定手机号码，"];
    [descArr addObject:@"方便你使用手机号码"];
    [descArr addObject:@"登录和找回密码。"];
    
    CGFloat currX = 20;
    CGFloat currY = KHBNaviBarHeight + 50;
    CGFloat lineSpace = 4;
    UIFont *descFont = [UIFont systemFontOfSize:18];
    CGFloat descWidth = self.view.frame.size.width - currX*2;
    CGFloat descHeight = 20;
    NSInteger count = [descArr count];
    UILabel *descLabel = nil;
    for (NSInteger i=0; i<count; i++) {
        NSString *descStr = [descArr objectAtIndex:i];
//        CGSize descSize = [descStr boundingRectWithSize:CGSizeMake(descWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:descFont,NSFontAttributeName, nil] context:nil].size;
        
        descLabel = [self createTextLabel:CGRectMake(currX, currY, descWidth, descHeight) text:descStr font:descFont];
        if (i == 2) {
            descLabel.font = [UIFont boldSystemFontOfSize:20];
            descLabel.textColor = KLeaderRGB;
        }
        [self.view addSubview:descLabel];
        
        currY += descHeight+lineSpace;
    }
    
    currX = 20;
    currY += 50;
//    descWidth = screenW - controlX*2;
    descHeight = 45;
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(currX, currY, descWidth, descHeight)];
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
    [AppDelegate delegate].loginVC.userID = self.userID;
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
