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

#define KHBBookImgFormatUrl @"http://teach.61dear.cn:9083/bookImgStorage/%@.jpg?t=BASE64(%@)"
#define LABELFONTSIZE 14.0f

@interface TextGridItemView()
{
    UILabel *_readProgressLabel;
    UIProgressView *_progressControl;
    UILabel *_bookNameLabel;
    UIButton *_downloadButton;
    UIButton *_bookCoverButton;
}

@property (strong, nonatomic) UILabel *readProgressLabel;
@property (strong, nonatomic) UILabel * bookNameLabel;
@property (strong, nonatomic) UIButton * downloadButton;
@property (strong, nonatomic) UIButton * bookCoverButton;

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

- (void) initUI
{
    //阅读进度Label
    self.readProgressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.frame.size.width, 25)];
    self.readProgressLabel.textAlignment = NSTextAlignmentCenter;
    self.readProgressLabel.hidden = YES;
    self.readProgressLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self addSubview:self.readProgressLabel];
    
    //阅读进度条
    _progressControl = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressControl.frame = CGRectMake(10, 30, self.frame.size.width - 10 - 10, 10);
    _progressControl.hidden = YES;
    
    UIImage *progressImage = [UIImage imageNamed:@"bookshelf-bg-progress"];
    UIImage *trackImage = [UIImage imageNamed:@"bookshelf-bg-progress-bg"];
    
//    //不让图片拉伸变形
//    CGFloat top = 10; // 顶端盖高度
//    CGFloat bottom = 10 ; // 底端盖高度
//    CGFloat left = 20; // 左端盖宽度
//    CGFloat right = 20; // 右端盖宽度
//    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
//    // 指定为拉伸模式，伸缩后重新赋值
//    progressImage = [progressImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
//    trackImage = [trackImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    _progressControl.trackImage = trackImage;
    _progressControl.progressImage = progressImage;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    _progressControl.transform = transform;
    
    [self addSubview:_progressControl];
    
    //下载按钮
    self.downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downloadButton.frame = CGRectMake((self.frame.size.width - 60)/2, 10, 60, 25);
    [self.downloadButton addTarget:self action:@selector(downloadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.downloadButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.downloadButton.titleLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];;
    [self addSubview:self.downloadButton];
    
    //书籍名称
    self.bookNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.downloadButton.frame.origin.y + self.downloadButton.frame.size.height + 5, self.frame.size.width - 30, 20)];
    self.bookNameLabel.textAlignment = NSTextAlignmentCenter;
    self.bookNameLabel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];;
    [self addSubview:self.bookNameLabel];
    
    //书籍封皮
    self.bookCoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bookCoverButton.frame = CGRectMake(10, self.bookNameLabel.frame.origin.y + self.bookNameLabel.frame.size.height, self.frame.size.width - 20, 120);
    [self.bookCoverButton addTarget:self action:@selector(bookCoverButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bookCoverButton];
    
    CGRect rect = CGRectMake(0, self.bookCoverButton.frame.origin.y + self.bookCoverButton.height - 4, self.frame.size.width, 50);
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
    [self didTap];
}

-(void)bookCoverButtonPressed:(id)sender
{
    [self didTap];
}

-(void)updateFormData:(NSDictionary*)dic
{
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
        [self.bookCoverButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"mainGrid_defaultBookCover"]];
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
            [self bookDownloaded:book progress:@"0"];
            [self.delegate reloadGrid];
        }else if(status == downloadStatusDownloading){
            [self bookDownloading:book];
        }else if (status == downloadStatusNone){
            [self bookUnDownload:book];
        }
    }
}

- (void)bookDownloaded:(BookEntity *)book progress:(NSString *)progress
{
    //已下载（阅读完成显示“作业”，未完成显示进度条）
    self.progressView.hidden = YES;
    
    if ([progress isEqualToString:@"100"]) {
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
        
        _progressControl.progress = [progress integerValue]/100.0f;
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
    [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"bookshelf-btn-downloading"] forState:UIControlStateNormal];

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
