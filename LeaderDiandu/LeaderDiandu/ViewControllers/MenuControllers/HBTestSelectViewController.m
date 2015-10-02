//
//  HBTestSelectViewController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/13.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBTestSelectViewController.h"
#import "HBDataSaveManager.h"
#import "HBServiceManager.h"
#import "HBContentManager.h"
#import "HBContentListDB.h"
#import "HBContentDetailDB.h"

@interface HBTestSelectViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, strong) NSMutableArray* testArray;

@end

@implementation HBTestSelectViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.testArray = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"发布作业";
    
    NSString *booksIDStr = [[HBContentListDB sharedInstance] booksidWithID:self.bookset_id];
    if (booksIDStr != nil && booksIDStr.length > 0) {
        NSArray *booksIDArr = [booksIDStr componentsSeparatedByString:@","];
        self.testArray = [[HBContentDetailDB sharedInstance] booksWithBooksIDArr:booksIDArr];
        if (self.testArray == nil || 0 == self.testArray.count) {
            [[HBContentManager defaultManager] requestBookList:booksIDStr completion:^(id responseObject, NSError *error) {
                if (responseObject){
                    //获取书本列表成功
                    NSArray *arr = [responseObject objectForKey:@"books"];
                    [[HBContentDetailDB sharedInstance] updateHBContentDetail:arr];
                    self.testArray = [[HBContentDetailDB sharedInstance] booksWithBooksIDArr:booksIDArr];
                    if (self.testArray != nil && self.testArray.count > 0) {
                        [self addTableView];
                    }else{
                        //无数据
                    }
                }
            }];
        }else{
            [self addTableView];
        }
    }
}

-(void)addTableView
{
    CGRect rect = self.view.frame;
    CGRect viewFrame = CGRectMake(0, KHBNaviBarHeight, rect.size.width, ScreenHeight - KHBNaviBarHeight);
    _tableView = [[UITableView alloc] initWithFrame:viewFrame];
    _tableView.dataSource = self;
    _tableView.delegate = self;
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
    return self.testArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KHBTestSelectViewControllerCellReuseId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KHBTestSelectViewControllerCellReuseId"];
    }
    
    HBContentDetailEntity *contentDetailEntity = [self.testArray objectAtIndex:indexPath.row];
    if ([[HBDataSaveManager defaultManager] showEnBookName]) {
        cell.textLabel.text = contentDetailEntity.BOOK_TITLE;
    }else{
        cell.textLabel.text = contentDetailEntity.BOOK_TITLE_CN;
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate selectedTest:[self.testArray objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
