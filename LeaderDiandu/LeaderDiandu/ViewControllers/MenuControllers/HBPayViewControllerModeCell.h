//
//  HBPayViewControllerModeCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/30.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBPayViewControllerModeCell : UITableViewCell

@property (strong, nonatomic) UIImageView *iconImg;
@property (strong, nonatomic) UILabel *modeLabel;
@property (strong, nonatomic) UIButton *selectedBtn;
@property (nonatomic, strong) UITextField* VIPTextField;

@property (assign, nonatomic) BOOL checked;
@property (assign, nonatomic) BOOL showModeText;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier showModeText:(BOOL)showModeText;

-(void)updateFormData:(NSMutableDictionary *)dic;

@end
