//
//  HBMessageViewCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/7.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBMessageViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *msgIconImg;
@property (strong, nonatomic) UILabel *bodyLabel;
@property (strong, nonatomic) UILabel *timeLabel;

/**
 *	@brief	更新表格内容
 *  @return nil
 */
-(void)updateFormData:(id)sender;

@end
