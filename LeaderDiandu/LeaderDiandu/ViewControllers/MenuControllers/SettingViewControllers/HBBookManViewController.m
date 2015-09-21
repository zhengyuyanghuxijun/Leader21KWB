//
//  HBBookManViewController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/18.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBBookManViewController.h"
#import "HBTitleView.h"
#import "UIViewController+AddBackBtn.h"
#import "UIImageView+AFNetworking.h"

#define LEADERSDK [Leader21SDKOC sharedInstance]
#define KHBBookImgFormatUrl @"http://teach.61dear.cn:9083/bookImgStorage/%@.jpg?t=BASE64(%@)"

@implementation HBBookInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.checked = NO;
        [self initUI];
    }
    return self;
}

- (void) initUI
{
    //选择按钮
    self.cellSelectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, (120 - 20)/2, 20, 20)];
    [self.cellSelectedBtn setBackgroundImage:[UIImage imageNamed:@"selected_off"] forState:UIControlStateNormal];
    [self.cellSelectedBtn addTarget:self action:@selector(selectedBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cellSelectedBtn];
    
    //书籍封皮
    self.cellBookCoverImg = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 20 + 10, (120 - 100)/2, 80, 100)];
    [self addSubview:self.cellBookCoverImg];
    
    //书籍名称
    self.cellBookName = [[UILabel alloc] init];
    self.cellBookName.frame = CGRectMake(self.cellBookCoverImg.frame.origin.x + self.cellBookCoverImg.frame.size.width + 10, (120 - 30)/2, 100, 30);
    [self addSubview:self.cellBookName];
    
    //书籍大小
    self.cellBookSize = [[UILabel alloc] init];
    self.cellBookSize.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50, (120 - 30)/2, 30, 30);
    [self addSubview:self.cellBookSize];
}

-(void)updateFormData:(BookEntity *)aBookEntity;
{
    self.bookEntity = aBookEntity;
    self.cellBookName.text = self.bookEntity.bookTitle;
    self.cellBookSize.text = @"1M";
    
    NSString *fileIdStr = [self.bookEntity.fileId lowercaseString];
    NSString *urlStr = [NSString stringWithFormat:KHBBookImgFormatUrl, fileIdStr, fileIdStr];
    [self.cellBookCoverImg setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"mainGrid_defaultBookCover"]];
}

-(void)selectedBtnPressed
{
    if (self.checked) {
        self.checked = NO;
        [self.cellSelectedBtn setBackgroundImage:[UIImage imageNamed:@"selected_off"] forState:UIControlStateNormal];
    }else{
        self.checked = YES;
        [self.cellSelectedBtn setBackgroundImage:[UIImage imageNamed:@"selected_on"] forState:UIControlStateNormal];
    }
}

@end

@interface HBBookManViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, strong) UILabel   *describeLabel;
@property (nonatomic, assign) NSInteger localBookSize;

@property (nonatomic, strong) NSMutableArray *bookEntityarr;

@end

@implementation HBBookManViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.localBookSize = 1;
        self.bookEntityarr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HBTitleView *labTitle = [HBTitleView titleViewWithTitle:@"本地图书管理" onView:self.view];
    [self.view addSubview:labTitle];
    
    [self addBackButton];
    
    [self creatDescribeLabel];
    [self addTableView];
    
    ////////////////////////////////////////////////////////////
    self.bookEntityarr = [LEADERSDK getLocalBooks];
//    for (BookEntity *bookEntity in arr) {
//        NSString *bookStr = bookEntity.bookTitle;
//        
////        DownloadEntity *downloadEntity = (DownloadEntity *)bookEntity.download;
//        DownloadEntity *downloadEntity = [[LeaderSDKUtil defaultSDKUtil] queryEntityByUrl:bookEntity.bookUrl];
//        NSNumber *tmp = downloadEntity.totalSize;
//    }
    ////////////////////////////////////////////////////////////
    
}

-(void)creatDescribeLabel
{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, KHBNaviBarHeight, ScreenWidth, 44);
    bgView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bgView];
    
    self.describeLabel = [[UILabel alloc] init];
    self.describeLabel.frame = CGRectMake(10, KHBNaviBarHeight, ScreenWidth, 44);
    NSString *describeStr = [NSString stringWithFormat:@"本地图书共%ldM,存储空间剩余%@", self.localBookSize, [self freeSpace]];
    self.describeLabel.text = describeStr;
    [self.view addSubview:self.describeLabel];
}

-(void)addTableView
{
    CGRect rect = CGRectMake(0, KHBNaviBarHeight + 44, ScreenWidth, ScreenHeight - KHBNaviBarHeight - 44 - 44);
    _tableView = [[UITableView alloc] initWithFrame:rect];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

-(NSString *)freeSpace{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSString  * freeStr= [NSString stringWithFormat:@"%0.1fM", [freeSpace longLongValue]/1024.0/1024.0];
    
    return freeStr;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.bookEntityarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HBBookInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KHBBookManViewControllerCellReuseId"];
    if (!cell) {
        cell = [[HBBookInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KHBBookManViewControllerCellReuseId"];
    }
    
    BookEntity *bookEntity = [self.bookEntityarr objectAtIndex:indexPath.row];
    [cell updateFormData:bookEntity];
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
