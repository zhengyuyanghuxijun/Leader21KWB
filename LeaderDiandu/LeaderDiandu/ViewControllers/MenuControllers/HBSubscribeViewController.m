//
//  HBSubscribeViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/1.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBSubscribeViewController.h"
#import "HBTitleView.h"
#import "UIViewController+AddBackBtn.h"
#import "HBGridView.h"
#import "HBGridItemView.h"
#import "ButtonGridItemView.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"

@interface HBSubscribeViewController ()<HBGridViewDelegate, UIAlertViewDelegate>
{
    HBGridView *_gridView;
}

@property (nonatomic, strong) UIButton* confirmButton;
@property (nonatomic, strong) UIButton* ruleDescriptionButton;
@property (nonatomic, assign) NSInteger subscribeId;
@property (nonatomic, assign) NSInteger currentSelectIndex;

@end

@implementation HBSubscribeViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.subscribeId = -1;
        self.currentSelectIndex = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HBTitleView *labTitle = [HBTitleView titleViewWithTitle:@"订阅等级" onView:self.view];
    [self.view addSubview:labTitle];
    
    [self addBackButton];
    [self initMainGrid];
    [self initConfirmButton];
    [self initRuleDescriptionButton];
    //获取用户当前订阅的套餐
    [self requestUserBookset];
}

- (void)initMainGrid
{
    _gridView = [[HBGridView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, ScreenWidth)];
    _gridView.delegate = self;
    _gridView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_gridView];
}

-(void)initConfirmButton
{
    CGRect rc = CGRectMake(0.0f, ScreenHeight-80, self.view.frame.size.width, 70.0f);
    rc.origin.x += 20.0f;
    rc.size.width -= 40.0f;
    rc.origin.y += 20.0f;
    rc.size.height -= 30.0f;
    
    self.confirmButton = [[UIButton alloc] initWithFrame:rc];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"user_button"] forState:UIControlStateNormal];
    [self.confirmButton setTitle:@"确认订阅" forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];
}

-(void)initRuleDescriptionButton
{
    CGRect rc = CGRectMake(0.0f, ScreenHeight-80 - 40, self.view.frame.size.width, 70.0f);
    rc.origin.x += 20.0f;
    rc.size.width -= 40.0f;
    rc.origin.y += 20.0f;
    rc.size.height -= 30.0f;
    
    self.ruleDescriptionButton = [[UIButton alloc] initWithFrame:rc];
    [self.ruleDescriptionButton setTitle:@"规则说明" forState:UIControlStateNormal];
    [self.ruleDescriptionButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.ruleDescriptionButton addTarget:self action:@selector(ruleDescriptionPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ruleDescriptionButton];
}

- (void)confirmButtonPressed:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否要订阅该等级？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 0;
    
    [alertView show];
}

- (void)ruleDescriptionPressed:(id)sender
{
    //to do ...
}

#pragma mark - actionSheetDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        
    }else{
        NSDictionary *dict = [[HBDataSaveManager defaultManager] loadUser];
        if (dict) {
            NSString *user = [dict objectForKey:@"name"];
            NSString *token = [dict objectForKey:@"token"];
            //获取用户当前订阅的套餐
            [[HBServiceManager defaultManager] requestBooksetSub:user token:token bookset_id:[NSString stringWithFormat:@"%ld",(self.currentSelectIndex + 1)] months:@"1" completion:^(id responseObject, NSError *error) {
                [self requestUserBookset];
            }];
        }
    }
}

#pragma mark -
#pragma mark HBGridViewDelegate

// 获取单元格的总数
- (NSInteger)gridNumberOfGridView:(HBGridView *)gridView
{
    return 9;
}

// 获取gridview每行显示的grid数
- (NSInteger)columnNumberOfGridView:(HBGridView *)gridView
{
    return 3;
}

// 获取单元格的行数
- (NSInteger)rowNumberOfGridView:(HBGridView *)gridView
{
    return 3;
}

- (CGFloat)gridView:(HBGridView *)gridView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenWidth / 3.0f;
}

// 获取特定位置的单元格视图
- (HBGridItemView *)gridView:(HBGridView *)gridView inGridCell:(HBGridCellView *)gridCell gridItemViewAtGridIndex:(GridIndex *)gridIndex listIndex:(NSInteger)listIndex
{
    NSLog(@"list index:%ld", listIndex);
    ButtonGridItemView *itemView = (ButtonGridItemView *)[gridView dequeueReusableGridItemAtGridIndex:gridIndex ofGridCellView:gridCell];
    if (!itemView)
    {
        itemView = [[ButtonGridItemView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/3, ScreenWidth/3)];
    }
    
    //说明这个等级是被订阅的，需要特殊标记一下
    if (self.subscribeId == (listIndex + 1)) {
        [itemView updateSubscribeImgView:YES levelButton:YES];
    }else if(self.currentSelectIndex == listIndex){
        [itemView updateSubscribeImgView:NO levelButton:YES];
    }else{
        [itemView updateSubscribeImgView:NO levelButton:NO];
    }

    return itemView;
}

- (void)gridView:(HBGridView *)gridView didSelectGridItemAtIndex:(NSInteger)index
{
    self.currentSelectIndex = index;
    [_gridView reloadData];

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

//获取用户当前订阅的套餐
- (void)requestUserBookset
{
    NSDictionary *dict = [[HBDataSaveManager defaultManager] loadUser];
    if (dict) {
        NSString *user = [dict objectForKey:@"name"];
        NSString *token = [dict objectForKey:@"token"];
        //获取用户当前订阅的套餐
        [[HBServiceManager defaultManager] requestUserBookset:user token:token completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                //获取用户当前订阅的套餐成功
                id tmp = [responseObject objectForKey:@"bookset_id"];
                self.subscribeId = [tmp integerValue];
                [_gridView reloadData];
            }
        }];
    }
}

@end
