//
//  HBMyWorkView.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/20.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBMyWorkView.h"
#import "HBTestWorkManager.h"

#define KTagSelectionBegin  1527

typedef enum : NSUInteger {
    HBQuestionTypeText,
    HBQuestionTypeTAP,
    HBQuestionTypeTAA,
} HBQuestionType;

typedef enum : NSUInteger {
    HBSelectionTypePic,
    HBSelectionTypeText,
    HBSelectionTypeText4,
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
    
    float controlX = 20;
    float controlY = 0;
    float controlW = frame.size.width - controlX*2;
    float controlH = 300;
    [self initQuestionView:CGRectMake(controlX, controlY, controlW, controlH)];
    
    controlH = 40;
    controlY = frame.size.height-16-controlH;
    _finishButton = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    [_finishButton.layer setMasksToBounds:YES];
    [_finishButton.layer setCornerRadius:5.0];
    _finishButton.backgroundColor = [UIColor greenColor];
    _finishButton.titleLabel.font = font;
    [self addSubview:_finishButton];
    
    float selY = CGRectGetMaxY(_questionView.frame) + 28;
    controlH = controlY - selY - 28;
    [self initSelectionView:CGRectMake(controlX, controlY, controlW, controlH)];
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
    float controlY = 20;
    float controlW = frame.size.width - controlX*2;
    float controlH = 20;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor colorWithHex:0xff8903];
    _titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [_questionView addSubview:_titleLabel];
    
    controlY += controlH + 20;
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _descLabel.backgroundColor = [UIColor clearColor];
    _descLabel.textColor = [UIColor colorWithHex:0x817b72];
    _descLabel.font = [UIFont systemFontOfSize:22];
    [_questionView addSubview:_descLabel];

    controlY += controlH + 20;
    controlX += (controlW - 100) / 2;
    controlW = controlH = 100;
    _descButton = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    [_questionView addSubview:_descButton];
}

- (void)initSelectionView:(CGRect)frame
{
    _selectionView = [[UIView alloc] initWithFrame:frame];
    [self addSubview:_selectionView];
    
    float controlW = 110;
    float controlH = 80;
    float controlX = 0;
    float controlY = (frame.size.height-controlH) / 2;
    if (_selectionType == HBSelectionTypePic) {
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
        img1.tag = KTagSelectionBegin;
        [_selectionView addSubview:img1];
        controlX = frame.size.width - controlW;
        UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
        img2.tag = KTagSelectionBegin+1;
        [_selectionView addSubview:img2];
    } else if (_selectionType == HBSelectionTypeText) {
        controlW = 140;
        controlH = 60;
        [self createSelectionButton:CGRectMake(controlX, controlY, controlW, controlH) tag:KTagSelectionBegin];
        controlX = frame.size.width - controlW;
        [self createSelectionButton:CGRectMake(controlX, controlY, controlW, controlH) tag:KTagSelectionBegin+1];
        
    }
}

- (void)createSelectionButton:(CGRect)frame tag:(NSInteger)tag
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.tag = tag;
    [button setBackgroundImage:[UIImage imageNamed:@"test-btn-choose-normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"test-btn-choose-press"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"test-btn-choose-selected"] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithHex:0xff8903] forState:UIControlStateNormal];
    [_selectionView addSubview:button];
}

- (void)updateData:(NSDictionary *)dict
{
    NSString *typeStr = dict[@"Type"];
    [self updateTitle:typeStr];
    
    _descLabel.text = dict[@"Text"];
    CGRect rect = _descLabel.frame;
    if (_questionType == HBQuestionTypeText) {
        rect.size.height = _questionView.frame.size.height - rect.size.height;
        _descLabel.frame = rect;
    } else if (_questionType == HBQuestionTypeTAA) {
        [_descButton setBackgroundImage:[UIImage imageNamed:@"test-btn-sound-normal"] forState:UIControlStateNormal];
        [_descButton setBackgroundImage:[UIImage imageNamed:@"test-btn-sound-press"] forState:UIControlStateHighlighted];
    } else if (_questionType == HBQuestionTypeTAP) {
        CGSize size = [_descLabel.text sizeWithAttributes:@{NSFontAttributeName: _descLabel.font }];
        rect.size.height = size.height;
        _descLabel.frame = rect;
        
        
    }
    
    NSArray *optionsArr = [_workManager getOptionArray:dict];
}

- (void)updateTitle:(NSString *)type
{
    NSString *title = nil;
    if ([type isEqualToString:@"act"]) {
        title = @"听音选择正确的文字";
        _questionType = HBQuestionTypeTAA;
        _selectionType = HBSelectionTypeText;
    } else if ([type isEqualToString:@"acp"]) {
        title = @"听音选择正确的图片";
        _questionType = HBQuestionTypeTAA;
        _selectionType = HBSelectionTypePic;
    } else if ([type isEqualToString:@"pcp"]) {
        title = @"看图选择匹配的图片";
        _questionType = HBQuestionTypeTAP;
        _selectionType = HBSelectionTypePic;
    } else if ([type isEqualToString:@"pct"]) {
        title = @"看图选择匹配的内容";
        _questionType = HBQuestionTypeTAP;
        _selectionType = HBSelectionTypeText;
    } else if ([type isEqualToString:@"p2p"]) {
        title = @"连接匹配的图片";
        _questionType = HBQuestionTypeTAP;
        _selectionType = HBSelectionTypePic;
    } else if ([type isEqualToString:@"t2t"]) {
        title = @"连接匹配的文字";
        _questionType = HBQuestionTypeText;
        _selectionType = HBSelectionTypeText;
    } else if ([type isEqualToString:@"p2t"]) {
        title = @"连接匹配的图片的文字";
        _questionType = HBQuestionTypeTAP;
        _selectionType = HBSelectionTypeText;
    } else if ([type isEqualToString:@"t2p"]) {
        title = @"连接匹配的文字和图片";
        _questionType = HBQuestionTypeText;
        _selectionType = HBSelectionTypePic;
    } else if ([type isEqualToString:@"judge"]) {
        title = @"判断对错";
        _questionType = HBQuestionTypeTAP;
        _selectionType = HBSelectionTypePic;
    }
    _titleLabel.text = [NSString stringWithFormat:@"%ld.%@", _workManager.selIndex, title];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
