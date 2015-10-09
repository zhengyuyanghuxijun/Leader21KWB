//
//  HBPayViewControllerModeCell.h
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/30.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HBPayCellCheckedDelegate <NSObject>

- (void)payCellChecked:(NSString *)cellText;

@end

@interface HBPayViewControllerModeCell : UITableViewCell

@property (strong, nonatomic) UIImageView *iconImg;
@property (strong, nonatomic) UILabel *modeLabel;
@property (strong, nonatomic) UIButton *selectedBtn;
@property (nonatomic, strong) UITextField* VIPTextField;

@property (nonatomic, strong) NSString* checkedName;

@property (assign, nonatomic) BOOL checked;
@property (assign, nonatomic) BOOL showModeText;

@property (weak, nonatomic) id<HBPayCellCheckedDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier showModeText:(BOOL)showModeText;

-(void)updateFormData:(NSMutableDictionary *)dic checkedName:(NSString *)checkedName;

@end
