//
//  HBSetStuGroupCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/16.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBStudentEntity.h"

@protocol QuitGroupDelegate <NSObject>

- (void)quitGroupBtnPressed:(HBStudentEntity *)aStudentEntity;

@end

@interface HBSetStuGroupCell : UITableViewCell

@property (strong, nonatomic) UIImageView * cellBgImage;
@property (strong, nonatomic) UIImageView * cellGroupImage;
@property (strong, nonatomic) UIImageView * cellHeadImage;
@property (strong, nonatomic) UILabel *     cellName;
@property (strong, nonatomic) UIButton *    cellQuitGroupBtn;

@property (strong, nonatomic) HBStudentEntity * studentEntity;

-(void)updateFormData:(HBStudentEntity *)aStudentEntity;

@property (weak, nonatomic) id <QuitGroupDelegate> delegate;

@end
