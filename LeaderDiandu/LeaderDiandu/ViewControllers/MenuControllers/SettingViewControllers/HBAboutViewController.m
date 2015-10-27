//
//  HBAboutViewController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/22.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBAboutViewController.h"

@implementation HBAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"关于课外宝";
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"APPicon_about"]];
    logoImgView.frame = CGRectMake((ScreenWidth - 120)/2, (ScreenHeight - 120)/2 - 20, 120, 120);
    logoImgView.layer.cornerRadius = 30;
    logoImgView.clipsToBounds = YES;
    [self.view addSubview:logoImgView];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.frame = CGRectMake(0, logoImgView.frame.origin.y + 120 + 20, ScreenWidth, 20);
    versionLabel.text = [NSString stringWithFormat:@"%@%@", @"课外宝 ", self.versionStr];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    
    UILabel *companyLabel = [[UILabel alloc] init];
    companyLabel.frame = CGRectMake(0, versionLabel.frame.origin.y + 20 + 10, ScreenWidth, 20);
    companyLabel.text =  @"上海乐迪网络科技有限公司";
    companyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:companyLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.frame = CGRectMake(0, companyLabel.frame.origin.y + 20 + 10, ScreenWidth/2 - 13, 20);
    phoneLabel.text =  @"客服电话：";
    phoneLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:phoneLabel];
    
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 13, companyLabel.frame.origin.y + 20 + 10, ScreenWidth/2, 20)];
    [phoneBtn setTitle:@"400-812-6161" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    phoneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [phoneBtn addTarget:self action:@selector(phoneBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneBtn];
}

-(void)phoneBtnPressed
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要拨打客服电话？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 0;
    
    [alertView show];
}

#pragma mark - actionSheetDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        
    }else{
        NSString *allString = [NSString stringWithFormat:@"tel:4008126161"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
    }
}

@end
