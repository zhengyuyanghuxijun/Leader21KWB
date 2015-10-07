//
//  HBCreatGroupController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/15.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBCreatGroupController.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"

@interface HBCreatGroupController ()<UITextFieldDelegate>

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
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"创建群组";
    
    float controlY = KHBNaviBarHeight + 50;
    float screenW = self.view.frame.size.width;
    UIView *accountView = [[UIView alloc] initWithFrame:CGRectMake(0, controlY, screenW, 91)];
    accountView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:accountView];
    
    float controlX = 30;
    controlY = 0;
    float controlW = screenW - controlX;
    float controlH = 45;
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    self.nameTextField.placeholder = @"群组名称";
    [accountView addSubview:self.nameTextField];
    
    controlY += controlH;
    UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, 1)];
    lineLbl.backgroundColor = RGBEQ(239);
    [accountView addSubview:lineLbl];
    
    controlY += 1;
    self.levelTextField = [[UITextField alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    self.levelTextField.placeholder = @"群组等级(1-9)";
    self.levelTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.levelTextField.delegate = self;
    [accountView addSubview:self.levelTextField];
    
    CGRect rc = CGRectMake(20.0f, controlY + 180, ScreenWidth - 20 - 20, 50.0f);
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
            [self.delegate creatGroupComplete];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.location>= 1)
        
        return NO;
    
    return YES;
}

@end
