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


#import "HBGridItemView.h"

@class MBProgressHUD;

@interface TextGridItemView : HBGridItemView

@property (nonatomic, strong) UIImageView* pauseView;
@property (nonatomic, strong) MBProgressHUD* progressView;

//更新数据
-(void)updateFormData:(NSDictionary*)dic;

@end
