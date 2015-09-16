//
//  HBGroupCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/14.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBGroupCell.h"

@implementation HBGroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (void) initUI
{
    //班级
    self.cellGroupName = [[UILabel alloc] init];
    self.cellGroupName.frame = CGRectMake(10, 10, 75, 70/2 - 10);
    [self addSubview:self.cellGroupName];
    
    //等级
    self.cellLevel = [[UILabel alloc] init];
    self.cellLevel.frame = CGRectMake(10 + 75 + 10, 10, 55, 70/2 - 10);
    [self addSubview:self.cellLevel];
    
    //人数
    self.cellCount = [[UILabel alloc] init];
    self.cellCount.frame = CGRectMake(10 + 75 + 10 + 55 + 10, 10, 70, 70/2 - 10);
    [self addSubview:self.cellCount];
    
    //时间
    self.cellTime = [[UILabel alloc] init];
    self.cellTime.frame = CGRectMake(10 + 75 + 10, 70/2, 150, 70/2 - 10);
    [self addSubview:self.cellTime];
    
    //编辑按钮
    self.cellEditBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 100, (70 - 30)/2, 30, 30)];
    [self.cellEditBtn setBackgroundImage:[UIImage imageNamed:@"flower"] forState:UIControlStateNormal];
//    [self.cellEditBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.cellEditBtn addTarget:self action:@selector(editBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cellEditBtn];
    
    //解散按钮
    self.cellDissolveBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, (70 - 30)/2, 45, 30)];
    [self.cellDissolveBtn setBackgroundImage:[UIImage imageNamed:@"user_button"] forState:UIControlStateNormal];
    [self.cellDissolveBtn setTitle:@"解散" forState:UIControlStateNormal];
    [self.cellDissolveBtn addTarget:self action:@selector(dissolveBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cellDissolveBtn];
}

-(void)updateFormData:(id)sender
{
    self.classEntity = (HBClassEntity *)sender;
    
    if (self.classEntity) {
        self.cellGroupName.text = self.classEntity.name;
        self.cellLevel.text = [NSString stringWithFormat:@"%@"@"%ld", @"等级", self.classEntity.booksetId];
        self.cellCount.text = [NSString stringWithFormat:@"%@"@"%d", @"人数", 0];
        self.cellTime.text = self.classEntity.createdTime;
        self.classId = self.classEntity.classId;
    }
}

-(void)updateCellCount:(NSInteger)count
{
    self.cellCount.text = [NSString stringWithFormat:@"%@"@"%ld", @"人数", count];
}

- (void)dissolveBtnPressed
{
    [self.delegate dissolveBtnPressed:self.classId];
}

- (void)editBtnPressed
{
    [self.delegate editBtnPressed:self.classEntity];
}

@end
