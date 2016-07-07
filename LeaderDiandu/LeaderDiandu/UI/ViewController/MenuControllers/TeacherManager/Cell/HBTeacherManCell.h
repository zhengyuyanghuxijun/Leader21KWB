//
//  HBTeacherManCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/25.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HBTeacherManCellDelegate <NSObject>

- (void)unbundlingBtnPressed:(NSString *)teacher;

@end

@interface HBTeacherManCell : UITableViewCell

@property (strong, nonatomic) UIImageView *headImgView;
@property (strong, nonatomic) UILabel *display_nameLabel;
@property (strong, nonatomic) UILabel *associate_timeLabel;
@property (strong, nonatomic) UILabel *totalLabel;
@property (strong, nonatomic) UILabel *vipLabel;
@property (strong, nonatomic) UIButton *cellUnbundlingBtn;

@property (copy, nonatomic) NSString *teacherName;
@property (assign, nonatomic)id<HBTeacherManCellDelegate> delegate;

/**
 *	@brief	更新表格内容
 *  @return nil
 */
-(void)updateFormData:(id)sender;

@end
