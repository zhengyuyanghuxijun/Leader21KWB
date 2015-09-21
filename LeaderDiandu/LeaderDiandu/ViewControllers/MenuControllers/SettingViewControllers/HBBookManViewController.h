//
//  HBBookManViewController.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/18.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBaseViewController.h"
#import "Leader21SDKOC.h"
#import "LeaderSDKUtil.h"

@interface HBBookInfoCell : UITableViewCell

@property (strong, nonatomic) UIButton *    cellSelectedBtn;
@property (strong, nonatomic) UIImageView * cellBookCoverImg;
@property (strong, nonatomic) UILabel *     cellBookName;
@property (strong, nonatomic) UILabel *     cellBookSize;
@property (assign, nonatomic) BOOL          checked;

@property (strong, nonatomic) BookEntity * bookEntity;

-(void)updateFormData:(BookEntity *)aBookEntity;
-(void)updateBookSize:(NSInteger)aBookSize;

-(void)selectedBtnPressed;

-(void)setSelectedBtnStatus:(BOOL)selected;

@end

@interface HBBookManViewController : HBBaseViewController

@end
