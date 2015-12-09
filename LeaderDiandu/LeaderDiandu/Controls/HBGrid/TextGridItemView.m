//
//  TextGridItemView.m
//  HBGridView
//
//  Created by wxj on 12-10-12.
//  Copyright (c) 2012年 tt. All rights reserved.
//

#import "TextGridItemView.h"
#import "UIButton+AFNetworking.h"
#import "UIViewAdditions.h"

#import "Leader21SDKOC.h"

#define LABELFONTSIZE 14.0f

@interface MyProgressView()
{
    UIImageView *_trackView;
    UIImageView *_progressView;
}

@end

@implementation MyProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void) initUI
{
    CGSize size = self.frame.size;
    
    //进度未填充部分显示的图像
    _trackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    UIImage *trackImage = [UIImage imageNamed:@"bookshelf-bg-progress-bg"];
    _trackView.image = trackImage;
    [self addSubview:_trackView];
    
    //背景VIEW
    UIView *progressViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    progressViewBg.clipsToBounds = YES;//当前view的主要作用是将出界了的_progressView剪切掉，所以需将clipsToBounds设置为YES
    [self addSubview:progressViewBg];
    
    //进度填充部分显示的图像
    _progressView = [[UIImageView alloc] init];
    UIImage *progressImage = [UIImage imageNamed:@"bookshelf-bg-progress"];
    _progressView.image = progressImage;
    [self setProgress:0.0f];//设置进度
    [progressViewBg addSubview:_progressView];
}

-(void)setProgress:(float)fProgress
{
    float progress = fProgress;
    CGSize size = self.frame.size;
    _progressView.frame = CGRectMake(0, 0, size.width * progress, size.height);
}

@end

@interface TextGridItemView()
{
    UILabel *_readProgressLabel;
    MyProgressView *_progressControl;
    UILabel *_bookNameLabel;
    UIButton *_downloadButton;
    UIButton *_bookCoverButton;
}

@property (strong, nonatomic) UILabel *readProgressLabel;
@property (strong, nonatomic) UIButton * downloadButton;
@property (strong, nonatomic) UIImageView * isVipImg;

@end

@implementation TextGridItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        [self initUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:kNotification_bookDownloadProgress object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setText:(NSString *)text
{
    self.bookNameLabel.text = text;
}

- (void)setDemoImage:(NSString *)imgFile
{
    if (_bookCoverButton) {
        [_bookCoverButton setBackgroundImage:[UIImage imageNamed:@"cover_get_more"] forState:UIControlStateNormal];
    }
    [self setContorlHidden:YES];
}

- (void)setContorlHidden:(BOOL)isHidden
{
    _bookNameLabel.hidden = isHidden;
    _downloadButton.hidden = isHidden;
    _isVipImg.hidden = isHidden;
    _readProgressLabel.hidden = isHidden;
    _progressView.hidden = isHidden;
}

- (void) initUI
{
    //阅读进度Label
    self.readProgressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.frame.size.width, 25)];
    self.readProgressLabel.textAlignment = NSTextAlignmentCenter;
    self.readProgressLabel.hidden = YES;
    self.readProgressLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self addSubview:self.readProgressLabel];
    
    //阅读进度条
    _progressControl = [[MyProgressView alloc] initWithFrame:CGRectMake(15, 30, self.frame.size.width - 30, 6)];
    _progressControl.hidden = YES;
    [self addSubview:_progressControl];
    
    //下载按钮
    self.downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downloadButton.frame = CGRectMake((self.frame.size.width - 60)/2, 10, 60, 25);
    [self.downloadButton addTarget:self action:@selector(downloadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.downloadButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.downloadButton.titleLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self addSubview:self.downloadButton];
    
    //书籍名称
    self.bookNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.downloadButton.frame) + 5, self.frame.size.width - 30, 20)];
    self.bookNameLabel.textAlignment = NSTextAlignmentCenter;
    self.bookNameLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];;
    [self addSubview:self.bookNameLabel];
    
    //书籍封皮
    self.bookCoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSInteger height = 120;
    NSInteger controlX = 10;
    if (iPhone5) {
        height = 100;
    } else if (iPhone6) {
        controlX = 15;
    } else if (iPhone6Plus) {
        controlX = 20;
    }
    self.bookCoverButton.frame = CGRectMake(controlX, CGRectGetMaxY(self.bookNameLabel.frame), self.frame.size.width - controlX*2, height);
    [self.bookCoverButton addTarget:self action:@selector(bookCoverButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bookCoverButton];
    
    //是否VIP的标签
    self.isVipImg = [[UIImageView alloc] init];
    self.isVipImg.frame = CGRectMake(self.bookCoverButton.frame.size.width-30, 0, 30, 30);
    [self.bookCoverButton addSubview:self.isVipImg];
    
    CGRect rect = CGRectMake(0, CGRectGetMaxY(self.bookCoverButton.frame) - 4, self.frame.size.width, 50);
    UIImageView *navView = [[UIImageView alloc] initWithFrame:rect];
    navView.image = [UIImage imageNamed:@"bookshelf-bg-shelf"];
    [self addSubview:navView];
    
    self.progressView = [[MBProgressHUD alloc] initWithView:self];
    self.progressView.mode = MBProgressHUDModeDeterminate;
    self.progressView.backgroundBg = [self imageWithColor:[UIColor clearColor] size:CGSizeMake(1.0f, 1.0f)];
    self.progressView.userInteractionEnabled = NO;
    [self addSubview:self.progressView];
    
    self.progressView.hidden = YES;
    [self.progressView show:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat progressY = 15;
    self.progressView.frame = CGRectMake(0, progressY, self.bounds.size.width, self.bounds.size.height);
}

-(void)downloadButtonPressed:(id)sender
{
    UIButton *button = sender;
    if ([button.titleLabel.text isEqualToString:@"作业"]) {
        self.isTest = YES;
    }
    [self didTap];
    self.isTest = NO;
}

-(void)bookCoverButtonPressed:(id)sender
{
    [self didTap];
}

-(void)updateFormData:(NSDictionary*)dic
{
    [self setContorlHidden:NO];
    //下载按钮
    if ([dic objectForKey:TextGridItemView_downloadState])
    {
        [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"bookshelf-btn-download"] forState:UIControlStateNormal];
    }
    
    //书籍名称
    if ([dic objectForKey:TextGridItemView_BookName])
    {
        self.bookNameLabel.text = [dic objectForKey:TextGridItemView_BookName];
    }
    
    //书籍封皮
    if ([dic objectForKey:TextGridItemView_BookCover])
    {
        NSString *fileIdStr = [dic objectForKey:TextGridItemView_BookCover];
        fileIdStr = [fileIdStr lowercaseString];
        NSString *urlStr = [NSString stringWithFormat:KHBBookImgFormatUrl, fileIdStr, fileIdStr];
        [self.bookCoverButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"mainGrid_defaultBookCover"]];
    }
    
    //是否vip标识 1:vip 0:free
    if ([dic objectForKey:TextGridItemView_isVip])
    {
        NSString *isVipStr = [dic objectForKey:TextGridItemView_isVip];
        if ([isVipStr isEqualToString:@"1"]) {
            [self.isVipImg setImage:[UIImage imageNamed:@"bookshelf-icon-vip"]];
        }else{
            [self.isVipImg setImage:[UIImage imageNamed:@"bookshelf-icon-free"]];
        }
    }

    //刷新cell
    [self setNeedsLayout];
}

- (void)updateProgress:(NSNotification*)notification
{
    BookEntity* book = (BookEntity*)notification.object;
    NSInteger status = book.download.status.integerValue;
    
    if ([book.bookUrl isEqualToString:self.bookDownloadUrl]){
        if (status == downloadStatusFinished) {
//            [self bookDownloaded:book progress:@"0" isTask:NO];
            [self.delegate reloadGridView];
        } else if (status == downloadStatusDownloading){
            [self bookDownloading:book];
        } else if (status == downloadStatusNone){
            [self bookUnDownload:book];
        } else if (status == downloadStatusDownloadFailed) {
            [self bookUnDownload:book];
        }
    }
}

- (void)teacherBookDownloaded:(BookEntity *)book
{
    //已下载（老师和教研员账户显示“作业”）
    self.progressView.hidden = YES;
    self.readProgressLabel.hidden = YES;
    self.downloadButton.hidden = NO;
    _progressControl.hidden = YES;
    [self.downloadButton setTitle:@"作业" forState:UIControlStateNormal];
    [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"bookshelf-btn-test"] forState:UIControlStateNormal];
}

- (void)bookDownloaded:(BookEntity *)book progress:(NSString *)progress isTask:(BOOL)isTask
{
    //已下载（阅读完成显示“作业”，未完成显示进度条）
    self.progressView.hidden = YES;
    
    if ([progress isEqualToString:@"100"] && isTask == YES) {
        self.readProgressLabel.hidden = YES;
        self.downloadButton.hidden = NO;
        _progressControl.hidden = YES;
        [self.downloadButton setTitle:@"作业" forState:UIControlStateNormal];
        [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"bookshelf-btn-test"] forState:UIControlStateNormal];
    }else{
        self.readProgressLabel.hidden = NO;
        self.downloadButton.hidden = YES;
        _progressControl.hidden = NO;
        
        if (progress == nil) {
            progress = @"0";
        }
        
        [_progressControl setProgress:[progress integerValue]/100.0f];
        self.readProgressLabel.text = [NSString stringWithFormat:@"Read %@%@", progress, @"%"];
    }
}

- (void)bookDownloading:(BookEntity *)book
{
    self.readProgressLabel.hidden = YES;
    self.downloadButton.hidden = NO;
    _progressControl.hidden = YES;
    
    //正在下载
    CGFloat progress = book.download.progress.floatValue;
    if (progress <= 0.005f || progress >= 1.0f) {
        progress = 0.005f;
    }
    NSLog(@"download progress:%f", progress);

    [self.downloadButton setTitle:@"下载中" forState:UIControlStateNormal];
    [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"bookshelf-btn-test"] forState:UIControlStateNormal];

    self.progressView.hidden = NO;
    self.progressView.alpha = 1.0f;
    self.progressView.progress = progress;
}

- (void)bookUnDownload:(BookEntity *)book
{
    self.readProgressLabel.hidden = YES;
    self.downloadButton.hidden = NO;
    _progressControl.hidden = YES;
    
    //未下载
    self.progressView.hidden = YES;
    [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"bookshelf-btn-download"] forState:UIControlStateNormal];
}

- (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size
{
    CGRect frame = CGRectZero;
    
    BOOL resizeable = NO;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(5.0f, 5.0f);
        resizeable = YES;
    }
    
    frame.size = size;
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (resizeable) {
        UIEdgeInsets inset = UIEdgeInsetsMake(size.height/2.0f-1, size.width/2.0f-1, size.height/2.0+1, size.width/2.0+1);
        UIImage* result = [image resizableImageWithCapInsets:inset];
        return result;
    }
    else {
        return image;
    }
}

@end
