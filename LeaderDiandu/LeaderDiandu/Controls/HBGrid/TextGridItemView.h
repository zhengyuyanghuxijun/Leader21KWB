//
//  TextGridItemView.h
//  HBGridView
//
//  Created by wxj on 12-10-12.
//  Copyright (c) 2012年 tt. All rights reserved.
//

#define TextGridItemView_downloadState          @"downloadState"
#define TextGridItemView_BookName               @"bookName"
#define TextGridItemView_BookCover              @"bookCover"
#define TextGridItemView_isVip                  @"isVip"

#import "HBGridItemView.h"
#import "MBProgressHUD.h"

@class BookEntity;

@protocol reloadGridDelegate <NSObject>

- (void)reloadGridView;

@end

@interface MyProgressView : UIView

-(void)setProgress:(float)fProgress;

@end

@interface TextGridItemView : HBGridItemView

@property (strong, nonatomic) UIButton * bookCoverButton;
@property (nonatomic, strong) MBProgressHUD *progressView;
@property (nonatomic, copy) NSString* bookDownloadUrl;

@property (nonatomic, assign) BOOL isTest;

@property (nonatomic, weak) id<reloadGridDelegate> delegate;

//更新数据
- (void)updateFormData:(NSDictionary*)dic;

- (void)teacherBookDownloaded:(BookEntity *)book;
- (void)bookDownloaded:(BookEntity *)book progress:(NSString *)progress isTask:(BOOL)isTask;
- (void)bookDownloading:(BookEntity *)book;
- (void)bookUnDownload:(BookEntity *)book;

@end
