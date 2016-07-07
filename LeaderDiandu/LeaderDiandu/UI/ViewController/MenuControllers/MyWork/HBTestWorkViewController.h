//
//  HBTestWorkViewController.h
//  LeaderDiandu
//
//  Created by xijun on 15/9/1.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBBaseViewController.h"

@interface HBTestWorkViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *     cellTime;
@property (strong, nonatomic) UILabel *     cellTeacherName;
@property (strong, nonatomic) UILabel *     cellScore;
@property (strong, nonatomic) UIImageView * cellImageBookCover;
@property (strong, nonatomic) UILabel *     cellBookName;
@property (strong, nonatomic) UILabel *     cellSubmitState;
@property (strong, nonatomic) UILabel *     cellModifiedTime;

/**
 *	@brief	更新表格内容
 *	@param 	NSDictionary 内容字典
 *  @retuan nil
 */
-(void)updateFormData:(id)sender;

@end

@interface HBTestWorkViewController : HBBaseViewController

@end
