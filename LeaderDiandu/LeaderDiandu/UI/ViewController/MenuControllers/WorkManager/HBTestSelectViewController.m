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
#import "UIImageView+AFNetworking.h"

@implementation HBTestSelectViewCell

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
    //书皮
    self.cellImgView = [[UIImageView alloc] init];
    self.cellImgView.frame = CGRectMake(10, 10, 80, 100);
    [self addSubview:self.cellImgView];
    
    //书名
    self.cellContentLabel = [[UILabel alloc] init];
    self.cellContentLabel.frame = CGRectMake(100, 0, HBFullScreenWidth - 100, 100);
    [self addSubview:self.cellContentLabel];
    
    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 120 - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    seperatorLine.backgroundColor = HEXRGBCOLOR(0xff8903);
    [self addSubview:seperatorLine];
}

-(void)updateFormData:(id)sender
{
    HBContentDetailEntity *contentDetailEntity = (HBContentDetailEntity*)sender;
    
    if (contentDetailEntity) {
        NSString *fileIdStr = contentDetailEntity.FILE_ID;
        fileIdStr = [fileIdStr lowercaseString];
        NSString *urlStr = [NSString stringWithFormat:KHBBookImgFormatUrl, fileIdStr, fileIdStr];
        [self.cellImgView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"mainGrid_defaultBookCover"]];
        
        if ([[HBDataSaveManager defaultManager] showEnBookName]) {
            self.cellContentLabel.text = contentDetailEntity.BOOK_TITLE;
        }else{
            self.cellContentLabel.text = contentDetailEntity.BOOK_TITLE_CN;
        }
    }
}

@end

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
    CGRect viewFrame = CGRectMake(0, 0, rect.size.width, HBFullScreenHeight);
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
    return self.testArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HBTestSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KHBTestSelectViewControllerCellReuseId"];
    if (!cell) {
        cell = [[HBTestSelectViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KHBTestSelectViewControllerCellReuseId"];
    }
    
    HBContentDetailEntity *contentDetailEntity = [self.testArray objectAtIndex:indexPath.row];

    [cell updateFormData:contentDetailEntity];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate selectedTest:[self.testArray objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
