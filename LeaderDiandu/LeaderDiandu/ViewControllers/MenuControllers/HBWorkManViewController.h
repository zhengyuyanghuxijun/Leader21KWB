//
//  HBWorkManViewController.h
//  LeaderDiandu
//
//  Created by xijun on 15/9/2.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBBaseViewController.h"

@interface HBWorkManViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *     cellTime;
@property (strong, nonatomic) UIImageView * cellGroupImage;
@property (strong, nonatomic) UILabel *     cellClassName;
@property (strong, nonatomic) UILabel *     cellSubmitted;
@property (strong, nonatomic) UILabel *     cellTotal;
@property (strong, nonatomic) UIImageView * cellImageBookCover;
@property (strong, nonatomic) UILabel *     cellBookName;

/**
 *	@brief	更新表格内容
 *	@param 	NSDictionary 内容字典
 *  @retuan nil
 */
-(void)updateFormData:(id)sender;

@end

@interface HBWorkManViewController : HBBaseViewController

@end
