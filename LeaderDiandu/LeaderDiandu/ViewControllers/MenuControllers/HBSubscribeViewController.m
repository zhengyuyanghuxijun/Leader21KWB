//
//  HBSubscribeViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/1.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBSubscribeViewController.h"
#import "HBGridView.h"
#import "HBGridItemView.h"
#import "ButtonGridItemView.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"
#import "HHAlertSingleView.h"

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
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"订阅等级";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initMainGrid];
    [self initConfirmButton];
    [self initRuleDescriptionButton];
    //获取用户当前订阅的套餐
    [self requestUserBookset];
}

- (void)initMainGrid
{
    _gridView = [[HBGridView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    _gridView.delegate = self;
    [_gridView setScrollEnabled:NO];
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要订阅该等级？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 0;
    
    [alertView show];
}

- (void)ruleDescriptionPressed:(id)sender
{
    NSString *firstStr = @"学生在绑定老师前，或者绑定了老师未指派组时，可以自由订阅等级，在订阅的等级内按照时间推送新书";
    NSString *secondStr = @"当被老师指定了组后，等级就被老师的组确定，且锁定，学生无法更改，直到退出组（被老师移除，或者解除绑定老师，即没有组的信息时）";
    [HHAlertSingleView showAlertWithStyle:HHAlertStyleInstructions inView:self.view Title:@"规则说明" detailFirst:firstStr detailSecond:secondStr okButton:@"我知道了"];
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
    return 100;
}

// 获取特定位置的单元格视图
- (HBGridItemView *)gridView:(HBGridView *)gridView inGridCell:(HBGridCellView *)gridCell gridItemViewAtGridIndex:(GridIndex *)gridIndex listIndex:(NSInteger)listIndex
{
    NSLog(@"list index:%ld", listIndex);
    ButtonGridItemView *itemView = (ButtonGridItemView *)[gridView dequeueReusableGridItemAtGridIndex:gridIndex ofGridCellView:gridCell];
    if (!itemView)
    {
        itemView = [[ButtonGridItemView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/3, 100)];
    }
    
    NSString *indexStr = [NSString stringWithFormat:@"%ld", (listIndex + 1)];
    
    //说明这个等级是被订阅的，需要特殊标记一下
    if (self.subscribeId == (listIndex + 1)) {
        [itemView updateSubscribeImgView:YES levelButton:YES index:indexStr];
    }else if(self.currentSelectIndex == listIndex){
        [itemView updateSubscribeImgView:NO levelButton:YES index:indexStr];
    }else{
        [itemView updateSubscribeImgView:NO levelButton:NO index:indexStr];
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
