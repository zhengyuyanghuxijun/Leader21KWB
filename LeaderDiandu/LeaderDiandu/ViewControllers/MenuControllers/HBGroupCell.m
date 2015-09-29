//
//  HBGroupCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/14.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBGroupCell.h"

#define LABELFONTSIZE 14.0f
#define BUTTONFONTSIZE 15.0f

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
    //群组图标
    self.cellGroupImage = [[UIImageView alloc] init];
    self.cellGroupImage.image = [UIImage imageNamed:@"icn-group"];
    self.cellGroupImage.frame = CGRectMake(10, 10 + 6, 17, 14);
    [self addSubview:self.cellGroupImage];
    
    //班级
    self.cellGroupName = [[UILabel alloc] init];
    self.cellGroupName.frame = CGRectMake(10 + 17 + 10, 10, 200, 70/2 - 10);
    self.cellGroupName.font = [UIFont boldSystemFontOfSize:BUTTONFONTSIZE];
    self.cellGroupName.textColor = [UIColor colorWithHex:0xff8903];
    [self addSubview:self.cellGroupName];
    
    //等级
    self.cellLevel = [[UILabel alloc] init];
    self.cellLevel.frame = CGRectMake(10 + 100 + 10, 70/2, 30, 70/2 - 10);
    self.cellLevel.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self addSubview:self.cellLevel];
    
    self.cellLevelNum = [[UILabel alloc] init];
    self.cellLevelNum.frame = CGRectMake(self.cellLevel.frame.origin.x + self.cellLevel.frame.size.width + 5, 70/2, 10, 70/2 - 10);
    self.cellLevelNum.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    self.cellLevelNum.textColor = [UIColor colorWithHex:0xff8903];
    [self addSubview:self.cellLevelNum];
    
    //人数
    self.cellCount = [[UILabel alloc] init];
    self.cellCount.frame = CGRectMake(10 + 100 + 10 + 50 + 10, 70/2, 30, 70/2 - 10);
    self.cellCount.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self addSubview:self.cellCount];
    
    self.cellCountNum = [[UILabel alloc] init];
    self.cellCountNum.frame = CGRectMake(self.cellCount.frame.origin.x + self.cellCount.frame.size.width + 5, 70/2, 10, 70/2 - 10);
    self.cellCountNum.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    self.cellCountNum.textColor = [UIColor colorWithHex:0xff8903];
    [self addSubview:self.cellCountNum];
    
    //时间
    self.cellTime = [[UILabel alloc] init];
    self.cellTime.frame = CGRectMake(10, 70/2, 100, 70/2 - 10);
    self.cellTime.font = [UIFont boldSystemFontOfSize:LABELFONTSIZE];
    [self addSubview:self.cellTime];
    
    //编辑按钮
    self.cellEditBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 100, (70 - 30)/2, 40, 25)];
    [self.cellEditBtn setBackgroundImage:[UIImage imageNamed:@"test-btn-choose-normal"] forState:UIControlStateNormal];
    [self.cellEditBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.cellEditBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cellEditBtn addTarget:self action:@selector(editBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    self.cellEditBtn.titleLabel.font = [UIFont boldSystemFontOfSize:BUTTONFONTSIZE];
    [self addSubview:self.cellEditBtn];
    
    //解散按钮
    self.cellDissolveBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, (70 - 30)/2, 40, 25)];
    [self.cellDissolveBtn setBackgroundImage:[UIImage imageNamed:@"test-btn-choose-normal"] forState:UIControlStateNormal];
    [self.cellDissolveBtn setTitle:@"解散" forState:UIControlStateNormal];
    [self.cellDissolveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cellDissolveBtn addTarget:self action:@selector(dissolveBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    self.cellDissolveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:BUTTONFONTSIZE];
    [self addSubview:self.cellDissolveBtn];
}

-(void)updateFormData:(id)sender
{
    self.classEntity = (HBClassEntity *)sender;
    
    if (self.classEntity) {
        self.cellGroupName.text = self.classEntity.name;
        self.cellLevel.text = @"等级";
        self.cellLevelNum.text = [NSString stringWithFormat:@"%ld", self.classEntity.booksetId];
        self.cellCount.text = [NSString stringWithFormat:@"%@"@"%d", @"人数", 0];
        self.cellTime.text = self.classEntity.createdTime;
        self.classId = self.classEntity.classId;
        self.cellCount.text = @"人数";
        self.cellCountNum.text = [NSString stringWithFormat:@"%ld", self.classEntity.stuCount];
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
