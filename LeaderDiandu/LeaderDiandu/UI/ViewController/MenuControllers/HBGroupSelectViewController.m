//
//  HBGroupSelectViewController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/9.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBGroupSelectViewController.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"

@interface HBGroupSelectViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, strong) NSMutableArray* groupArray;

@end

@implementation HBGroupSelectViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.groupArray = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"发布作业";
    
    [self requestClassList];
}

-(void)requestClassList
{
    HBUserEntity *userEntity = [[HBDataSaveManager defaultManager] userEntity];
    if (userEntity) {
        NSString *user = userEntity.name;
        [MBHudUtil showActivityView:nil inView:nil];
        [[HBServiceManager defaultManager] requestClassList:user completion:^(id responseObject, NSError *error) {
            [MBHudUtil hideActivityView:nil];
            NSArray *arr = [responseObject objectForKey:@"classes"];
            for (NSDictionary *dic in arr)
            {
                HBClassEntity *classEntity = [[HBClassEntity alloc] init];
                classEntity.name = [dic objectForKey:@"name"];
                classEntity.booksetId = [[dic objectForKey:@"bookset_id"] integerValue];
                classEntity.classId = [[dic objectForKey:@"id"] integerValue];
                [self.groupArray addObject:classEntity];
            }
            if (self.groupArray.count > 0) {
                [self addTableView];
            }
        }];
    }
}

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.groupArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KHBGroupSelectViewControllerCellReuseId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KHBGroupSelectViewControllerCellReuseId"];
    }
    
    HBClassEntity *classEntity = [self.groupArray objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"icn-group"];
    
    cell.textLabel.text = classEntity.name;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor blackColor];
    
    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    seperatorLine.backgroundColor = HEXRGBCOLOR(0xff8903);
    [cell addSubview:seperatorLine];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate selectedGroup:[self.groupArray objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
