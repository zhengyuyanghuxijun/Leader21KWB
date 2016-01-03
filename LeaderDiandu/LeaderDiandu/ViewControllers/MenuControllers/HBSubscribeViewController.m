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

#define KTagBgBiew 111111
#define LABELFONTSIZE 16.0f

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define HHAlertSingleView_SIZE_WIDTH (ScreenWidth - 20 - 20)
#define HHAlertSingleView_SIZE_HEIGHT (ScreenHeight - 40 - 40)

    static NSString * const kHBRuleCellReuseId = @"kHBRuleCellReuseId";

@implementation HBRuleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isShowLine:(BOOL)aShowLine
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI:aShowLine];
    }
    return self;
}

-(void)initUI:(BOOL)aShowLine
{
    CGRect rc = CGRectMake(20, 5, HHAlertSingleView_SIZE_WIDTH - 20 - 20, (HHAlertSingleView_SIZE_HEIGHT - 90 - 70)/4 - 5 - 5);
    //背景
    UIView *bgView = [[UIView alloc] initWithFrame:rc];
    [self addSubview:bgView];
    
    if (aShowLine) {
        //分隔线
        UIImageView *separateImgView = [[UIImageView alloc] initWithFrame:CGRectMake(rc.origin.x + 30, rc.origin.y + rc.size.height - 2, rc.size.width - 30 - 30, 2)];
        separateImgView.image = [UIImage imageNamed:@"Line"];
        [bgView addSubview:separateImgView];
    }
    
    //小箭头
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, ((HHAlertSingleView_SIZE_HEIGHT - 90 - 70)/4 - 30)/2, 30, 30)];
    self.imgView.image = [UIImage imageNamed:@"system-msg-icon"];
    [bgView addSubview:self.imgView];
    
    //内容
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imgView.frame.origin.x + 30 + 10, 0, rc.size.width - 30 - 30, rc.size.height)];
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [self.contentLabel setTextColor:RGB(65, 65, 65)];
    [bgView addSubview:self.contentLabel];
}

@end

@interface HBSubscribeViewController ()<HBGridViewDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    HBGridView *_gridView;
    NSArray *_ruleArr;
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
        _ruleArr = @[@"课外宝根据你的订阅等级，每周为你的书架更新图书", @"在你进入老师的辅导小组前，你可以更改订阅等级", @"在你进入老师的辅导小组后，你将不能更改订阅等级", @"老师可以变更你的辅导小组，辅导小组变更后，订阅等级自动更新"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"订阅等级";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initConfirmButton];
    [self initRuleDescriptionButton];
    [self initMainGrid];
    //获取用户当前订阅的套餐
    [self requestUserBookset];
}

- (void)initMainGrid
{
    _gridView = [[HBGridView alloc] initWithFrame:CGRectMake(0, KHBNaviBarHeight, ScreenWidth, CGRectGetMinY(self.ruleDescriptionButton.frame)-KHBNaviBarHeight-10)];
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
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"green-normal"] forState:UIControlStateNormal];
    [self.confirmButton setTitle:@"确认订阅" forState:UIControlStateNormal];
    [self.confirmButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [self.confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];
}

-(void)initRuleDescriptionButton
{
    CGRect rc = CGRectMake(0.0f, ScreenHeight-80 - 40, ScreenWidth/2 + 20, 70.0f);
    
    self.ruleDescriptionButton = [[UIButton alloc] initWithFrame:rc];
    [self.ruleDescriptionButton setTitle:@"规则说明" forState:UIControlStateNormal];
    [self.ruleDescriptionButton.titleLabel setFont:[UIFont boldSystemFontOfSize:LABELFONTSIZE]];
    [self.ruleDescriptionButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.ruleDescriptionButton addTarget:self action:@selector(ruleDescriptionPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.ruleDescriptionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:self.ruleDescriptionButton];
    
    rc = CGRectMake(ScreenWidth/2 + 20 + 10, ScreenHeight-80 - 13, 15, 15);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rc];
    imgView.image = [UIImage imageNamed:@"system-msg-icon"];
    [self.view addSubview:imgView];
}

- (void)confirmButtonPressed:(id)sender
{
    if (self.currentSelectIndex + 1 == self.subscribeId) {
        [MBHudUtil showTextView:@"请选择想订阅的群组" inView:nil];
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要订阅该等级？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 0;
    
    [alertView show];
}

- (void)ruleDescriptionPressed:(id)sender
{
    UIView *bgView = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:KTagBgBiew];
    
    if (bgView) {
        bgView.hidden = NO;
    }else{
        UIView *bgView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        bgView.tag = KTagBgBiew;
        bgView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.600];
        [[UIApplication sharedApplication].keyWindow addSubview:bgView];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake((ScreenWidth - HHAlertSingleView_SIZE_WIDTH)/2, (ScreenHeight - HHAlertSingleView_SIZE_HEIGHT)/2 , HHAlertSingleView_SIZE_WIDTH, HHAlertSingleView_SIZE_HEIGHT)];
        [tableView setBackgroundColor:[UIColor whiteColor]];
        
        //这里准备跟UI要个图，回头替换一下
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"subscription_desc_bg"]];
//        tableView.backgroundView = view;
        
//        UIImageView *view = [[UIImageView alloc] initWithFrame:tableView.bounds];
//        view.image = [UIImage imageNamed:@"subscription_desc_bg"];
//        tableView.backgroundView = view;
        
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = NO;
        tableView.scrollEnabled = NO;
        [bgView addSubview:tableView];
    }

//    NSString *firstStr = @"学生在绑定老师前，或者绑定了老师未指派组时，可以自由订阅等级，在订阅的等级内按照时间推送新书";
//    NSString *secondStr = @"当被老师指定了组后，等级就被老师的组确定，且锁定，学生无法更改，直到退出组（被老师移除，或者解除绑定老师，即没有组的信息时）";
//    [HHAlertSingleView showAlertWithStyle:HHAlertStyleInstructions inView:self.view Title:@"规则说明" detailFirst:firstStr detailSecond:secondStr okButton:@"我知道了"];
}

#pragma mark - actionSheetDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        
    }else{
        HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
        if (userEntity) {
            NSString *user = userEntity.name;
            //获取用户当前订阅的套餐
            [MBHudUtil showActivityView:nil inView:nil];
            [[HBServiceManager defaultManager] requestBooksetSub:user bookset_id:[NSString stringWithFormat:@"%ld",(self.currentSelectIndex + 1)] months:@"1" completion:^(id responseObject, NSError *error) {
                if (responseObject) {
                    NSString *result = [responseObject objectForKey:@"result"];
                    if ([result isEqualToString:@"OK"]) {
                        [self requestUserBookset];
                        //学生修改订阅等级成功发通知
                        [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_ChangeSubscribeSuccess object:nil];
                    }else{
                        [MBHudUtil showTextView:@"您已经被老师绑定群组，无法自行修改" inView:nil];
                    }
                }
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
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        NSString *user = userEntity.name;
        //获取用户当前订阅的套餐
        [MBHudUtil showActivityView:nil inView:nil];
        [[HBServiceManager defaultManager] requestUserBookset:user completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                //获取用户当前订阅的套餐成功
                id tmp = [responseObject objectForKey:@"bookset_id"];
                self.subscribeId = [tmp integerValue];
                [_gridView reloadData];
                [MBHudUtil hideActivityView:nil];
            }
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((HHAlertSingleView_SIZE_WIDTH - (HHAlertSingleView_SIZE_WIDTH - 20 - 20))/2, 25, (HHAlertSingleView_SIZE_WIDTH - 20 - 20), 55)];
    imgView.image = [UIImage imageNamed:@"title-bg"];
    [view addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((HHAlertSingleView_SIZE_WIDTH - 220)/2, 25 - 4, 220, 55)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"规则说明";
    label.font = [UIFont boldSystemFontOfSize:22.0f];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((HHAlertSingleView_SIZE_WIDTH - (HHAlertSingleView_SIZE_WIDTH - 30 - 30))/2, 10, HHAlertSingleView_SIZE_WIDTH - 30 - 30, 50)];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn-normal"] forState:UIControlStateNormal];
    [btn setTitle:@"我知道了" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(knowBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:26.0f]];
    [view addSubview:btn];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (HHAlertSingleView_SIZE_HEIGHT - 90 - 70 - 10)/4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HBRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:kHBRuleCellReuseId];
    
    if (indexPath.row == 3) {
        if (!cell) {
            cell = [[HBRuleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHBRuleCellReuseId isShowLine:NO];
        }
    }else{
        if (!cell) {
            cell = [[HBRuleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHBRuleCellReuseId isShowLine:YES];
        }
    }
    
    cell.contentLabel.text = [_ruleArr objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)knowBtnPressed
{
    UIView *bgView = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:KTagBgBiew];
    bgView.hidden = YES;
}

@end
