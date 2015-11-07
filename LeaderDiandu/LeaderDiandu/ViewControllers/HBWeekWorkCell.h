//
//  HBWeekWorkCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/11/7.
//  Copyright © 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBWeekWorkCell : UITableViewCell

@property (strong, nonatomic) UIImageView *headImgView;
@property (strong, nonatomic) UILabel *display_nameLabel;
@property (strong, nonatomic) UILabel *totalTitleLabel;
@property (strong, nonatomic) UILabel *totalLabel;
@property (strong, nonatomic) UILabel *submitted_countTitleLabel;
@property (strong, nonatomic) UILabel *submitted_countLabel;
@property (strong, nonatomic) UILabel *nonExamLabel;

/**
 *	@brief	更新表格内容
 *  @return nil
 */
-(void)updateFormData:(id)sender;

@end
