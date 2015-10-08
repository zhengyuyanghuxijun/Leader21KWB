//
//  HBBookManViewController.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/18.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBBookManViewController.h"
#import "UIImageView+AFNetworking.h"
#import "HBTestWorkManager.h"
#import "HBDataSaveManager.h"

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
    self.cellSelectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, (70 - 20)/2, 20, 20)];
    [self.cellSelectedBtn setBackgroundImage:[UIImage imageNamed:@"selected_off"] forState:UIControlStateDisabled];
    [self.cellSelectedBtn setEnabled:NO];
    [self addSubview:self.cellSelectedBtn];
    
    //书籍封皮
    self.cellBookCoverImg = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 20 + 10, (70 - 50)/2, 40, 50)];
    [self addSubview:self.cellBookCoverImg];
    
    //书籍名称
    self.cellBookName = [[UILabel alloc] init];
    self.cellBookName.frame = CGRectMake(self.cellBookCoverImg.frame.origin.x + self.cellBookCoverImg.frame.size.width + 10, (70 - 30)/2, 200, 30);
    [self addSubview:self.cellBookName];
    
    //书籍大小
    self.cellBookSize = [[UILabel alloc] init];
    self.cellBookSize.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 70, (70 - 30)/2, 60, 30);
    self.cellBookSize.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.cellBookSize];
    
    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 70 - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    seperatorLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:seperatorLine];
}

-(void)updateFormData:(BookEntity *)aBookEntity;
{
    self.bookEntity = aBookEntity;
    NSString *bookName;
    if ([[HBDataSaveManager defaultManager] showEnBookName]) {
        bookName = self.bookEntity.bookTitle;
    }else{
        bookName = self.bookEntity.bookTitleCN;
    }
    self.cellBookName.text = bookName;
    
    NSString *fileIdStr = [self.bookEntity.fileId lowercaseString];
    NSString *urlStr = [NSString stringWithFormat:KHBBookImgFormatUrl, fileIdStr, fileIdStr];
    [self.cellBookCoverImg setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"mainGrid_defaultBookCover"]];
}

-(void)updateBookSize:(NSInteger)aBookSize
{
    self.cellBookSize.text = [NSString stringWithFormat:@"%ld%@", aBookSize, @"M"];
}

-(void)selectedBtnPressed
{
    if (self.checked) {
        self.checked = NO;
        [self.cellSelectedBtn setBackgroundImage:[UIImage imageNamed:@"selected_off"] forState:UIControlStateDisabled];
    }else{
        self.checked = YES;
        [self.cellSelectedBtn setBackgroundImage:[UIImage imageNamed:@"selected_on"] forState:UIControlStateDisabled];
    }
}

-(void)setSelectedBtnStatus:(BOOL)selected;
{
    if (selected) {
        self.checked = YES;
        [self.cellSelectedBtn setBackgroundImage:[UIImage imageNamed:@"selected_on"] forState:UIControlStateDisabled];
    }else{
        self.checked = NO;
        [self.cellSelectedBtn setBackgroundImage:[UIImage imageNamed:@"selected_off"] forState:UIControlStateDisabled];
    }
}

@end

@interface HBBookManViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, strong) UILabel       *describeLabel;
@property (nonatomic, strong) UIButton      *selectedAllBtn;
@property (nonatomic, strong) UILabel       *isSelectedAllLabel;
@property (nonatomic, strong) UILabel       *selectedLabel;
@property (nonatomic, strong) UILabel       *selectedSizeLabel;
@property (nonatomic, strong) UIButton      *deleteBtn;

@property (nonatomic, assign) BOOL  checkedAll; //是否全选
@property (nonatomic, assign) NSInteger localBookSize; //本地图书总大小
@property (nonatomic, strong) NSMutableArray *bookEntityarr; //本地图书数组
@property (nonatomic, strong) NSMutableDictionary *bookEntityDic; //本地图书字典 key为fileId value为书籍对象
@property (nonatomic, strong) NSMutableDictionary *bookSizeDic; //key为fileId value为书籍大小
@property (nonatomic, strong) NSMutableDictionary *bookSelectedDic; //key为fileId value是否已选择

@end

@implementation HBBookManViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.localBookSize = 0;
        self.checkedAll = NO;
        self.bookEntityarr = [[NSMutableArray alloc] initWithCapacity:1];
        self.bookSizeDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        self.bookSelectedDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        self.bookEntityDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"本地图书管理";
    
    [self loadBookDate];
    [self creatDescribeLabel];
    [self creatFooterView];
    
    if (self.bookEntityarr.count > 0) {
        [self addTableView];
    }
}

-(void)creatDescribeLabel
{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, KHBNaviBarHeight, ScreenWidth, 44);
    bgView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bgView];
    
    self.describeLabel = [[UILabel alloc] init];
    self.describeLabel.frame = CGRectMake(10, KHBNaviBarHeight, ScreenWidth, 44);
    self.describeLabel.text = [NSString stringWithFormat:@"本地图书共%ldM,存储空间剩余%@", self.localBookSize, [self freeSpace]];
    [self.view addSubview:self.describeLabel];
}

-(void)addTableView
{
    CGRect rect = CGRectMake(0, KHBNaviBarHeight + 44, ScreenWidth, ScreenHeight - KHBNaviBarHeight - 44 - 60);
    _tableView = [[UITableView alloc] initWithFrame:rect];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
}

-(void)creatFooterView
{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, ScreenHeight - 60, ScreenWidth, 60);
    bgView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bgView];

    //全选按钮
    self.selectedAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, (60 - 20)/2, 20, 20)];
    [self.selectedAllBtn setBackgroundImage:[UIImage imageNamed:@"selected_off"] forState:UIControlStateNormal];
    [self.selectedAllBtn addTarget:self action:@selector(selectedAllBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.selectedAllBtn];
    
    //是否全选Label
    self.isSelectedAllLabel = [[UILabel alloc] init];
    self.isSelectedAllLabel.frame = CGRectMake(self.selectedAllBtn.frame.origin.x + 20 + 10, (60 - 30)/2, 50, 30);
    self.isSelectedAllLabel.text = @"全选";
    [bgView addSubview:self.isSelectedAllLabel];
    
    //删除按钮
    self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 80, 0, 80, 60)];
    self.deleteBtn.backgroundColor = [UIColor redColor];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.deleteBtn];
    
    //已选择Label
    self.selectedLabel = [[UILabel alloc] init];
    self.selectedLabel.frame = CGRectMake(self.deleteBtn.frame.origin.x - 200 - 10, 0, 200, 30);
    self.selectedLabel.text = [NSString stringWithFormat:@"已选择%d本", 0];
    self.selectedLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:self.selectedLabel];
    
    //选择的书籍大小Label
    self.selectedSizeLabel = [[UILabel alloc] init];
    self.selectedSizeLabel.frame = CGRectMake(self.deleteBtn.frame.origin.x - 200 - 10, 30, 200, 30);
    self.selectedSizeLabel.text = @"0M";
    self.selectedSizeLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:self.selectedSizeLabel];
}

-(void)deleteBtnPressed
{
    NSMutableArray *selectedArr = [[NSMutableArray alloc] initWithCapacity:1];
    for (NSString *selectedStrKey in self.bookSelectedDic) {
        NSString *selectedStr = [self.bookSelectedDic objectForKey:selectedStrKey];
        if ([selectedStr isEqualToString:@"1"]) {
            [selectedArr addObject:[self.bookEntityDic objectForKey:selectedStrKey]];
        }
    }

    if (selectedArr.count > 0) {
        //删除本地书籍
        [LEADERSDK deleteLocalBooks:selectedArr];
        
        [self updateViewDate];
    }
}

-(void)updateViewDate
{
    [self loadBookDate];
    self.describeLabel.text = [NSString stringWithFormat:@"本地图书共%ldM,存储空间剩余%@", self.localBookSize, [self freeSpace]];
    [self.selectedAllBtn setBackgroundImage:[UIImage imageNamed:@"selected_off"] forState:UIControlStateNormal];
    self.isSelectedAllLabel.text = @"全选";
    self.selectedLabel.text = [NSString stringWithFormat:@"已选择%d本", 0];
    self.selectedSizeLabel.text = @"0M";
    self.checkedAll = NO;
    
    if (self.bookEntityarr.count > 0) {
        _tableView.hidden = NO;
        [_tableView reloadData];
    }else{
        _tableView.hidden = YES;
    }
}

-(void)loadBookDate
{
    self.localBookSize = 0;
    [self.bookSelectedDic removeAllObjects];
    [self.bookEntityDic removeAllObjects];
    [self.bookSizeDic removeAllObjects];
    
    self.bookEntityarr = [LEADERSDK getLocalBooks];
    for (BookEntity *bookEntity in self.bookEntityarr) {
        NSString* fileName = [bookEntity.fileId lowercaseString];
        NSString* path = [LocalSettings bookPathForDefaultUser:fileName];
        long bookSize = [HBTestWorkManager fileSizeForDir:path];
        
        [self.bookSelectedDic setObject:@"0" forKey:bookEntity.fileId];
        [self.bookEntityDic setObject:bookEntity forKey:bookEntity.fileId];
        [self.bookSizeDic setObject:[NSString stringWithFormat:@"%ld", bookSize / 1024] forKey:bookEntity.fileId];
        
        self.localBookSize += bookSize / 1024;
    }
}

-(void)selectedAllBtnPressed
{
    if (self.checkedAll) {
        self.checkedAll = NO;
        [self.selectedAllBtn setBackgroundImage:[UIImage imageNamed:@"selected_off"] forState:UIControlStateNormal];
        self.isSelectedAllLabel.text = @"全选";
        self.selectedLabel.text = [NSString stringWithFormat:@"已选择%d本", 0];
        self.selectedSizeLabel.text = [NSString stringWithFormat:@"0M"];
        for (BookEntity *bookEntity in self.bookEntityarr) {
            [self.bookSelectedDic setObject:@"0" forKey:bookEntity.fileId];
        }
    }else{
        self.checkedAll = YES;
        [self.selectedAllBtn setBackgroundImage:[UIImage imageNamed:@"selected_on"] forState:UIControlStateNormal];
        self.isSelectedAllLabel.text = @"取消";
        self.selectedLabel.text = [NSString stringWithFormat:@"已选择%ld本", self.bookEntityarr.count];
        self.selectedSizeLabel.text = [NSString stringWithFormat:@"%ldM", self.localBookSize];
        for (BookEntity *bookEntity in self.bookEntityarr) {
            [self.bookSelectedDic setObject:@"1" forKey:bookEntity.fileId];
        }
    }
    
    [_tableView reloadData];
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
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HBBookInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KHBBookManViewControllerCellReuseId"];
    
    if (!cell) {
        cell = [[HBBookInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KHBBookManViewControllerCellReuseId"];
    }
    
    BookEntity *bookEntity = [self.bookEntityarr objectAtIndex:indexPath.row];
    [cell updateFormData:bookEntity];
    [cell updateBookSize:[[self.bookSizeDic objectForKey:bookEntity.fileId] integerValue]];
    NSString *isSelected = [self.bookSelectedDic objectForKey:bookEntity.fileId];
    if ([isSelected isEqualToString:@"1"]) {
        [cell setSelectedBtnStatus:YES];
    }else{
        [cell setSelectedBtnStatus:NO];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HBBookInfoCell *cell = (HBBookInfoCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSString *isSelected = [self.bookSelectedDic objectForKey:cell.bookEntity.fileId];
    if ([isSelected isEqualToString:@"1"]) {
        [self.bookSelectedDic setObject:@"0" forKey:cell.bookEntity.fileId];
    }else{
        [self.bookSelectedDic setObject:@"1" forKey:cell.bookEntity.fileId];
    }
    [cell selectedBtnPressed];
    
    NSInteger selectedBookCount = 0;
    NSInteger selectedBookSize = 0;
    for (NSString *selectedStrKey in self.bookSelectedDic) {
        NSString *selectedStr = [self.bookSelectedDic objectForKey:selectedStrKey];
        if ([selectedStr isEqualToString:@"1"]) {
            selectedBookCount++;
            
            NSString *selectedSizeStr = [self.bookSizeDic objectForKey:selectedStrKey];
            selectedBookSize += [selectedSizeStr integerValue];
        }
    }
    self.selectedLabel.text = [NSString stringWithFormat:@"已选择%ld本", selectedBookCount];
    self.selectedSizeLabel.text = [NSString stringWithFormat:@"%ldM", selectedBookSize];
    
    if (self.bookEntityarr.count == selectedBookCount) {
        [self.selectedAllBtn setBackgroundImage:[UIImage imageNamed:@"selected_on"] forState:UIControlStateNormal];
        self.isSelectedAllLabel.text = @"取消";
        self.checkedAll = YES;
    }else{
        [self.selectedAllBtn setBackgroundImage:[UIImage imageNamed:@"selected_off"] forState:UIControlStateNormal];
        self.isSelectedAllLabel.text = @"全选";
        self.checkedAll = NO;
    }
}

@end
