//
//  SubscribeGridCell.m
//  HBGridView
//
//  Created by zhengyuyang on 16-6-14.
//  Copyright (c) 2012年 tt. All rights reserved.
//

#import "SubscribeGridCell.h"

#define BUTTONFONTSIZE 30.0f

@interface SubscribeGridCell()
{
    UIButton *_levelButton;
}

@property (strong, nonatomic) UIButton * levelButton;

@end

@implementation SubscribeGridCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void) initUI
{
    //等级按钮
    NSInteger levelButtonWith = self.frame.size.width/2;
    self.levelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.levelButton.frame = CGRectMake((self.frame.size.width - levelButtonWith)/2, (self.frame.size.width - levelButtonWith)/2, levelButtonWith, levelButtonWith);
    //设置button为圆形
    //    [self.levelButton.layer setMasksToBounds:YES];
    //    [self.levelButton.layer setCornerRadius:levelButtonWith/2];
    [self.levelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:BUTTONFONTSIZE]];
    self.levelButton.enabled = NO;
    [self addSubview:self.levelButton];
}

//更新订阅图标和等级按钮
-(void)updateSubscribeImgView:(BOOL)isSubscribed
                  levelButton:(BOOL)isCurrentSelectIndex
                        index:(NSString *)index
{
    if (isSubscribed) {
        [self.levelButton setBackgroundImage:[UIImage imageNamed:@"subs-btn-slected"] forState:UIControlStateDisabled];
    }else if(isCurrentSelectIndex){
        [self.levelButton setBackgroundImage:[UIImage imageNamed:@"subs-btn-pressed"] forState:UIControlStateDisabled];
    }else{
        [self.levelButton setBackgroundImage:[UIImage imageNamed:@"subs-btn-normal"] forState:UIControlStateDisabled];
    }
    
    [self.levelButton setTitle:index forState:UIControlStateDisabled];
}

@end
