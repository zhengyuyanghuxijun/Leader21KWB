//
//  HBMyTeacherViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/1.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBMyTeacherViewController.h"
#import "HBServiceManager.h"
#import "HBDataSaveManager.h"

#define KTagBindView        10001

#define KTeacherCellHeight  60

static NSString * const KMyTeacherViewControllerCellReuseId = @"KUserInfoViewControllerCellReuseId";

@implementation HBMyTeacherCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (void) initUI
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    float controlX = 20;
    float controlH = 25;
    float controlY = (KTeacherCellHeight-controlH*2-5)/2;
    float controlW = ScreenWidth - controlX*2;
    
    //时间
    self.cellTitle = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _cellTitle.font = [UIFont systemFontOfSize:20];
    _cellTitle.textColor = KLeaderRGB;
    [self.contentView addSubview:_cellTitle];
    
    controlY += controlH + 5;
    self.cellDesc = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _cellDesc.font = [UIFont systemFontOfSize:16];
    _cellDesc.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_cellDesc];
    
}

@end

@interface HBMyTeacherViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray     *_titleArr;
    
    UIView      *_bindView;
    UIView      *_teacherView;
    UITableView *_tableView;
    UITextField *_textField;
}

@property (nonatomic, strong)NSArray *desArray;

@end

@implementation HBMyTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _titleArr = @[@"账号", @"名字", @"群组名称", @"等级"];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"我的老师";
    
    CGRect rect = self.view.frame;
    CGRect viewFrame = CGRectMake(0, KHBNaviBarHeight, rect.size.width, rect.size.height-KHBNaviBarHeight);
    [self createBindView:viewFrame];
    [self createTableView:viewFrame];
    
    //有可能从其他客户端解除绑定老师
//    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
//    if ([[userEntity.teacher allKeys] count] > 0) {
//        [self showBindView:NO];
//        [self handleDescArray];
//    } else {
        [self getUserInfo];
//    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)keyboardHide:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)showBindView:(BOOL)isBind
{
    _bindView.hidden = !isBind;
    _teacherView.hidden = isBind;
}

- (void)handleDescArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    NSDictionary *teacherDic = userEntity.teacher;
    NSDictionary *classDic = userEntity.myClass;
    NSString *strValue = [teacherDic stringForKey:@"name" defautValue:@""];
    [array addObject:strValue];
    strValue = [teacherDic stringForKey:@"display_name" defautValue:@""];
    [array addObject:strValue];
    strValue = [classDic stringForKey:@"name" defautValue:@""];
    [array addObject:strValue];
    NSNumber *booksetId = [classDic numberForKey:@"bookset_id"];
    if (booksetId) {
        strValue = [booksetId stringValue];
    } else {
        strValue = @"";
    }
    [array addObject:strValue];
    
    self.desArray = array;
}

- (void)createTableView:(CGRect)frame
{
    _teacherView = [[UIView alloc] initWithFrame:frame];
    _teacherView.hidden = YES;
    [self.view addSubview:_teacherView];
    
    float controlX = 20;
    float width = frame.size.width - controlX*2;
    float controlH = 45;
    float controlY = frame.size.height - controlH - 30;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, width, controlH)];
    [button setBackgroundImage:[UIImage imageNamed:@"yellow-normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"yellow-press"] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"解除绑定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(unbindButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_teacherView addSubview:button];
    
    controlH = controlY - 10;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, controlH)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_teacherView addSubview:_tableView];
}

- (void)createBindView:(CGRect)frame
{
    _bindView = [[UIView alloc] initWithFrame:frame];
    _bindView.hidden = YES;
    _bindView.tag = KTagBindView;
    [self.view addSubview:_bindView];
    
    float controlX = 0;
    float controlY = 20;
    float width = frame.size.width;
    UIView *editView = [[UIView alloc] initWithFrame:CGRectMake(controlX, controlY, width, 50)];
    editView.backgroundColor = [UIColor whiteColor];
    [_bindView addSubview:editView];
    
    controlX = 20;
    width -= 20*2;
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(controlX, 5, width, 40)];
    _textField.placeholder = @"请输入老师的课外宝ID";
    [editView addSubview:_textField];
    
    controlY = CGRectGetMaxY(editView.frame)+20;
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, width, 50)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor lightGrayColor];
    tipLabel.text = @"如果你不知道老师的课外宝ID，请向你的英语老师或者同学寻求帮助哦";
    tipLabel.numberOfLines = 2;
    [_bindView addSubview:tipLabel];
    
    float buttonHeight = 45;
    controlY = frame.size.height - buttonHeight - 30;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, width, buttonHeight)];
    [button setBackgroundImage:[UIImage imageNamed:@"green-normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"green-press"] forState:UIControlStateHighlighted];
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
                [MBHudUtil showTextView:@"绑定成功" inView:nil];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self getUserInfo];
                });
            } else {
                [MBHudUtil showTextView:@"绑定失败，请重试" inView:nil];
            }
        }
    }];
}

- (void)unbindButtonAction:(id)sender
{
    [MBHudUtil showTextAlert:@"解除绑定" msg:@"确定要和老师解除绑定吗？解除绑定之后您将会自动退出该老师的群组，并且无法收到老师布置的作业。" delegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
        [MBHudUtil showActivityView:nil inView:nil];
        [[HBServiceManager defaultManager] requestTeacherUnAssign:userEntity.name completion:^(id responseObject, NSError *error) {
            [MBHudUtil hideActivityView:nil];
            if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject[@"result"] isEqualToString:@"OK"]) {
                //解除绑定成功
                [MBHudUtil showTextView:@"解除绑定成功" inView:nil];
                [self showBindView:YES];
            }
        }];
    }
}

- (void)getMyTeacher
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    NSString *teacher = userEntity.teacher[@"name"];
    [MBHudUtil showActivityView:nil inView:nil];
    [[HBServiceManager defaultManager] requestTeacher:userEntity.name teacher:teacher completion:^(id responseObject, NSError *error) {
        [MBHudUtil hideActivityView:nil];
    }];
}

- (void)getUserInfo
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [MBHudUtil showActivityView:nil inView:nil];
    [[HBServiceManager defaultManager] requestUserInfo:userEntity.name token:userEntity.token completion:^(id responseObject, NSError *error) {
        [MBHudUtil hideActivityView:nil];
        if (error.code == 0) {
            [[HBDataSaveManager defaultManager] setUserEntityByDict:responseObject];
            if ([responseObject[@"teacher"] isValidDictionary]) {
                [self showBindView:NO];
                [self handleDescArray];
                [_tableView reloadData];
            } else {
                [self showBindView:YES];
            }
        }
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
    return KTeacherCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger imgWidth = 100;
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIView *view = [[UIView alloc] init];
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-imgWidth)/2, (150-imgWidth)/2, imgWidth, imgWidth)];
    headView.image = [UIImage imageNamed:@"menu_user_pohoto"];
    [view addSubview:headView];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(_titleArr);
    
    HBMyTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:KMyTeacherViewControllerCellReuseId];
    if (!cell) {
        cell = [[HBMyTeacherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KMyTeacherViewControllerCellReuseId];
    }
    
    NSInteger index = indexPath.row;
    cell.cellTitle.text = [_titleArr objectAtIndex:index];
    cell.cellDesc.text = _desArray[index];
    
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
