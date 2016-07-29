//
//  HBTestSelectViewController.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/13.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBaseViewController.h"
#import "Leader21SDKOC.h"

@protocol HBTestSelectViewDelegate <NSObject>

- (void)selectedTest:(BookEntity *)bookEntity;

@end

@interface HBTestSelectViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView * cellImgView;
@property (strong, nonatomic) UILabel     * cellContentLabel;

/**
 *	@brief	更新表格内容
 *	@param 	NSDictionary 内容字典
 *  @retuan nil
 */
-(void)updateFormData:(id)sender;

@end

@interface HBTestSelectViewController : HBBaseViewController

@property (nonatomic, assign)NSInteger bookset_id;
@property(nonatomic,weak) id <HBTestSelectViewDelegate> delegate;

@end
