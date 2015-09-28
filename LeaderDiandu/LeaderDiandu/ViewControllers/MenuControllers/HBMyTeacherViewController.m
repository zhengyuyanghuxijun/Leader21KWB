//
//  HBMyTeacherViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/1.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBMyTeacherViewController.h"
#import "UIViewController+AddBackBtn.h"
#import "HBTitleView.h"
#import "HBServiceManager.h"
#import "HBDataSaveManager.h"

#define KTagBindView        10001

static NSString * const KMyTeacherViewControllerCellReuseId = @"KUserInfoViewControllerCellReuseId";

@interface HBMyTeacherViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray     *_titleArr;
    
    UIView      *_bindView;
    UITableView *_tableView;
    UITextField *_textField;
}

@end

@implementation HBMyTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _titleArr = @[@"账号", @"姓名"];
    
    HBTitleView *labTitle = [HBTitleView titleViewWithTitle:@"我的老师" onView:self.view];
    [self.view addSubview:labTitle];
    
    [self addBackButton];
    
    CGRect rect = self.view.frame;
    CGRect viewFrame = CGRectMake(0, KHBNaviBarHeight, rect.size.width, rect.size.height-KHBNaviBarHeight);
    [self createBindView:viewFrame];
    [self createTableView:viewFrame];
    
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if ([[userEntity.teacher allKeys] count] > 0) {
        _tableView.hidden = NO;
    } else {
        _bindView.hidden = NO;
    }
    

    [self getMyTeacher];
}

- (void)createTableView:(CGRect)frame
{
    _tableView = [[UITableView alloc] initWithFrame:frame];
    _tableView.hidden = YES;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

- (void)createBindView:(CGRect)frame
{
    _bindView = [[UIView alloc] initWithFrame:frame];
    _bindView.hidden = YES;
    _bindView.tag = KTagBindView;
    [self.view addSubview:_bindView];
    
    float controlX = 20;
    float controlY = 20;
    float width = frame.size.width - controlX*2;
    UIImageView *editBg = [[UIImageView alloc] initWithFrame:CGRectMake(controlX, controlY, width, 50)];
    editBg.userInteractionEnabled = YES;
    UIImage *image = [UIImage imageNamed:@"user_editbg"];
    editBg.image = image;//[image resizableImageWithCapInsets:UIEdgeInsetsMake(2, 20, 2, 20) resizingMode:UIImageResizingModeStretch];
    [_bindView addSubview:editBg];
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, width-40, 40)];
    _textField.placeholder = @"请输入老师ID";
    [editBg addSubview:_textField];
    
    controlY = CGRectGetMaxY(editBg.frame)+20;
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, width, 50)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor lightGrayColor];
    tipLabel.text = @"如果您不知道老师的ID，请从您的老师处寻求帮助哦";
    tipLabel.numberOfLines = 2;
    [_bindView addSubview:tipLabel];
    
    float buttonHeight = 50;
    controlY = frame.size.height - buttonHeight - 30;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, width, buttonHeight)];
    image = [UIImage imageNamed:@"user_button"];// resizableImageWithCapInsets:UIEdgeInsetsMake(0, 100, 0, 100) resizingMode:UIImageResizingModeStretch];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"绑定老师" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(bindButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bindView addSubview:button];
}

- (void)bindButtonAction:(id)sender
{
    NSString *text = _textField.text;
    if (text == nil) {
        //TODO提示
        return;
    }
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBServiceManager defaultManager] requestTeacherAssign:userEntity.name teacher:text completion:^(id responseObject, NSError *error) {
        if (responseObject) {
            NSDictionary *dict = responseObject;
            if ([dict[@"result"] isEqualToString:@"OK"]) {
                //绑定成功
                [MBHudUtil showTextView:@"绑定成功" inView:self.view];
            }
        }
    }];
}

- (void)getMyTeacher
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    NSString *teacher = userEntity.teacher[@"name"];
    [[HBServiceManager defaultManager] requestTeacher:userEntity.name teacher:teacher completion:^(id responseObject, NSError *error) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSParameterAssert(_titleArr);
    return _titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger imgWidth = 100;
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIView *view = [[UIView alloc] init];
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-imgWidth)/2, (200-imgWidth)/2, imgWidth, imgWidth)];
    headView.image = [UIImage imageNamed:@"menu_user_pohoto"];
    [view addSubview:headView];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(_titleArr);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KMyTeacherViewControllerCellReuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KMyTeacherViewControllerCellReuseId];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [_titleArr objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
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
