//
//  HBScoreView.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/28.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBScoreView.h"

@implementation HBScoreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI:frame];
    }
    return self;
}

- (void)initUI:(CGRect)frame
{
    float controlX = 50;
    float controlY = 50;
    float controlW = frame.size.width - controlX*2;
    float controlH = controlW * 2;
    UIImageView *scoreImg = [[UIImageView alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    scoreImg.image = [self getScoreImage];
    [self addSubview:scoreImg];
    
    controlY = CGRectGetMaxY(scoreImg.frame) + 20;
    controlH = 20;
    UILabel *scoreLbl = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    scoreLbl.backgroundColor = [UIColor clearColor];
    scoreLbl.textColor = [UIColor redColor];
    scoreLbl.textAlignment = NSTextAlignmentCenter;
    scoreLbl.font = [UIFont systemFontOfSize:22];
    scoreLbl.text = [self getScoreTip];
    [self addSubview:scoreLbl];
    
    controlX = 20;
    controlW = frame.size.width - controlX*2;
    controlH = 45;
    controlY = frame.size.height - controlH - 20;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    [button setBackgroundImage:[UIImage imageNamed:@"yellow-normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"yellow-press"] forState:UIControlStateHighlighted];
    [button setTitle:@"我知道了" forState:UIControlStateNormal];
    [self addSubview:button];
}

- (UIImage *)getScoreImage
{
    NSString *imgName = nil;
    if (_score == 100) {
        imgName = @"score_A+";
    } else if (_score >= 80) {
        imgName = @"score_A";
    } else if (_score >= 60) {
        imgName = @"score_B";
    } else {
        imgName = @"score_C";
    }
    UIImage *image = [UIImage imageNamed:imgName];
    return image;
}

- (NSString *)getScoreTip
{
    NSString *tip = nil;
    if (_score == 100) {
        tip = @"完美";
    } else if (_score >= 80) {
        tip = @"优秀";
    } else if (_score >= 60) {
        tip = @"良好";
    } else {
        tip = @"继续努力";
    }
    
    return tip;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
