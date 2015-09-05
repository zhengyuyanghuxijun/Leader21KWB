//
//  TextGridItemView.m
//  HBGridView
//
//  Created by wxj on 12-10-12.
//  Copyright (c) 2012年 tt. All rights reserved.
//

#import "TextGridItemView.h"
#import "UIButton+AFNetworking.h"

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
    }
    return self;
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
        [self.downloadButton setBackgroundImage:[UIImage imageNamed:[dic objectForKey:TextGridItemView_downloadState]] forState:UIControlStateNormal];
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

@end
