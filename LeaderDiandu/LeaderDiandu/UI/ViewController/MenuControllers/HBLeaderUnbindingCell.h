//
//  HBLeaderUnbindingCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/8.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBLeaderUnbindingCell : UITableViewCell

@property (strong, nonatomic) UIImageView *headImgView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *displayNameLabel;
@property (strong, nonatomic) UIButton *selectButton;

/**
 *	@brief	更新表格内容
 *  @return nil
 */
-(void)updateFormData:(NSDictionary *)dic;

-(void)selectedBtnPressed:(NSString *)pressed;

@end
