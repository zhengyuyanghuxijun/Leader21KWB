//
//  HBMyWorkView.m
//  LeaderDiandu
//
//  Created by xijun on 15/9/20.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBMyWorkView.h"
#import "HBTestWorkManager.h"
#import "HBOptionView.h"
#import "MBHudUtil.h"

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

@interface HBMyWorkView () <HBOptionViewDelegate>
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
    
    HBQuestionType _questionType;
    HBSelectionType _selectionType;
    
    BOOL isOptionSelected;  //是否选中一个选项
    NSInteger selAnswerIndex;//选中的是哪一项
}

@property (nonatomic, strong)UIView *selectionView;

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
    float controlH = 270;
    [self initQuestionView:CGRectMake(controlX, controlY, controlW, controlH)];
    
    controlH = 40;
    controlY = frame.size.height-40-controlH;
    _finishButton = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
//    [_finishButton.layer setMasksToBounds:YES];
//    [_finishButton.layer setCornerRadius:5.0];
//    _finishButton.backgroundColor = [UIColor greenColor];
    [_finishButton setBackgroundImage:[UIImage imageNamed:@"test-btn-normal"] forState:UIControlStateNormal];
    [_finishButton setBackgroundImage:[UIImage imageNamed:@"test-btn-press"] forState:UIControlStateHighlighted];
    _finishButton.titleLabel.font = font;
    [_finishButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_finishButton];
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
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_questionView addSubview:_titleLabel];
    
    controlY += controlH + 20;
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    _descLabel.backgroundColor = [UIColor clearColor];
    _descLabel.textColor = [UIColor colorWithHex:0x817b72];
    _descLabel.font = [UIFont systemFontOfSize:22];
    _descLabel.textAlignment = NSTextAlignmentCenter;
    [_questionView addSubview:_descLabel];

    controlY += controlH + 20;
    controlX += (controlW - 100) / 2;
    controlW = controlH = 100;
    _descButton = [[UIButton alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH)];
    [_questionView addSubview:_descButton];
}

- (void)initSelectionView:(NSArray *)optionArray
{
    if (_selectionView) {
        NSArray *subViews = [_selectionView subviews];
        for (UIView *view in subViews) {
            [view removeFromSuperview];
        }
    } else {
        CGRect rect = _questionView.frame;
        float selY = CGRectGetMaxY(rect) + 28;
        float controlH = CGRectGetMinY(_finishButton.frame) - selY - 28;
        _selectionView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rect), selY, CGRectGetWidth(rect), controlH)];
        [self addSubview:_selectionView];
    }
    
    float controlW = 110;
    float controlH = 80;
    float controlX = 0;
    CGRect frame = _selectionView.frame;
    float controlY = (frame.size.height-controlH) / 2;
    NSInteger count = [optionArray count];
    for (NSInteger i=0; i<count; i++) {
        id obj = optionArray[i];
        if (i%2 == 1) {
            controlX = frame.size.width - controlW;;
        }
        if ([obj isKindOfClass:[UIImage class]]) {
            HBOptionView *view = [[HBOptionView alloc] initWithFrame:CGRectMake(controlX, controlY, controlW, controlH) image:obj];
            view.tag = KTagSelectionBegin+i;
            view.delegate = self;
            [_selectionView addSubview:view];
        } else {
            controlW = 140;
            controlH = 60;
            [self createSelectionButton:CGRectMake(controlX, controlY, controlW, controlH) tag:KTagSelectionBegin+i title:obj];
        }
    }
}

- (void)createSelectionButton:(CGRect)frame tag:(NSInteger)tag title:(NSString *)title
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setBackgroundImage:[UIImage imageNamed:@"test-btn-choose-normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"test-btn-choose-press"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"test-btn-choose-selected"] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithHex:0xff8903] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_selectionView addSubview:button];
}

- (void)updateData:(NSDictionary *)dict byScore:(NSString *)score
{
    isOptionSelected = NO;
    
    NSString *typeStr = dict[@"Type"];
    [self updateTitle:typeStr];
    
    _descLabel.text = dict[@"Text"];
    CGRect rect = _descLabel.frame;
    if (_questionType == HBQuestionTypeText) {
        rect = _questionView.bounds;
        rect.origin.x = 10;
        _descLabel.frame = rect;
        _descButton.hidden = YES;
    } else if (_questionType == HBQuestionTypeTAA) {
        _descButton.hidden = NO;
        [_descButton setBackgroundImage:[UIImage imageNamed:@"test-btn-sound-normal"] forState:UIControlStateNormal];
        [_descButton setBackgroundImage:[UIImage imageNamed:@"test-btn-sound-press"] forState:UIControlStateHighlighted];
    } else if (_questionType == HBQuestionTypeTAP) {
        CGSize size = [_descLabel.text sizeWithAttributes:@{NSFontAttributeName: _descLabel.font }];
        rect.size.height = size.height;
        _descLabel.frame = rect;
    }
    
    NSArray *optionsArr = [_workManager getOptionArray:dict];
    [self initSelectionView:optionsArr];
    
    //若不是最后一题，显示“下一题”，若是最后一题，则未提交过的显示“交作业”。已提交过的显示“完成”
    BOOL isLast = [_workManager isLastObject];
    if (isLast) {
        if (score) {
            [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        } else {
            [_finishButton setTitle:@"交作业" forState:UIControlStateNormal];
        }
        [_finishButton setBackgroundImage:[UIImage imageNamed:@"test-btn-finish-normal"] forState:UIControlStateNormal];
        [_finishButton setBackgroundImage:[UIImage imageNamed:@"test-btn-finish-press"] forState:UIControlStateHighlighted];
    } else {
        [_finishButton setTitle:@"下一题" forState:UIControlStateNormal];
    }
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
        title = @"连接匹配的图片和文字";
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
    _titleLabel.text = [NSString stringWithFormat:@"%ld.%@", _workManager.selIndex+1, title];
}

- (BOOL)isQuestionRight:(NSInteger)answer
{
    BOOL isRight = NO;
    if (selAnswerIndex == answer) {
        isRight = YES;
    }
    
    return isRight;
}

- (void)buttonAction:(id)sender
{
    if (isOptionSelected == NO) {
        [MBHudUtil showTextView:@"您还没有完成这道题哦" inView:nil];
        return;
    }
    if (self.delegate) {
        [self.delegate onTouchFinishedButton];
    }
}

- (void)selectionBtnAction:(id)sender
{
    isOptionSelected = NO;
    NSInteger i = 0;
    NSArray *subViews = [_selectionView subviews];
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (button == sender) {
                isOptionSelected = YES;
                button.selected = YES;
                selAnswerIndex = i;
            } else {
                button.selected = NO;
            }
            i++;
        }
    }
}

#pragma ---HBOptionViewDelegate---

- (void)setOptionViewSelected:(HBOptionView *)optionView
{
    isOptionSelected = NO;
    NSInteger i = 0;
    NSArray *subViews = [_selectionView subviews];
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[HBOptionView class]]) {
            if (view == optionView) {
                isOptionSelected = YES;
                [optionView setSelected:YES];
                selAnswerIndex = i;
            } else {
                [(HBOptionView *)view setSelected:NO];
            }
            i++;
        }
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
