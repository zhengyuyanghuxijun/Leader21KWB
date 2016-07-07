//
//  HBScoreListViewController.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/7.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBaseViewController.h"

@interface HBScoreListViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView * cellHeadImage;
@property (strong, nonatomic) UILabel *     cellName;
@property (strong, nonatomic) UILabel *     cellTime;
@property (strong, nonatomic) UILabel *     cellScore;

/**
 *	@brief	更新表格内容
 *  @return nil
 */
-(void)updateFormData:(id)sender;

@end

@interface HBScoreListViewController : HBBaseViewController

@property (nonatomic, copy)NSString *titleStr;
@property (nonatomic, assign)NSInteger examId;

@end
