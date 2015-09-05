//
//  ReadBookToolBar.m
//  magicEnglish
//
//  Created by wangzhenchao on 14-3-12.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookToolBar.h"

@interface ReadBookToolBar()

@property (nonatomic, strong) UIButton *prePageButton;
@property (nonatomic, strong) UIButton *nextPageButton;
@property (nonatomic, strong) UILabel *pageLabel;

@property (nonatomic, strong) UIButton *prePageHelperButton;
@property (nonatomic, strong) UIButton *nextPageHelperButton;
@property (nonatomic, strong) UIButton *ocHelperButton;
@property (nonatomic, strong) UIButton *prHelperButton;
@property (nonatomic, strong) UIButton *autoHelperButton;

@property (nonatomic, strong) UIButton *ocModelButton;
@property (nonatomic, strong) UIButton *prModelButton;
@property (nonatomic, strong) UIButton *autoPlayButton;

@property (nonatomic, strong) UIImageView *middleIcon;

@end

@implementation ReadBookToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initOutlet];
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor colorWithRed:.18f green:.62f blue:.80f alpha:1.0f];
    if (_toolBarType == BAR_TYPE_NORMAL) {
        [self layoutNormal];
    }
    else
    {
        [self layoutPR];
    }
}

- (void)setToolBarType:(ToolBarType)toolBarType
{
    if (_toolBarType != toolBarType) {
        _toolBarType = toolBarType;
        if (_toolBarType == BAR_TYPE_NORMAL) {
            [self layoutNormal];
        }
        else if(_toolBarType == BAR_TYPE_PR)
        {
            [self layoutPR];
        }
        else
        {
            [self layoutSplit];
        }
    }
}

- (void)initOutlet
{
    UIImage *prePageImage = [UIImage imageNamed:@"prev"];
    self.prePageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.prePageButton.frame = CGRectMake(10, 0, prePageImage.size.width, prePageImage.size.height);
    self.prePageButton.tag = PRE_PAGE_BUTTON;
    self.prePageButton.centerY = self.height/2;
    [self.prePageButton setImage:prePageImage forState:UIControlStateNormal];
    [self.prePageButton setImage:[UIImage imageNamed:@"prev_pressed"] forState:UIControlStateHighlighted];
    [self.prePageButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.prePageButton];
    
    self.prePageHelperButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.prePageHelperButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.prePageHelperButton.tag = PRE_PAGE_BUTTON;
    [self addSubview:self.prePageHelperButton];
    
    self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.prePageButton.right + 10, 0, 40, 30)];
    self.pageLabel.centerY = self.height/2;
    self.pageLabel.layer.cornerRadius = 2.0f;
    self.pageLabel.layer.masksToBounds = YES;
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    self.pageLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.pageLabel];
    
    UIImage *nextPageImage = [UIImage imageNamed:@"next"];
    self.nextPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextPageButton.frame = CGRectMake(self.pageLabel.right + 10, 0, nextPageImage.size.width, nextPageImage.size.height);
    self.nextPageButton.tag = NEXT_PAGE_BUTTON;
    self.nextPageButton.centerY = self.height/2;
    [self.nextPageButton setImage:nextPageImage forState:UIControlStateNormal];
    [self.nextPageButton setImage:[UIImage imageNamed:@"next_pressed"] forState:UIControlStateHighlighted];
    [self.nextPageButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextPageButton];
    
    self.nextPageHelperButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextPageHelperButton.tag = NEXT_PAGE_BUTTON;
    [self.nextPageHelperButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextPageHelperButton];
    
    UIImage *prModelImage = [UIImage imageNamed:@"menu_bar_button"];
    self.prModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.prModelButton.frame = CGRectMake(self.nextPageButton.right + 20, 0, prModelImage.size.width, prModelImage.size.height);
    self.prModelButton.centerY = self.height/2;
    self.prModelButton.tag = PR_MODEL_BUTTON;
    [self.prModelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.prModelButton setImage:[UIImage imageNamed:@"preview_icon"] forState:UIControlStateNormal];
    [self.prModelButton setBackgroundImage:prModelImage forState:UIControlStateNormal];
    [self.prModelButton setBackgroundImage:[UIImage imageNamed:@"menu_bar_button_pressed"] forState:UIControlStateHighlighted];
    [self.prModelButton setBackgroundImage:[UIImage imageNamed:@"btn_reader_w_disable"] forState:UIControlStateDisabled];
    [self addSubview:self.prModelButton];
    
    self.prHelperButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.prHelperButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.prHelperButton.tag = PR_MODEL_BUTTON;
    [self addSubview:self.prHelperButton];
    
    UIImage *ocModelImage = [UIImage imageNamed:@"menu_bar_button"];
    self.ocModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ocModelButton.frame = CGRectMake(self.prModelButton.right + 20, 0, ocModelImage.size.width, ocModelImage.size.height);
    self.ocModelButton.centerY = self.height/2;
    self.ocModelButton.tag = OC_MODEL_BUTTON;
    [self.ocModelButton setImage:ocModelImage forState:UIControlStateNormal];
    [self.ocModelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.ocModelButton setImage:[UIImage imageNamed:@"online_icon"] forState:UIControlStateNormal];
    [self.ocModelButton setBackgroundImage:ocModelImage forState:UIControlStateNormal];
    [self.ocModelButton setBackgroundImage:[UIImage imageNamed:@"menu_bar_button_pressed"] forState:UIControlStateHighlighted];
    [self.ocModelButton setBackgroundImage:[UIImage imageNamed:@"btn_reader_w_disable"] forState:UIControlStateDisabled];
    [self addSubview:self.ocModelButton];
    
    self.ocHelperButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ocHelperButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.ocHelperButton.tag = OC_MODEL_BUTTON;
    [self addSubview:self.ocHelperButton];

    
    UIImage *autoModelImage = [UIImage imageNamed:@"menu_bar_button"];
    self.autoPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.autoPlayButton.frame = CGRectMake(self.ocModelButton.right + 20, 0, autoModelImage.size.width, autoModelImage.size.height);
    self.autoPlayButton.centerY = self.height/2;
    self.autoPlayButton.tag = AUTO_PLAY_BUTTON;
    [self.autoPlayButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.autoPlayButton setImage:[UIImage imageNamed:@"autoplay_icon"] forState:UIControlStateNormal];
    [self.autoPlayButton setBackgroundImage:ocModelImage forState:UIControlStateNormal];
    [self.autoPlayButton setBackgroundImage:[UIImage imageNamed:@"menu_bar_button_pressed"] forState:UIControlStateHighlighted];
    [self.autoPlayButton setBackgroundImage:[UIImage imageNamed:@"btn_reader_w_disable"] forState:UIControlStateSelected];
    self.autoPlayButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:self.autoPlayButton];
    
    self.autoHelperButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.autoHelperButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.autoHelperButton.tag = AUTO_PLAY_BUTTON;
    [self addSubview:self.autoHelperButton];
    
    self.middleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"preview_icon"]];
    self.middleIcon.center = CGPointMake(self.width/2, self.height/2);
    [self addSubview:self.middleIcon];
}

- (void)layoutNormal
{
    self.middleIcon.hidden = YES;
    self.pageLabel.hidden = NO;
    self.ocModelButton.hidden = NO;
    self.prModelButton.hidden = NO;
    self.autoPlayButton.hidden = NO;
    
    self.prePageHelperButton.hidden = YES;
    self.nextPageHelperButton.hidden = YES;
    self.ocHelperButton.hidden = YES;
    self.prHelperButton.hidden = YES;
    self.autoHelperButton.hidden = YES;
    
    NSInteger padLeftOffset = 0;
    NSInteger padSpaceOffset = 0;
    
    if ([DE isPad]) {
        padLeftOffset = 88;
        padSpaceOffset = 30;
    }
    
    UIImage *prePageImage = [UIImage imageNamed:@"prev"];
    self.prePageButton.frame = CGRectMake(10+padLeftOffset, 0, prePageImage.size.width, prePageImage.size.height);
    self.prePageButton.centerY = self.height/2;
    
    self.pageLabel.frame = CGRectMake(self.prePageButton.right + 10 +padSpaceOffset, 0, 40, 30);
    self.pageLabel.centerY = self.height/2;
    
    UIImage *nextPageImage = [UIImage imageNamed:@"next"];
    self.nextPageButton.frame = CGRectMake(self.pageLabel.right + 10 +padSpaceOffset, 0, nextPageImage.size.width, nextPageImage.size.height);
    self.nextPageButton.centerY = self.height/2;
    
    UIImage *prModelImage = [UIImage imageNamed:@"menu_bar_button"];
    self.prModelButton.frame = CGRectMake(self.nextPageButton.right + 20 +padSpaceOffset, 0, prModelImage.size.width, prModelImage.size.height);
    self.prModelButton.centerY = self.height/2;
    
    UIImage *ocModelImage = [UIImage imageNamed:@"menu_bar_button"];
    self.ocModelButton.frame = CGRectMake(self.prModelButton.right + 20 +padSpaceOffset, 0, ocModelImage.size.width, ocModelImage.size.height);
    self.ocModelButton.centerY = self.height/2;
    
    UIImage *autoModelImage = [UIImage imageNamed:@"menu_bar_button"];
    self.autoPlayButton.frame = CGRectMake(self.ocModelButton.right + 20 +padSpaceOffset, 0, autoModelImage.size.width, autoModelImage.size.height);
    self.autoPlayButton.centerY = self.height/2;
}

- (void)layoutSplit
{
    self.middleIcon.hidden = YES;
    self.pageLabel.hidden = NO;
    self.ocModelButton.hidden = NO;
    self.prModelButton.hidden = NO;
    self.autoPlayButton.hidden = NO;
    
    self.prePageHelperButton.hidden = NO;
    self.nextPageHelperButton.hidden = NO;
    self.ocHelperButton.hidden = NO;
    self.prHelperButton.hidden = NO;
    self.autoHelperButton.hidden = NO;
    
    
    NSInteger padLeftOffset = 0;
    NSInteger padSpaceOffset = 0;
    
    if ([DE isPad]) {
        padLeftOffset = 88;
        padSpaceOffset = 30;
    }
    
    
    UIImage *prePageImage = [UIImage imageNamed:@"prev"];
    self.prePageButton.frame = CGRectMake(70 + padLeftOffset, 0, prePageImage.size.width, prePageImage.size.height);
    self.prePageButton.centerY = self.height/2;
    self.prePageHelperButton.frame = CGRectMake(70 + padLeftOffset, 0, self.height, self.height);

    self.pageLabel.frame = CGRectMake(self.prePageButton.right + 30 +padSpaceOffset, 0, 50, 30);
    self.pageLabel.centerY = self.height/2;
    
    UIImage *nextPageImage = [UIImage imageNamed:@"next"];
    self.nextPageButton.frame = CGRectMake(self.pageLabel.right + 30 +padSpaceOffset, 0, nextPageImage.size.width, nextPageImage.size.height);
    self.nextPageButton.centerY = self.height/2;
    self.nextPageHelperButton.frame = CGRectMake(self.pageLabel.right + 30 +padSpaceOffset, 0, self.height, self.height);

    UIImage *prModelImage = [UIImage imageNamed:@"menu_bar_button"];
    self.prModelButton.frame = CGRectMake(self.nextPageButton.right + 40 +padSpaceOffset, 0, prModelImage.size.width, prModelImage.size.height);
    self.prModelButton.centerY = self.height/2;
    self.prHelperButton.frame = CGRectMake(self.nextPageButton.right + 40 +padSpaceOffset, 0, self.height, self.height);
    
    UIImage *ocModelImage = [UIImage imageNamed:@"menu_bar_button"];
    self.ocModelButton.frame = CGRectMake(self.prModelButton.right + 40 +padSpaceOffset, 0, ocModelImage.size.width, ocModelImage.size.height);
    self.ocModelButton.centerY = self.height/2;
    self.ocHelperButton.frame = CGRectMake(self.prModelButton.right + 40 +padSpaceOffset, 0, self.height, self.height);
    
    UIImage *autoModelImage = [UIImage imageNamed:@"menu_bar_button"];
    self.autoPlayButton.frame = CGRectMake(self.ocModelButton.right + 40 +padSpaceOffset, 0, autoModelImage.size.width, autoModelImage.size.height);
    self.autoPlayButton.centerY = self.height/2;
    self.autoHelperButton.frame = CGRectMake(self.ocModelButton.right + 40 +padSpaceOffset, 0, self.height, self.height);
}

- (void)layoutPR
{
    self.middleIcon.hidden = NO;
    self.pageLabel.hidden = YES;
    self.ocModelButton.hidden = YES;
    self.prModelButton.hidden = YES;
    self.autoPlayButton.hidden = YES;
    
    self.prePageHelperButton.hidden = YES;
    self.nextPageHelperButton.hidden = YES;
    self.ocHelperButton.hidden = YES;
    self.prHelperButton.hidden = YES;
    self.autoHelperButton.hidden = YES;
    
    self.middleIcon.center = CGPointMake(self.width/2, self.height/2);
    
    UIImage *prePageImage = [UIImage imageNamed:@"prev"];
    self.prePageButton.frame = CGRectMake(self.middleIcon.left - prePageImage.size.width - 30, 0, prePageImage.size.width, prePageImage.size.height);
    self.prePageButton.centerY = self.height/2;
    
    UIImage *nextPageImage = [UIImage imageNamed:@"next"];
    self.nextPageButton.frame = CGRectMake(self.middleIcon.right + 30, 0, nextPageImage.size.width, nextPageImage.size.height);
    self.nextPageButton.centerY = self.height/2;
}

- (void)buttonPressed:(UIButton *)button
{
    if (self.toolButtonClickBlock) {
        self.toolButtonClickBlock(button.tag);
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (self.toolBarType == BAR_TYPE_NORMAL) {
        self.pageLabel.text = [NSString stringWithFormat:@"%d",currentIndex + 1];
    }
    else
    {
        if ((currentIndex + 1) % 2 == 0) {
            self.pageLabel.text = [NSString stringWithFormat:@"%d-%d",currentIndex-1,currentIndex ];
        }
        else
        {
            self.pageLabel.text = [NSString stringWithFormat:@"%d-%d",currentIndex ,currentIndex + 1];
        }
    }
    
}

- (void)enableOCModel:(BOOL)isEnable
{
    self.ocModelButton.enabled = isEnable;
    self.ocHelperButton.enabled = isEnable;
}

- (void)enablePRModel:(BOOL)isEnable
{
    self.prModelButton.enabled = isEnable;
    self.prHelperButton.enabled = isEnable;
}

- (void)enableAutoPlay:(BOOL)isEnable
{
    self.autoPlayButton.selected = !isEnable;
}
@end
