//
//  HBLeaderBindingCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/8.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBLeaderBindingCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;

/**
 *	@brief	更新表格内容
 *  @return nil
 */
-(void)updateFormData:(NSMutableDictionary *)dic;

@end
