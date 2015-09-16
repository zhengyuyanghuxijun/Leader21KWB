//
//  HBSetStuOtherCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/16.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBSetStuOtherCell : UITableViewCell

@property (strong, nonatomic) UIImageView * cellBgImage;
@property (strong, nonatomic) UILabel *     cellName;
@property (strong, nonatomic) UIButton *    cellselectedBtn;

@property (assign, nonatomic) BOOL checked;

-(void)updateFormData:(NSString *)stuName;

@end
