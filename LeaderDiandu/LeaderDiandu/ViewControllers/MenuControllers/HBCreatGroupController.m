//
//  HBCreatGroupController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/15.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBCreatGroupController.h"
#import "UIViewController+AddBackBtn.h"
#import "HBTitleView.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"

@interface HBCreatGroupController ()

@property (nonatomic, strong) UIButton* okButton;
@property (nonatomic, strong) UITextField* nameTextField;
@property (nonatomic, strong) UITextField* levelTextField;

@end

@implementation HBCreatGroupController

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
    
    HBTitleView *labTitle = [HBTitleView titleViewWithTitle:@"创建群组" onView:self.view];
    [self.view addSubview:labTitle];
    
    [self addBackButton];
    
    CGRect frame = self.view.frame;
    float controlX = 20;
    float controlY = 200 + KHBNaviBarHeight;
    float width = frame.size.width - controlX*2;
    UIImageView *editBg = [[UIImageView alloc] initWithFrame:CGRectMake(controlX, controlY, width, 50)];
    editBg.userInteractionEnabled = YES;
    UIImage *image = [UIImage imageNamed:@"user_editbg"];
    editBg.image = image;
    [self.view addSubview:editBg];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, width-40, 40)];
    [editBg addSubview:self.nameTextField];
    
    UIImageView *editBgSec = [[UIImageView alloc] initWithFrame:CGRectMake(controlX, controlY + 60, width, 50)];
    editBgSec.image = image;
    editBgSec.userInteractionEnabled = YES;
    [self.view addSubview:editBgSec];
    
    self.levelTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, width-40, 40)];
    [editBgSec addSubview:self.levelTextField];
    
    CGRect rc = CGRectMake(20.0f, controlY + 140, ScreenWidth - 20 - 20, 50.0f);
    self.okButton = [[UIButton alloc] initWithFrame:rc];
    [self.okButton setBackgroundImage:[UIImage imageNamed:@"user_button"] forState:UIControlStateNormal];
    [self.okButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.okButton];
}

-(void)okButtonPressed
{
    NSDictionary *dict = [[HBDataSaveManager defaultManager] loadUser];
    if (dict) {
        NSString *user = [dict objectForKey:@"name"];
        [[HBServiceManager defaultManager] requestClassCreate:user name:self.nameTextField.text bookset_id:self.levelTextField.text completion:^(id responseObject, NSError *error) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

@end
