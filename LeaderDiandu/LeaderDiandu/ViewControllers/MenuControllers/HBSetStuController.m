//
//  HBSetStuController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/16.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBSetStuController.h"
#import "UIViewController+AddBackBtn.h"
#import "HBTitleView.h"
#import "HBStudentEntity.h"
#import "HBSetStuGroupCell.h"
#import "HBSetStuOtherCell.h"

static NSString * const KGroupStuCellReuseId = @"KGroupStuCellReuseId";
static NSString * const KOtherStuCellReuseId = @"KOtherStuCellReuseId";

@implementation HBSetStuController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.groupStuArr = [[NSMutableArray alloc] initWithCapacity:1];
        self.otherStuArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HBTitleView *labTitle = [HBTitleView titleViewWithTitle:self.titleStr onView:self.view];
    [self.view addSubview:labTitle];
    
    [self addBackButton];
    
    [self addTableView];
}

-(void)addTableView
{
    CGRect rect = self.view.frame;
    CGRect viewFrame = CGRectMake(0, KHBNaviBarHeight, rect.size.width, rect.size.height-KHBNaviBarHeight);
    _tableView = [[UITableView alloc] initWithFrame:viewFrame];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger number = 0;
    if (self.groupStuArr.count > 0 && self.otherStuArr.count > 0) {
        number = 2;
    }else if (self.groupStuArr.count > 0 || self.otherStuArr.count > 0){
        number = 1;
    }
    
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (0 == section) {
        if (self.groupStuArr.count > 0) {
            return self.groupStuArr.count;
        }else{
            return self.otherStuArr.count;
        }
    }else{
        return self.otherStuArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat width = tableView.bounds.size.width;
    CGRect frame = CGRectMake(0, 0, width, 40);
    UIView *placeholderSectionHeaderView = [[UIView alloc] initWithFrame:frame];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, width, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    
    [placeholderSectionHeaderView addSubview:titleLabel];
    
    if (0 == section)
    {
        if (self.groupStuArr.count > 0){
            titleLabel.text = @"群组学生";
        }else{
            titleLabel.text = @"以下学生可以添加到群组";
        }
    }else{
        titleLabel.text = @"以下学生可以添加到群组";
    }

    return placeholderSectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        if (self.groupStuArr.count > 0) {
            HBSetStuGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:KGroupStuCellReuseId];
            if (!cell) {
                cell = [[HBSetStuGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KGroupStuCellReuseId];
            }
            
            HBStudentEntity *studentEntity = [self.groupStuArr objectAtIndex:indexPath.row];
            [cell updateFormData:studentEntity.displayName];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor blackColor];
            
            return cell;
        }else{
            HBSetStuOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:KOtherStuCellReuseId];
            if (!cell) {
                cell = [[HBSetStuOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KOtherStuCellReuseId];
            }
            
            HBStudentEntity *studentEntity = [self.otherStuArr objectAtIndex:indexPath.row];
            [cell updateFormData:studentEntity.displayName];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor blackColor];
            
            return cell;
        }
    }else{
        HBSetStuOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:KOtherStuCellReuseId];
        if (!cell) {
            cell = [[HBSetStuOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KOtherStuCellReuseId];
        }
        
        HBStudentEntity *studentEntity = [self.otherStuArr objectAtIndex:indexPath.row];
        [cell updateFormData:studentEntity.displayName];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor blackColor];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
