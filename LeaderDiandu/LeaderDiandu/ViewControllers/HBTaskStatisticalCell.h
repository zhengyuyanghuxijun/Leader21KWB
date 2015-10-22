//
//  HBTaskStatisticalCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/23.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBTaskStatisticalCell : UITableViewCell

/**
 *	@brief	更新表格内容
 *	@param 	NSDictionary 内容字典
 *  @retuan nil
 */
-(void)updateFormData:(NSMutableArray *)arr isKnowledge:(BOOL)knowledge;

@end
