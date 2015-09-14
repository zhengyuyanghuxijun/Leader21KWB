//
//  HBStudentCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/13.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UnbundlingDelegate <NSObject>

- (void)unbundlingBtnPressed:(NSInteger)studentId;

@end

@interface HBStudentCell : UITableViewCell

@property (strong, nonatomic) UIImageView * cellHeadImage;
@property (strong, nonatomic) UILabel *     cellName;
@property (strong, nonatomic) UILabel *     cellStuType;
@property (strong, nonatomic) UILabel *     cellGroup;
@property (strong, nonatomic) UIButton *    cellUnbundlingBtn;

@property (assign, nonatomic) NSInteger studentID;

@property (weak, nonatomic) id <UnbundlingDelegate> delegate;

/**
 *	@brief	更新表格内容
 *  @return nil
 */
-(void)updateFormData:(id)sender;

@end
