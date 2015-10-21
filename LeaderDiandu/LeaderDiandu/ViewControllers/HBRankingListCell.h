//
//  HBRankingListCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/21.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBRankingListCell : UITableViewCell

@property (strong, nonatomic) UIImageView *cupImgView;
@property (strong, nonatomic) UILabel *     rankingLabel;
@property (strong, nonatomic) UIImageView * bookCoverImage;
@property (strong, nonatomic) UILabel *     bookNameLabel;
@property (strong, nonatomic) UILabel *     countLabel;

/**
 *	@brief	更新表格内容
 *	@param 	NSDictionary 内容字典
 *  @retuan nil
 */
-(void)updateFormData:(id)sender;

@end
