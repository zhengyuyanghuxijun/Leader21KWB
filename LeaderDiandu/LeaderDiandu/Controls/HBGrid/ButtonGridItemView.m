//
//  ButtonGridItemView.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/9/4.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "ButtonGridItemView.h"

@interface ButtonGridItemView()
{
    UIButton *_levelButton;
}

@property (strong, nonatomic) UIButton * levelButton;
@property (strong, nonatomic) UIImageView * subscribedImgView;

@end

@implementation ButtonGridItemView

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
    [self.levelButton setImage:[UIImage imageNamed:@"flower"] forState:UIControlStateDisabled];
//    [self.levelButton addTarget:self action:@selector(levelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.levelButton.enabled = NO;
    [self addSubview:self.levelButton];
    
    //已订阅图标
    self.subscribedImgView =[[UIImageView alloc] initWithFrame:CGRectMake((self.levelButton.frame.origin.x + levelButtonWith - 25), self.levelButton.frame.origin.y - 10, 35, 25)];
    [self.subscribedImgView setImage:[UIImage imageNamed:@"menu_vip"]];
    [self addSubview:self.subscribedImgView];
}

//-(void)levelButtonPressed:(id)sender
//{
//    
//}

//更新订阅图标和等级按钮
-(void)updateSubscribeImgView:(BOOL)isSubscribed
                  levelButton:(BOOL)isCurrentSelectIndex
{
    if (isSubscribed) {
        self.subscribedImgView.hidden = NO;
        [self.levelButton setImage:[UIImage imageNamed:@"flower"] forState:UIControlStateDisabled];
    }else if(isCurrentSelectIndex){
        self.subscribedImgView.hidden = YES;
        [self.levelButton setImage:[UIImage imageNamed:@"flower"] forState:UIControlStateDisabled];
    }else{
        self.subscribedImgView.hidden = YES;
        [self.levelButton setImage:[UIImage imageNamed:@"menu_user_pohoto"] forState:UIControlStateDisabled];
    }
}

@end
