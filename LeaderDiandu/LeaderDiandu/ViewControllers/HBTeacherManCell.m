//
//  HBTeacherManCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/25.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBTeacherManCell.h"
#import "HBTeacherEntity.h"

@implementation HBTeacherManCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    
}

-(void)updateFormData:(id)sender
{
    HBTeacherEntity *teacherEntity = (HBTeacherEntity *)sender;
    
    if (teacherEntity) {
        
    }
}

@end
