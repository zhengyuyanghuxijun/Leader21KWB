//
//  HBNTextField.m
//  LeaderDiandu
//
//  Created by hxj on 15/8/12.
//
//

#import "HBNTextField.h"
#import <objc/runtime.h>


#define kLeftPadding 0
#define kVerticalPadding 12
#define kHorizontalPadding 10
#define kMessageArrowWidth 20
#define kMessageLeftRedWidth 5
#define kTitleLabelWidth 80

#define FF_MULTILINE_TEXTSIZE(text, font, maxSize) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;

@interface HBNTextField (){
    HBNTextFieldType _type;
}
@property (nonatomic, strong) UIButton *seePasswordButton;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *messageLeftRed;
@property (nonatomic, strong) UIImageView *messageBackgroudView;
@property (nonatomic, getter=isShowingMessage) BOOL showingMessage;
//包含图片的textField需要加messageLabel在UITextfieldLabel上，附加调整间距
@property (nonatomic, assign) CGFloat messageEdge;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) HBNTextFieldErrorMessageType errorType;
@property (nonatomic, strong) NSString *message;

@end


@implementation HBNTextField


- (void)awakeFromNib
{
    
    [self setupMessageLabel];
    [self addNotification];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setupMessageLabel];
        [self addNotification];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setupTextFieldWithType:(HBNTextFieldType)type withIconName:(NSString *)name{
    UIEdgeInsets edge = [self edgeInsetsForType:type];
    NSString *imageName = [self backgroundImageNameForType:type];
    CGRect imageViewFrame = [self iconImageViewRectForType:type];
    _type = type;
    
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image resizableImageWithCapInsets:edge];
    
    [self setBackground:image];
    
    UIImage *icon = [self scalImageWithImage:[UIImage imageNamed:name]];
    UIImageView * iconImage = [[UIImageView alloc] initWithFrame:imageViewFrame];
    [iconImage setImage:icon];
    [iconImage setContentMode:UIViewContentModeScaleAspectFit];
    [self setUpLeftViewWithType:type image:iconImage];
    if ([self respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:0.41 green:0.41 blue:0.41 alpha:1];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder?:@"" attributes:@{NSForegroundColorAttributeName: color/*,NSFontAttributeName:[UIFont systemFontOfSize:14]*/}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    [self setUpMessageEdgeAndRightButtonWithType:type];
    [self setNeedsDisplay]; //force reload for updated editing rect for bound to take effect.
}

- (void)setUpLeftViewWithType:(HBNTextFieldType)type image:(UIImageView *)iconImage
{
    //make an imageview to show an icon on the left side of textfield
    if (type == HBNTextFieldTypeWithTitle) {
        UIView *leftHolder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iconImage.frame.size.width + kTitleLabelWidth, iconImage.frame.size.height)];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(iconImage.frame.size.width, 0, kTitleLabelWidth, iconImage.frame.size.height)];
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = [UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1];
        [leftHolder addSubview:title];
        [leftHolder addSubview:iconImage];
        self.titleLabel = title;
        self.leftView = leftHolder;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    else {
        self.leftView = iconImage;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
}

- (void)setUpMessageEdgeAndRightButtonWithType:(HBNTextFieldType)type
{
    
    if (type == HBNTextFieldTypePassword) {
        self.secureTextEntry = YES;
        [self addPasswordEye];
    }
    if (type == HBNTextFieldTypeVerifyCode) {
        self.messageEdge = 13;
    }
    else if (type == HBNTextFieldTypeWithTitle)
        self.messageEdge = 40 + kTitleLabelWidth;
    else {
        self.messageEdge = 40;
    }
}

- (CGRect)iconImageViewRectForType:(HBNTextFieldType) type{
     UIEdgeInsets edge = [self edgeInsetsForType:type];
     if (type == HBNTextFieldTypeRound) {
         return CGRectMake(0, 0, edge.left, self.frame.size.height); //to put the icon inside
     }
    if (type == HBNTextFieldTypeVerifyCode) {
        return CGRectMake(0, 0, edge.left, self.frame.size.height);
    }
     /*
      if (type == HBNTextFieldTypeBlahBlah) {
      return 786; //whatever suits your field
      }
      */
     
     return CGRectMake(0, 0, edge.left, self.frame.size.height); // default
 }
- (UIEdgeInsets)edgeInsetsForType:(HBNTextFieldType) type{
    if (type == HBNTextFieldTypeRound) {
        return UIEdgeInsetsMake(13, 13, 13, 13);
    }
    if (type == HBNTextFieldTypeVerifyCode) {
        return UIEdgeInsetsMake(13, 13, 13, 13);
    }
    /*
     if (type == HBNTextFieldTypeBlahBlah) {
     return UIEdgeInsetsMake(15, 15, 15, 15); //whatever suits your field
     }
     */
    
    return UIEdgeInsetsMake(10, 40, 10, 19); // default
}
- (NSString *)backgroundImageNameForType:(HBNTextFieldType) type{
    if (type == HBNTextFieldTypeRound) {
        return @"round_textfield";
    }
    /*
     if (type == HBNTextFieldTypeBlahBlah) {
     return @""; // return suitable
     }
     */
    
    return @"text_field"; // default
}

- (UIImage *)scalImageWithImage:(UIImage *)originalImage
{
    CGRect rect = CGRectMake(12,12,originalImage.size.width, originalImage.size.height);
    UIGraphicsBeginImageContextWithOptions(CGRectInset(rect, -12, -12).size, NO, 0);
    [originalImage drawInRect:rect];
    UIImage *productImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(productImage);
    UIImage *img = [UIImage imageWithData:imageData];
    return img;
}

#pragma mark - MessageLabel
- (void)setupMessageLabel
{
    self.backgroundColor = [UIColor whiteColor];
    self.font = [UIFont systemFontOfSize:14];
    if (self.placeholder.length == 0) {
        self.placeholder = @" ";
    }
    UILabel *displayLabel = [self valueForKeyPath:@"placeholderLabel"];
    self.showingMessage = NO;
    self.messageBackgroudView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.messageBackgroudView.image = [[UIImage imageNamed:@"warning"]stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [displayLabel addSubview:self.messageBackgroudView];
    
    self.messageLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.font = self.font;
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.textColor = [UIColor colorWithRed:0.86 green:0.06 blue:0.42 alpha:1];
    [displayLabel addSubview:self.messageLabel];
    
    self.messageLeftRed = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
    self.messageLeftRed.backgroundColor = [UIColor colorWithRed:0.86 green:0.06 blue:0.42 alpha:1];
    [self addSubview:self.messageLeftRed];
}

- (void)adjustMessageLabelOwner
{
    UILabel *displayLabel = [self valueForKeyPath:@"displayLabel"];
    UILabel *placeholderLabel = [self valueForKeyPath:@"placeholderLabel"];
    if (self.isFirstResponder) {
        [self addSubview:self.messageBackgroudView];
        [self addSubview:self.messageLabel];
    }
    else {
        if (displayLabel.text.length > 0) {
            [displayLabel addSubview:self.messageBackgroudView];
            [displayLabel addSubview:self.messageLabel];
        }
        else {
            [placeholderLabel addSubview:self.messageBackgroudView];
            [placeholderLabel addSubview:self.messageLabel];
        }
    }
    if (self.isShowingMessage == YES) {
        CGRect messageBackgroudFrame = self.messageBackgroudView.frame;
        CGRect messageLabelFrame = self.messageLabel.frame;
        messageBackgroudFrame.origin.x -= self.messageEdge;
        messageLabelFrame.origin.x -= self.messageEdge;
        self.messageBackgroudView.frame = messageBackgroudFrame;
        self.messageLabel.frame = messageLabelFrame;
    }
    if (self.errorType == HBNTextFieldErrorMessageTypeDefault) {
        self.messageBackgroudView.image = [[UIImage imageNamed:@"warning"]stretchableImageWithLeftCapWidth:20 topCapHeight:0];
        self.messageLabel.textColor = [UIColor colorWithRed:0.86 green:0.06 blue:0.42 alpha:1];
        self.messageLeftRed.backgroundColor = [UIColor colorWithRed:0.86 green:0.06 blue:0.42 alpha:1];
    }
    else if (self.errorType == HBNTextFieldErrorMessageTypeYellow) {
        self.messageBackgroudView.image = [[UIImage imageNamed:@"warning_yellow"]stretchableImageWithLeftCapWidth:20 topCapHeight:0];
        self.messageLabel.textColor = [UIColor colorWithRed:0.87 green:0.75 blue:0.06 alpha:1];
        self.messageLeftRed.backgroundColor = [UIColor colorWithRed:0.87 green:0.75 blue:0.06 alpha:1];
    }
}

- (void)showErrorMessage:(NSString *)message
{
    if (self.isShowingMessage) {
        return;
    }
    self.showingMessage = YES;
    self.message = message;
    [self adjustMessageLabelOwner];
    self.messageBackgroudView.frame = CGRectMake(self.frame.size.width - [self margin], 0, 0, self.frame.size.height);
    self.messageLabel.frame = CGRectMake(self.frame.size.width - [self margin], 0, 0, self.frame.size.height);
    CGSize size = FF_MULTILINE_TEXTSIZE(message, self.messageLabel.font, CGSizeMake(self.frame.size.width - 80, self.frame.size.height));
    CGRect messageFrame = self.messageLabel.frame;
    messageFrame.size.width = size.width;
    messageFrame.origin.x -= size.width;
    CGRect messageLabelBackgroundViewFrame = messageFrame;
    messageFrame.origin.x -= kMessageArrowWidth/3.0f;
    messageLabelBackgroundViewFrame.size.width += kMessageArrowWidth;
    messageLabelBackgroundViewFrame.origin.x -= kMessageArrowWidth;
    CGRect messageLeftRedFrame = self.messageLeftRed.frame;
    messageLeftRedFrame.size.width += kMessageLeftRedWidth;
    self.messageLabel.text = message;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.messageLabel.frame = messageFrame;
        self.messageBackgroudView.frame = messageLabelBackgroundViewFrame;
        self.messageLeftRed.frame = messageLeftRedFrame;
    } completion:^(BOOL finished) {

    }];
}

- (void)showErrorMessage:(NSString *)message withType:(HBNTextFieldErrorMessageType)type {
    self.errorType = type;
    [self showErrorMessage:message];
}

- (void)hideErrorMessage
{
    if (!self.isShowingMessage) {
        return;
    }
    CGRect messageFrame = CGRectMake(self.frame.size.width - [self margin], 0, 0, self.frame.size.height);
    CGRect messageLabelBackgroundViewFrame = CGRectMake(self.frame.size.width - [self margin], 0, 0, self.frame.size.height);
    CGRect messageLeftRedFrame = CGRectMake(0, 0, 0, self.frame.size.height);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.messageLabel.frame = messageFrame;
        self.messageBackgroudView.frame = messageLabelBackgroundViewFrame;
        self.messageLeftRed.frame = messageLeftRedFrame;
    } completion:^(BOOL finished) {
        self.showingMessage = NO;
    }];
}

- (CGFloat)margin
{
    CGFloat rate = 1;
    if (self.isFirstResponder) {
        rate = 0;
    }
    return self.messageEdge*rate;
}

- (void)setTitleLabelText:(NSString *)title
{
    self.titleLabel.text = title;
}

#pragma mark - PasswordAddtion
- (void)addPasswordEye
{
    self.seePasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.seePasswordButton.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    [self.seePasswordButton setBackgroundImage:[self scalImageWithImage:[UIImage imageNamed:@"eye_close"]] forState:UIControlStateNormal];
    [self.seePasswordButton setBackgroundImage:[self scalImageWithImage:[UIImage imageNamed:@"eye"]] forState:UIControlStateSelected];
    [self.seePasswordButton addTarget:self action:@selector(changeSecureTextEntry) forControlEvents:UIControlEventTouchUpInside];
    self.rightView = self.seePasswordButton;
    self.rightViewMode = UITextFieldViewModeAlways;
}

- (void)changeSecureTextEntry
{
    self.secureTextEntry = self.seePasswordButton.selected;
    self.seePasswordButton.selected = !self.seePasswordButton.selected;
}

#pragma mark - Notification
- (void)beginEditing:(NSNotification*) notification {
    if (self.isShowingMessage) {
        [self hideErrorMessage];
    }
}

- (void)endEditing {
    [self adjustMessageLabelOwner];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endEditing) name:UITextFieldTextDidEndEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
}

@end
