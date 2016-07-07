//
//  TextGridCell.h
//  HBGridView
//
//  Created by zhengyuyang on 16-6-14.
//  Copyright (c) 2012年 tt. All rights reserved.
//

#define TextGridItemView_downloadState          @"downloadState"
#define TextGridItemView_BookName               @"bookName"
#define TextGridItemView_BookCover              @"bookCover"
#define TextGridItemView_isVip                  @"isVip"

#import "MBProgressHUD.h"

@class BookEntity;
@class TextGridCell;

@protocol NewReloadGridDelegate <NSObject>

- (void)reloadGridView;

@end

@interface NewMyProgressView : UIView

-(void)setProgress:(float)fProgress;

@end

@protocol SelectTextGridCellDelegate <NSObject>

- (void)didSelectTextGridCell:(NSInteger)index forCell:(TextGridCell *)cell;

@end

@interface TextGridCell : UICollectionViewCell

@property (strong, nonatomic) UILabel * bookNameLabel;
@property (strong, nonatomic) UIButton * bookCoverButton;
@property (nonatomic, strong) MBProgressHUD *progressView;
@property (nonatomic, copy) NSString* bookDownloadUrl;

@property (nonatomic, assign) BOOL isTest;

@property (nonatomic, weak) id<NewReloadGridDelegate> delegate;

@property (nonatomic, weak) id<SelectTextGridCellDelegate> selectDelegate;

//更新数据
- (void)updateFormData:(NSDictionary*)dic forIndex:(NSInteger)index;

- (void)teacherBookDownloaded:(BookEntity *)book;
- (void)bookDownloaded:(BookEntity *)book progress:(NSString *)progress isTask:(BOOL)isTask;
- (void)bookDownloading:(BookEntity *)book;
- (void)bookUnDownload:(BookEntity *)book;

- (void)setDemoImage:(NSString *)imgFile;

@end
