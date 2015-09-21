//
//  HBMyWorkView.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/20.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBMyWorkView.h"

typedef enum : NSUInteger {
    HBQuestionTypeText,
    HBQuestionTypeTAP,
    HBQuestionTypeTAA,
} HBQuestionType;

typedef enum : NSUInteger {
    HBSelectionTypeText,
    HBSelectionTypePic,
} HBSelectionType;

@interface HBMyWorkView ()
{
    UILabel *_titleLabel;
    UILabel *_descLabel;
    UIButton *_finishButton;
    UIButton *_descButton;
    UIImageView *_descImg;
    
    UIImageView *_leftImg;
    UIImageView *_rightImg;
    
    UIButton *_leftButton;
    UIButton *_rightButton;
    
    UIView *_questionView;
    UIView *_selectionView;
    
    HBQuestionType _questionType;
    HBSelectionType _selectionType;
}

@end

@implementation HBMyWorkView

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
    UIFont *font = [UIFont systemFontOfSize:22];
    
    float controlX = 12;
    float controlY = 0;
    float controlW = frame.size.width - controlX*2;
    float controlH = 300;
    [self initQuestionView:CGRectMake(controlX, controlY, controlW, controlH)];
    
    controlH = 23;
    controlY = frame.size.height-16-controlH;
    _finishButton = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    [_finishButton.layer setMasksToBounds:YES];
    [_finishButton.layer setCornerRadius:5.0];
    _finishButton.backgroundColor = [UIColor greenColor];
    _finishButton.titleLabel.font = font;
    [self addSubview:_finishButton];
    
    float selY = CGRectGetMaxY(_questionView.frame) + 28;
    controlH = controlY - selY - 28;
    _selectionView = [[UIView alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    [self addSubview:_selectionView];
}

- (void)initQuestionView:(CGRect)frame
{
    _questionView = [[UIView alloc] initWithFrame:frame];
    _questionView.backgroundColor = [UIColor clearColor];
    [_questionView.layer setMasksToBounds:YES];
    [_questionView.layer setCornerRadius:10.0];
    [_questionView.layer setBorderWidth:2.0];
    [_questionView.layer setBorderColor:[UIColor colorWithHex:0xff8903].CGColor];
    [self addSubview:_questionView];
    
    float controlX = 10;
    float controlY = 10;
    float controlW = frame.size.width - controlX*2;
    float controlH = 20;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor colorWithHex:0xff8903];
    _titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [_questionView addSubview:_titleLabel];
    
    controlY += controlH + 8;
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _descLabel.backgroundColor = [UIColor clearColor];
    _descLabel.textColor = [UIColor colorWithHex:0x817b72];
    _descLabel.font = [UIFont systemFontOfSize:22];
    [_questionView addSubview:_descLabel];

    controlY += controlH + 8;
    controlX += (controlW - 80) / 2;
    controlW = controlH = 80;
    _descButton = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    [_questionView addSubview:_descButton];
}

- (void)updateData:(NSDictionary *)dict
{
    NSString *typeStr = dict[@"type"];
    [self updateTitle:typeStr];
    
    _descLabel.text = dict[@"text"];
    CGRect rect = _descLabel.frame;
    if (_questionType == HBQuestionTypeText) {
        rect.size.height = _questionView.frame.size.height - rect.size.height;
        _descLabel.frame = rect;
    } else if (_questionType == HBQuestionTypeTAA) {
        [_descButton setBackgroundImage:[UIImage imageNamed:@"test-btn-sound-normal"] forState:UIControlStateNormal];
        [_descButton setBackgroundImage:[UIImage imageNamed:@"test-btn-sound-press"] forState:UIControlStateNormal];
    } else if (_questionType == HBQuestionTypeTAP) {
        CGSize size = [_descLabel.text sizeWithAttributes:@{NSFontAttributeName: _descLabel.font }];
        rect.size.height = size.height;
        _descLabel.frame = rect;
    }
}

- (void)updateTitle:(NSString *)type
{
    if ([type isEqualToString:@"act"]) {
        _titleLabel.text = @"听音选择正确的文字";
        _questionType = HBQuestionTypeTAA;
        _selectionType = HBSelectionTypeText;
    } else if ([type isEqualToString:@"acp"]) {
        _titleLabel.text = @"听音选择正确的图片";
        _questionType = HBQuestionTypeTAA;
        _selectionType = HBSelectionTypePic;
    } else if ([type isEqualToString:@"pcp"]) {
        _titleLabel.text = @"看图选择匹配的图片";
        _questionType = HBQuestionTypeTAP;
        _selectionType = HBSelectionTypePic;
    } else if ([type isEqualToString:@"pct"]) {
        _titleLabel.text = @"看图选择匹配的内容";
        _questionType = HBQuestionTypeTAP;
        _selectionType = HBSelectionTypeText;
    } else if ([type isEqualToString:@"p2p"]) {
        _titleLabel.text = @"连接匹配的图片";
        _questionType = HBQuestionTypeTAP;
        _selectionType = HBSelectionTypePic;
    } else if ([type isEqualToString:@"t2t"]) {
        _titleLabel.text = @"连接匹配的文字";
        _questionType = HBQuestionTypeText;
        _selectionType = HBSelectionTypeText;
    } else if ([type isEqualToString:@"p2t"]) {
        _titleLabel.text = @"连接匹配的图片的文字";
        _questionType = HBQuestionTypeTAP;
        _selectionType = HBSelectionTypeText;
    } else if ([type isEqualToString:@"t2p"]) {
        _titleLabel.text = @"连接匹配的文字和图片";
        _questionType = HBQuestionTypeText;
        _selectionType = HBSelectionTypePic;
    } else if ([type isEqualToString:@"judge"]) {
        _titleLabel.text = @"判断对错";
        _questionType = HBQuestionTypeTAP;
        _selectionType = HBSelectionTypePic;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
