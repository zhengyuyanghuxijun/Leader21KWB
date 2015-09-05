//
//  MrLoadingView.m
//  MrLoadingView
//
//  Created by ChenHao on 2/11/15.
//  Copyright (c) 2015 xxTeam. All rights reserved.
//

#import "HHAlertSingleView.h"
#import <QuartzCore/QuartzCore.h>

#define OKBUTTON_BACKGROUND_COLOR [UIColor clearColor] //[UIColor colorWithRed:158/255.0 green:214/255.0 blue:243/255.0 alpha:1]
#define CANCELBUTTON_BACKGROUND_COLOR  [UIColor clearColor]
            //[UIColor colorWithWhite:0.400 alpha:1.000]
#define OKBUTTON_Text_BACKGROUND_COLOR [UIColor blueColor]
#define CANCELBUTTON_Text_BACKGROUND_COLOR  [UIColor colorWithWhite:0.400 alpha:1.000]

#define KTagScrollBtn 1111

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define HHAlertSingleView_SIZE_WIDTH (ScreenWidth - 20 - 20)
#define HHAlertSingleView_SIZE_HEIGHT (350)

//NSInteger const HHAlertSingleView_SIZE_WIDTH = (ScreenWidth - 20);
//NSInteger const HHAlertSingleView_SIZE_HEIGHT = 180;
NSInteger const Simble_SIZE         = 20;
NSInteger const Simble_TOP          = 10;

NSInteger const Button_SIZE_WIDTH        = 100;
NSInteger const Buutton_SIZE_HEIGHT      = 30+20;

NSInteger const HHAlertSingleView_SIZE_TITLE_FONT = 18;
NSInteger const HHAlertSingleView_SIZE_DETAIL_FONT = 16;

static selectButton STAblock;


@interface HHAlertSingleView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *OkButton;

@property (nonatomic, strong) UIView *logoView;

@property (nonatomic, assign) HHAlertStyle mHHAlertStyle;

@property (nonatomic, strong) UIView *VerticalSeparateLine;
@property (nonatomic, strong) UIView *HorizontalSeparateLine;
@property (nonatomic, strong) UIImageView *tagView;

@end


@implementation HHAlertSingleView



+ (instancetype)shared
{
    static dispatch_once_t once = 0;
    static HHAlertSingleView *alert;
    dispatch_once(&once, ^{
        alert = [[HHAlertSingleView alloc] init];
    });
    return alert;
}



- (instancetype)init
{
    
    UIScrollView *_btn  = [[UIScrollView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    _btn.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.600];
    _btn.tag  = KTagScrollBtn;
    [[UIApplication sharedApplication].keyWindow addSubview:_btn];

    self = [[HHAlertSingleView alloc] initWithFrame:CGRectMake(([self getMainScreenSize].width-HHAlertSingleView_SIZE_WIDTH)/2, ([self getMainScreenSize].height-HHAlertSingleView_SIZE_HEIGHT)/2 , HHAlertSingleView_SIZE_WIDTH, HHAlertSingleView_SIZE_HEIGHT)];
    self.alpha = 0;
    [self setBackgroundColor:[UIColor whiteColor]];
    
    return self;
}


+ (void)showAlertWithStyle:(HHAlertStyle )hHAlertStyle inView:(UIView *)view Title:(NSString *)title detail:(NSString *)detail cancelButton:(NSString *)cancel Okbutton:(NSString *)ok
{
    
    [[self shared] configtext:title detail:detail style:hHAlertStyle];
    
    
    [[self shared] configButton:cancel Okbutton:ok];
    
    [view addSubview:[self shared]];
    [[self shared] show];
}

/**
 *  show the alertview and use delegate to know which button is clicked
 *
 *  @param HHAlertStyle     style
 *  @param view             view
 *  @param title            title
 *  @param detailFirst      detailFirst
 *  @param detailSecond     detailSecond
 *  @param ok               okButtonTitle
 */
+ (void)showAlertWithStyle:(HHAlertStyle )hHAlertStyle
                    inView:(UIView *)view
                     Title:(NSString *)title
                    detailFirst:(NSString *)detailFirst
                    detailSecond:(NSString *)detailSecond
                  okButton:(NSString *)ok
{
    [[self shared] configtext:title detailFirst:detailFirst detailSecond:detailSecond style:HHAlertStyleInstructions];
    
    [[self shared] configButton:nil Okbutton:ok];
    
    [view addSubview:[self shared]];
    [[self shared] show];
}



+ (void)showAlertWithStyle:(HHAlertStyle)hHAlertStyle inView:(UIView *)view Title:(NSString *)title detail:(NSString *)detail cancelButton:(NSString *)cancel Okbutton:(NSString *)ok block:(selectButton)block
{
 
    STAblock = block;
    
    [[self shared] configtext:title detail:detail style:hHAlertStyle];
    
    
    [[self shared] configButton:cancel Okbutton:ok];
    [[self shared] configLine:cancel Okbutton:ok];
    
    [view addSubview:[self shared]];
    [[self shared] show];
    
//    [[self shared] drawSingleBtn];
}


- (void)configLine:(NSString *)cancel Okbutton:(NSString *)ok
{
    _HorizontalSeparateLine = [[UIView alloc] initWithFrame:CGRectMake(0, [self getSelfSize].height - Buutton_SIZE_HEIGHT, [self getSelfSize].width, .5f)];
    _HorizontalSeparateLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_HorizontalSeparateLine];
    
    if (cancel!=nil && ok!=nil) {
        if (_VerticalSeparateLine == nil) {
            _VerticalSeparateLine = [[UIView alloc] initWithFrame:CGRectMake([self getSelfSize].width*.5f, [self getSelfSize].height - Buutton_SIZE_HEIGHT, .5f, Buutton_SIZE_HEIGHT)];
        }
        _VerticalSeparateLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_VerticalSeparateLine];
    }
}
- (void)configtext:(NSString *)title detail:(NSString *)detail style:(HHAlertStyle)hHAlertStyle
{
    if (_titleLabel==nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Simble_SIZE+Simble_TOP+15, [self getSelfSize].width, HHAlertSingleView_SIZE_TITLE_FONT+5)];
    }
    
    _titleLabel.text = title;
    [_titleLabel setFont:[UIFont systemFontOfSize:HHAlertSingleView_SIZE_TITLE_FONT]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    if (hHAlertStyle == HHAlertStyleDefault) {
        _titleLabel.textColor = [UIColor blackColor];
    }else
        if (hHAlertStyle == HHAlertStyleOk) {
        _titleLabel.textColor = [UIColor colorWithRed:0.21 green:0.69 blue:0 alpha:1];
    }else
        _titleLabel.textColor = [UIColor colorWithRed:0.84 green:0 blue:0.04 alpha:1];
    [self addSubview:_titleLabel];
    
    

    NSString *description = title;
    CGSize size = [description boundingRectWithSize:CGSizeMake(CGRectGetWidth(_titleLabel.frame),
                                                               CGRectGetHeight(_titleLabel.frame))
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:HHAlertSingleView_SIZE_TITLE_FONT]} context:nil].size;

    if (_tagView == nil) {
        CGRect frame = CGRectMake([self getSelfSize].width*.5f - size.width*.5f - 24-3, CGRectGetMinY(_titleLabel.frame), 24, 24);
        _tagView = [[UIImageView alloc] initWithFrame:frame];
    }else
        _tagView.frame = CGRectMake([self getSelfSize].width*.5f - size.width*.5f - 24 -3, CGRectGetMinY(_titleLabel.frame)-2, 24, 24);
    if (size.width == 0) {
        _tagView.center = CGPointMake([self getSelfSize].width*.5f, _tagView.center.y);
    }
    
    if (hHAlertStyle == HHAlertStyleDefault) {
    }else{
        if (hHAlertStyle == HHAlertStyleOk) {
            _tagView.image = [UIImage imageNamed:@"menu_head"];
        }else
            _tagView.image = [UIImage imageNamed:@"menu_head"];
        [self addSubview:_tagView];
    }
    
    if (_detailLabel==nil) {
        _detailLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, Simble_SIZE+Simble_TOP+HHAlertSingleView_SIZE_TITLE_FONT+25, [self getSelfSize].width, HHAlertSingleView_SIZE_TITLE_FONT*3)];
    }
    _detailLabel.numberOfLines = 2;
    _detailLabel.text = detail;
    _detailLabel.textColor = [UIColor colorWithRed:0.47 green:0.21 blue:0.47 alpha:1];
    [_detailLabel setFont:[UIFont systemFontOfSize:HHAlertSingleView_SIZE_DETAIL_FONT]];
    [_detailLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_detailLabel];
    
}

- (void)configtext:(NSString *)title detailFirst:(NSString *)detailFirst detailSecond:(NSString *)detailSecond style:(HHAlertStyle)hHAlertStyle
{
    if (_titleLabel==nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Simble_SIZE+Simble_TOP+15, [self getSelfSize].width, HHAlertSingleView_SIZE_TITLE_FONT+5)];
    }
    
    _titleLabel.text = title;
    [_titleLabel setFont:[UIFont systemFontOfSize:HHAlertSingleView_SIZE_TITLE_FONT]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    if (hHAlertStyle == HHAlertStyleDefault) {
        _titleLabel.textColor = [UIColor blackColor];
    }else
        if (hHAlertStyle == HHAlertStyleOk) {
            _titleLabel.textColor = [UIColor colorWithRed:0.21 green:0.69 blue:0 alpha:1];
        }else
            _titleLabel.textColor = [UIColor colorWithRed:0.84 green:0 blue:0.04 alpha:1];
    [self addSubview:_titleLabel];
    
    NSInteger contentFirstHeight = [self getScrollViewHeight:detailFirst];
    UILabel *contentFirstLabel  = [[UILabel alloc] initWithFrame:CGRectMake(20, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 30, 240 + ScreenWidth - 320, contentFirstHeight)];
    
    contentFirstLabel.text = detailFirst;
    contentFirstLabel.textColor = [UIColor colorWithRed:0.47 green:0.21 blue:0.47 alpha:1];
    [contentFirstLabel setFont:[UIFont systemFontOfSize:HHAlertSingleView_SIZE_DETAIL_FONT]];
    contentFirstLabel.textAlignment = NSTextAlignmentLeft;
    contentFirstLabel.lineBreakMode = NSLineBreakByCharWrapping;
    contentFirstLabel.numberOfLines = 0;
    [contentFirstLabel sizeToFit];
    [self addSubview:contentFirstLabel];
    
    NSInteger contentSecondHeight = [self getScrollViewHeight:detailSecond];
    UILabel *contentSecondLabel  = [[UILabel alloc] initWithFrame:CGRectMake(20, contentFirstLabel.frame.origin.y + contentFirstLabel.frame.size.height + 30, 240 + ScreenWidth - 320, contentSecondHeight)];
    
    contentSecondLabel.text = detailSecond;
    contentSecondLabel.textColor = [UIColor colorWithRed:0.47 green:0.21 blue:0.47 alpha:1];
    [contentSecondLabel setFont:[UIFont systemFontOfSize:HHAlertSingleView_SIZE_DETAIL_FONT]];
    contentSecondLabel.textAlignment = NSTextAlignmentLeft;
    contentSecondLabel.lineBreakMode = NSLineBreakByCharWrapping;
    contentSecondLabel.numberOfLines = 0;
    [contentSecondLabel sizeToFit];
    [self addSubview:contentSecondLabel];
}

/**
 *	@brief	获取内容高度
 *
 *	@param 	string 	内容
 *
 *	@return	CGFloat
 */
- (CGFloat)getScrollViewHeight:(NSString *)string
{
    CGSize maxSize=CGSizeMake(280 + ScreenWidth - 320, 10000);
    CGSize contentSize=[string sizeWithFont:[UIFont systemFontOfSize:HHAlertSingleView_SIZE_DETAIL_FONT]constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    return contentSize.height;
}

- (void)configButton:(NSString *)cancel Okbutton:(NSString *)ok
{
    if (cancel==nil) {
        if (_OkButton==nil) {
            _OkButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                   [self getSelfSize].height-Buutton_SIZE_HEIGHT, [self getSelfSize].width, Buutton_SIZE_HEIGHT)];
        }
        else
        {
            [_OkButton setFrame:CGRectMake(0, [self getSelfSize].height-Buutton_SIZE_HEIGHT, [self getSelfSize].width, Buutton_SIZE_HEIGHT)];
        }
        
        [_OkButton setTitle:ok forState:UIControlStateNormal];
        [_OkButton setTitleColor:OKBUTTON_Text_BACKGROUND_COLOR forState:UIControlStateNormal];
        [_OkButton setBackgroundColor:OKBUTTON_BACKGROUND_COLOR];
        //[[_OkButton layer] setCornerRadius:5];
     
        [_OkButton addTarget:self action:@selector(dismissWithOk) forControlEvents:UIControlEventTouchUpInside];

        
        
        [self addSubview:_OkButton];
        
    }
    
    
    if (cancel!=nil && ok!=nil) {
        if (_cancelButton == nil) {
            _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                       [self getSelfSize].height-Buutton_SIZE_HEIGHT, [self getSelfSize].width/2, Buutton_SIZE_HEIGHT)];
        }
        
        [_cancelButton setBackgroundColor:CANCELBUTTON_BACKGROUND_COLOR];
        [_cancelButton setTitle:cancel forState:UIControlStateNormal];
        [_cancelButton setTitleColor:CANCELBUTTON_Text_BACKGROUND_COLOR forState:UIControlStateNormal];
        //[[_cancelButton layer] setCornerRadius:5];
//        _cancelButton.layer.borderWidth = 1.0f;
//        _cancelButton.clipsToBounds = YES;
//        _cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_cancelButton addTarget:self action:@selector(dismissWithCancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        
        
        
        if (_OkButton==nil) {
            _OkButton = [[UIButton alloc] initWithFrame:CGRectMake([self getSelfSize].width/2,
                                                                   [self getSelfSize].height-Buutton_SIZE_HEIGHT,
                                                                   [self getSelfSize].width/2, Buutton_SIZE_HEIGHT)];
        }
        else
        {
            [_OkButton setFrame:CGRectMake([self getSelfSize].width/2,
                                           [self getSelfSize].height-Buutton_SIZE_HEIGHT,
                                           [self getSelfSize].width/2, Buutton_SIZE_HEIGHT)];
        }
        
        [_OkButton setTitle:ok forState:UIControlStateNormal];
        [_OkButton setTitleColor:OKBUTTON_Text_BACKGROUND_COLOR forState:UIControlStateNormal];
//        _OkButton.layer.borderWidth = 1.0f;
//        _OkButton.clipsToBounds = YES;
//        _OkButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //[[_OkButton layer] setCornerRadius:5];
        [_OkButton addTarget:self action:@selector(dismissWithOk) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_OkButton];
    }
}

- (void)dismissWithCancel
{
    
    if (STAblock!=nil) {
        STAblock(HHAlertButtonCancel);
    }
    else
    {
        [_delegate didClickButtonAnIndex:HHAlertButtonCancel];
    }
    [HHAlertSingleView Hide];
}

- (void)dismissWithOk
{
    
    if (STAblock!=nil) {
        STAblock(HHAlertButtonOk);
    }
    else
    {
        [_delegate didClickButtonAnIndex:HHAlertButtonOk];
    }
    [HHAlertSingleView Hide];
}


- (void)destroy
{
    
    UIScrollView *_btn = (UIScrollView *)[[UIApplication sharedApplication].keyWindow viewWithTag:KTagScrollBtn];
    _btn.hidden = YES;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha=0;
        self.layer.cornerRadius = 10;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowOpacity = 0.3f;
        self.layer.shadowRadius = 10.0f;
    } completion:^(BOOL finished) {
        [_OkButton removeFromSuperview];
        [_cancelButton removeFromSuperview];
        _OkButton=nil;
        _cancelButton = nil;
        STAblock=nil;
        [_VerticalSeparateLine removeFromSuperview];
        [self removeFromSuperview];
        [_tagView removeFromSuperview];
    }];
}



- (void)show
{
    UIScrollView *_btn = (UIScrollView *)[[UIApplication sharedApplication].keyWindow viewWithTag:KTagScrollBtn];
    _btn.hidden = YES;
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha=1.0;
        self.layer.cornerRadius = 10;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowOpacity = 0.3f;
        self.layer.shadowRadius = 10.0f;
    } completion:^(BOOL finished) {
        
    }];
}


+ (void)Hide
{
    [[self shared] destroy];
}


#pragma helper mehtod

- (CGSize)getMainScreenSize
{
    return [[UIScreen mainScreen] bounds].size;
}

- (CGSize)getSelfSize
{
    return self.frame.size;
}
//-(void)drawRect:(CGRect)rect{
//}
//- (void)drawSingleBtn{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色
//
//    CGPoint aPoints[2];//坐标点
//    aPoints[0]=CGPointMake(0,30);//坐标1
//    aPoints[1]=CGPointMake(100,30);//坐标
//    CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色
//    CGContextDrawPath(context,kCGPathStroke);
//    
//
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Simble_SIZE/2, Simble_SIZE/2) radius:Simble_SIZE/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
//    
//    path.lineCapStyle = kCGLineCapRound;
//    path.lineJoinStyle = kCGLineCapRound;
//    
//    [path moveToPoint:CGPointMake(Simble_SIZE/4, Simble_SIZE/2)];
//    CGPoint p1 = CGPointMake(Simble_SIZE/4+10, Simble_SIZE/2+10);
//    [path addLineToPoint:p1];
//    
//    
//    CGPoint p2 = CGPointMake(Simble_SIZE/4*3, Simble_SIZE/4);
//    [path addLineToPoint:p2];
//
//    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//    layer.fillColor = [UIColor clearColor].CGColor;
//    layer.strokeColor = [UIColor greenColor].CGColor;
//    layer.lineWidth = 1;
//    layer.path = path.CGPath;
//    [self.layer addSublayer:layer];
//}
//
//- (void)drawTwoBtn{
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Simble_SIZE/2, Simble_SIZE/2)
//                                                        radius:Simble_SIZE/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
//
//}
@end
