//
//  HBSetStuOtherCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/16.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBStudentEntity.h"


@protocol JoinGroupDelegate <NSObject>

- (void)joinGroupBtnPressed:(HBStudentEntity *)aStudentEntity
                    checked:(BOOL)aChecked;

@end

@interface HBSetStuOtherCell : UITableViewCell

@property (strong, nonatomic) UIImageView * cellBgImage;
@property (strong, nonatomic) UIImageView * cellGroupImage;
@property (strong, nonatomic) UIImageView * cellHeadImage;
@property (strong, nonatomic) UILabel *     cellName;
@property (strong, nonatomic) UIButton *    cellselectedBtn;
@property (strong, nonatomic) UIImageView * cellselectedImgView;

@property (assign, nonatomic) BOOL checked;

@property (strong, nonatomic) HBStudentEntity * studentEntity;

-(void)updateFormData:(HBStudentEntity *)aStudentEntity;

@property (weak, nonatomic) id <JoinGroupDelegate> delegate;

@end
