//
//  HBReadStatisticalViewController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/17.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBReadStatisticalViewController.h"

@interface HBReadStatisticalViewController ()

@end

@implementation HBReadStatisticalViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINavigationBar *naviBar = self.navigationController.navigationBar;
    //设置navigationBar背景颜色
    [naviBar setBarTintColor:[UIColor colorWithHex:0x1E90FF]];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"阅读统计";
    
//    [self requestSystemMsg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
