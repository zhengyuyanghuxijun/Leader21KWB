//
//  HBGroupCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/14.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBClassEntity.h"

@protocol DissolveDelegate <NSObject>

- (void)dissolveBtnPressed:(NSInteger)classId;
- (void)editBtnPressed:(HBClassEntity *)classEntity;

@end

@interface HBGroupCell : UITableViewCell

@property (strong, nonatomic) UIImageView * cellGroupImage;
@property (strong, nonatomic) UILabel *     cellGroupName;
@property (strong, nonatomic) UILabel *     cellLevel;
@property (strong, nonatomic) UILabel *     cellLevelNum;
@property (strong, nonatomic) UILabel *     cellCount;
@property (strong, nonatomic) UILabel *     cellCountNum;
@property (strong, nonatomic) UILabel *     cellTime;
@property (strong, nonatomic) UIButton *    cellEditBtn;
@property (strong, nonatomic) UIButton *    cellDissolveBtn;

@property (nonatomic, assign)NSInteger classId;
@property (nonatomic, strong)HBClassEntity *classEntity;

@property (weak, nonatomic) id <DissolveDelegate> delegate;

-(void)updateFormData:(id)sender;

-(void)updateCellCount:(NSInteger)count;

@end
