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

@interface TextGridItemView()
{
    UILabel *_bookNameLabel;
    UIButton *_downloadButton;
    UIButton *_bookCoverButton;
}

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
    //下载按钮
    self.downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downloadButton.frame = CGRectMake((self.frame.size.width - 60)/2, 10, 60, 25);
    [self.downloadButton addTarget:self action:@selector(downloadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.downloadButton];
    
    //书籍名称
    self.bookNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.downloadButton.frame.origin.y + self.downloadButton.frame.size.height + 5, self.frame.size.width - 30, 20)];
    self.bookNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.bookNameLabel];
    
    //书籍封皮
    self.bookCoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bookCoverButton.frame = CGRectMake(10, self.bookNameLabel.frame.origin.y + self.bookNameLabel.frame.size.height, self.frame.size.width - 20, 100);
    [self.bookCoverButton addTarget:self action:@selector(bookCoverButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bookCoverButton];
    
    self.progressView = [[MBProgressHUD alloc] initWithView:self];
    self.progressView.mode = MBProgressHUDModeDeterminate;
    self.progressView.backgroundBg = [self imageWithColor:[UIColor clearColor] size:CGSizeMake(1.0f, 1.0f)];
    self.progressView.userInteractionEnabled = NO;
    [self addSubview:self.progressView];
    
    UIImage* pause = [UIImage imageNamed:@"continue_download.png"];
    self.pauseView = [[UIImageView alloc] initWithImage:pause];
    self.pauseView.size = CGSizeMake(36.0f, 36.0f);
    self.pauseView.contentMode = UIViewContentModeCenter;
    self.pauseView.clipsToBounds = YES;
    self.pauseView.layer.cornerRadius = self.pauseView.width / 2.0f;
    self.pauseView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    [self addSubview:self.pauseView];
    self.progressView.hidden = YES;
    [self.progressView show:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat progressY = -10;
    self.progressView.frame = CGRectMake(0, progressY, self.bounds.size.width, self.bounds.size.height);
    self.pauseView.center = self.progressView.center;
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
        [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"user_button"] forState:UIControlStateNormal];
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
//    if ([notification.object isKindOfClass:[BookEntity class]])
    {
        BookEntity* book = (BookEntity*)notification.object;
        if ([book.bookUrl isEqualToString:self.bookDownloadUrl])
        {
            
            if (book.download == nil) {
                book.download = [[Leader21SDKOC sharedInstance] getCoreDataDownload:book.bookUrl];
            }
            [self resetWithBook:book];
        }
    }
    
    //    NSInteger per =  [[notification.userInfo objectForKey:@"progress"] integerValue];
    //
    //    if (per == 1) {
    //        [LEADERSDK readBook:(BookEntity*)notification.object useNavigation:self.navigationController];
    //
    //    }
}

- (void)resetWithBook:(BookEntity *)book
{
//    self.downloadButton.hidden = YES;
    self.progressView.hidden = YES;
    self.pauseView.hidden = YES;
    
    CGFloat progress = book.download.progress.floatValue;
    
    // 是否正在下载
    NSInteger s = book.download.status.integerValue;
    NSLog(@"download status:%ld, progress:%f", (long)s, progress);
    if (book.download != nil) {
        if (book.download.status.integerValue != downloadStatusFinished) {
            if (progress > 0.97f) {
                progress = 0.97f;
            }
        }
        
        if (progress == 1.0f) {
            [self.downloadButton setTitle:@"已下载" forState:UIControlStateNormal];
        }else{
            [self.downloadButton setTitle:@"下载中" forState:UIControlStateNormal];
        }
        
    }else{
        [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        self.pauseView.hidden = NO;
    }
    
    if (book.download != nil && (progress < 1.0f || book.download.status.integerValue == downloadStatusUnZipping)) {
        if (s == downloadStatusPause) {
            self.progressView.hidden = YES;
            self.pauseView.hidden = NO;
            [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
            NSLog(@"download status:pause");
        }
        else {
            if (progress < 0.005) {
                progress = 0.005;
            }
            if (downloadStatusUnZipping == book.download.status.integerValue) {
                progress = 0.97f;
            }
            else if (progress == 1.0f) {
                book.download.status = @(downloadStatusFinished);
            }
            self.progressView.hidden = NO;
            self.pauseView.hidden = YES;
            self.progressView.alpha = 1.0f;
            self.progressView.progress = progress;
            NSLog(@"download status:downing");
        }
        //        if (book.hasBook.boolValue) {
        //            itemView.readProgressLabel.text = [NSString stringWithFormat:@"Read %d%%", book.readProgress.integerValue];
        //            itemView.readProgressLabel.hidden = NO;
        //        }
        //        else {
        //            itemView.readProgressLabel.hidden = YES;
        //        }
    }
}

- (void)bookDownloaded
{
    self.progressView.hidden = YES;
    self.pauseView.hidden = YES;
    
    [self.downloadButton setTitle:@"已下载" forState:UIControlStateNormal];
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
