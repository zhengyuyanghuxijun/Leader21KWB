//
//  HBBillViewControllerCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/12.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBBillViewControllerCell : UITableViewCell

@property (strong, nonatomic) UIImageView *iconImg;
@property (strong, nonatomic) UILabel *subjectLabel;
@property (strong, nonatomic) UILabel *bodyLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *statusLabel;

/**
 *	@brief	更新表格内容
 *  @return nil
 */
-(void)updateFormData:(id)sender;

@end
