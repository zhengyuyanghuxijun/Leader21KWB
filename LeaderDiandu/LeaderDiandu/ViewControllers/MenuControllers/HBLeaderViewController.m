//
//  HBLeaderViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/2.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBLeaderViewController.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"
#import "HBLeaderBindingCell.h"

static NSString * const KLeaderBindingCellReuseId = @"KLeaderBindingCellReuseId";
static NSString * const KLeaderUnBindingCellReuseId = @"KLeaderUnBindingCellReuseId";

@interface HBLeaderViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    UIButton *_bottomBtn;
}

@property (strong, nonatomic) NSString *accountStr;
@property (strong, nonatomic) NSString *nameStr;

@property (nonatomic, assign) BOOL isBinding;
@property (nonatomic, strong) NSMutableArray *leadersArr;

@end

@implementation HBLeaderViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.accountStr = nil;
        self.nameStr = nil;
        self.isBinding = NO;
        self.leadersArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"我的教研员";
    
    //获取教研员信息，知道是否绑定状态
    [self getUserInfo];
}

- (void)getUserInfo
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBServiceManager defaultManager] requestUserInfo:userEntity.name token:userEntity.token completion:^(id responseObject, NSError *error) {
        if (responseObject) {
            NSDictionary *dic = [responseObject objectForKey:@"director"];
            if (dic) {
                //不为空，表示绑定了教研员
                self.isBinding = YES;
                self.accountStr = [dic objectForKey:@"name"];
                self.nameStr = [dic objectForKey:@"display_name"];
                [self addTableView];
                [self addBottomBtn];
            }else{
                //为空，表示没有绑定教研员，需要获取教研员列表（等待提供接口）
                self.isBinding = NO;
            }
        }
    }];
}

-(void)addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 60)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
}

-(void)addBottomBtn
{
    //底部按钮
    CGRect rc = CGRectMake(10.0f, ScreenHeight - 60.0f, ScreenWidth - 10 - 10, 50.0f);
    _bottomBtn = [[UIButton alloc] initWithFrame:rc];
    [_bottomBtn setBackgroundImage:[UIImage imageNamed:@"user_button"] forState:UIControlStateNormal];
    if (self.isBinding) {
        [_bottomBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
    }else{
        [_bottomBtn setTitle:@"绑定教研员" forState:UIControlStateNormal];
    }

    [_bottomBtn addTarget:self action:@selector(bottomBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomBtn];
}

-(void)bottomBtnPressed
{
    if (self.isBinding) {
        
    }else{
        
    }
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
    if (self.isBinding) {
        return 2;
    }else{
        return self.leadersArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isBinding){
        return 200;
    }else{
        return 0;
    }
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
    if (self.isBinding) {

        HBLeaderBindingCell *cell = [tableView dequeueReusableCellWithIdentifier:KLeaderBindingCellReuseId];
        if (!cell) {
            cell = [[HBLeaderBindingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KLeaderBindingCellReuseId];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        if (0 == indexPath.row) {
            [dic setObject:@"账号" forKey:@"title"];
            [dic setObject:self.accountStr forKey:@"content"];
        }else{
            [dic setObject:@"名字" forKey:@"title"];
            [dic setObject:self.nameStr forKey:@"content"];
        }
        
        [cell updateFormData:dic];
        
        return cell;

    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KLeaderUnBindingCellReuseId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KLeaderUnBindingCellReuseId];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"姓名";
        
        if (0 == indexPath.row) {
            cell.textLabel.text = self.accountStr;
        }else{
            cell.textLabel.text = self.nameStr;
        }
        
        cell.textLabel.textColor = [UIColor blackColor];
        
        return cell;
    }
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
