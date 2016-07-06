//
//  HBScoreListViewController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/7.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBScoreListViewController.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"
#import "HBScoreEntity.h"
#import "TimeIntervalUtils.h"
#import "HBHeaderManager.h"

static NSString * const KScoreListViewControllerCellReuseId = @"KScoreListViewControllerCellReuseId";

#define LABELFONTSIZE 14.0f
#define SCORELABELFONTSIZE 20.0f

@implementation HBScoreListViewCell

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
    //头像
    self.cellHeadImage = [[UIImageView alloc] init];
    self.cellHeadImage.image = [UIImage imageNamed:@"menu_user_pohoto"];
    self.cellHeadImage.frame = CGRectMake(10, 10, 50, 70 - 10 - 10);
    [self addSubview:self.cellHeadImage];
    
    //姓名
    self.cellName = [[UILabel alloc] init];
    self.cellName.frame = CGRectMake(10 + 50 + 10, 10, 150, 70/2 - 10);
    self.cellName.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self addSubview:self.cellName];
    
    //时间
    self.cellTime = [[UILabel alloc] init];
    self.cellTime.frame = CGRectMake(10 + 50 + 10, 70/2, 150, 70/2 - 10);
    self.cellTime.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self addSubview:self.cellTime];
    
    //分数
    self.cellScore = [[UILabel alloc] init];
    self.cellScore.frame = CGRectMake(HBFullScreenWidth - 100, 0, 90, 70);
    self.cellScore.textAlignment = NSTextAlignmentRight;
    self.cellScore.font = [UIFont boldSystemFontOfSize:SCORELABELFONTSIZE];
    self.cellScore.textColor = HEXRGBCOLOR(0xff8903);
    [self addSubview:self.cellScore];
    
    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0,70 - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    seperatorLine.backgroundColor = HEXRGBCOLOR(0xff8903);
    [self addSubview:seperatorLine];
}

-(void)updateFormData:(id)sender
{
    HBScoreEntity *scoreEntity = (HBScoreEntity*)sender;
    if (scoreEntity) {
        NSString *headFile = [[HBHeaderManager defaultManager] getAvatarFileByUser:scoreEntity.name];
        if (headFile) {
            //设置显示圆形头像
            self.cellHeadImage.layer.cornerRadius = 50/2;
            self.cellHeadImage.clipsToBounds = YES;
            self.cellHeadImage.image = [UIImage imageWithContentsOfFile:headFile];
            if (self.cellHeadImage.image == nil) {
                self.cellHeadImage.image = [UIImage imageNamed:@"menu_user_pohoto"];
            }
        } else {
            self.cellHeadImage.image = [UIImage imageNamed:@"menu_user_pohoto"];
        }

        self.cellName.text = scoreEntity.displayName;
        self.cellTime.text = scoreEntity.taskTime;
        if (scoreEntity.score) {
            self.cellScore.font = [UIFont boldSystemFontOfSize:SCORELABELFONTSIZE];
            self.cellScore.textColor = HEXRGBCOLOR(0xff8903);
            self.cellScore.text = scoreEntity.score;
        }else{
            self.cellScore.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
            self.cellScore.textColor = [UIColor blackColor];
            self.cellScore.text = @"未完成";
        }
    }
}

@end

@interface HBScoreListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, strong)NSMutableArray *scoreEntityArr;

@end

@implementation HBScoreListViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.scoreEntityArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.title = self.titleStr;
    
    [self requestUserScore];
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

-(void)addTableView
{
    CGRect rect = self.view.frame;
    CGRect viewFrame = CGRectMake(0, HBNavBarHeight, rect.size.width, HBFullScreenHeight);
    _tableView = [[UITableView alloc] initWithFrame:viewFrame];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
}

- (void)getHeaderAvatar:(NSString *)nameStr
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    [[HBHeaderManager defaultManager] requestGetAvatar:nameStr token:userEntity.token completion:^(id responseObject, NSError *error) {
        if (error.code == 0) {
            [_tableView reloadData];
        }
    }];
}

-(void)requestUserScore
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        NSString *user = userEntity.name;
        [[HBServiceManager defaultManager] requestUserScore:user exam_id:self.examId completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                NSArray *arr = [responseObject objectForKey:@"students"];
                for (NSDictionary *dic in arr)
                {
                    HBScoreEntity *scoreEntity = [[HBScoreEntity alloc] init];
                    scoreEntity.name = [dic objectForKey:@"name"];
                    NSString *displayName = [dic objectForKey:@"display_name"];
                    if ([displayName isEqualToString:@""]) {
                        scoreEntity.displayName = scoreEntity.name;
                    }else{
                        scoreEntity.displayName = displayName;
                    }
                    
                    NSTimeInterval interval = [[dic objectForKey:@"created_time"] doubleValue];
                    scoreEntity.taskTime = [TimeIntervalUtils getStringMDHMSFromTimeInterval:interval];
                    
                    NSString *scoreStr = [dic objectForKey:@"score"];
                    if ([scoreStr isKindOfClass:[NSNull class]] || scoreStr == nil) {
                        scoreEntity.score = nil;
                    } else {
                        scoreEntity.score = scoreStr;
                    }
                    [self.scoreEntityArr addObject:scoreEntity];
                    //获取头像
                    [self getHeaderAvatar:dic[@"name"]];
                }
                
                if (self.scoreEntityArr.count > 0) {
                    [self addTableView];
                }
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
    NSParameterAssert(self.scoreEntityArr);
    return self.scoreEntityArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(self.scoreEntityArr);
    
    HBScoreListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KScoreListViewControllerCellReuseId];
    if (!cell) {
        cell = [[HBScoreListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KScoreListViewControllerCellReuseId];
    }
    
    HBScoreEntity *scoreEntity = [self.scoreEntityArr objectAtIndex:indexPath.row];
    [cell updateFormData:scoreEntity];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
