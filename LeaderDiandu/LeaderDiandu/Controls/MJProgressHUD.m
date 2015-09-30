//
//  MJProgressHUD.m
//

#import "MJProgressHUD.h"

@interface MJProgressHUD()
{
    UILabel * label;
    UILabel * detailsLabel;
    
    UIImageView * progessImage;
    UIView * subView;
}

@end

@implementation MJProgressHUD

- (void)dealloc
{
    [self hide];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubView];
        [self setupImageView];
        [self setupLabels];
    }
    return self;
}

- (void)setupSubView
{
    subView = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width-150)/2, self.bounds.size.height/2.5, 150, 100)];
    subView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    subView.layer.masksToBounds = YES;
    subView.layer.cornerRadius = 5;
    [self addSubview:subView];
}

- (void)setupImageView
{
    progessImage = [[UIImageView alloc] initWithFrame:CGRectMake((subView.bounds.size.width-30)/2, 20, 30, 30)];
    progessImage.image = [UIImage imageNamed:@"play_loading"];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.delegate = self;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2 , 0, 0, 1.0)];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.removedOnCompletion = NO;
    animation.repeatCount = MAX_CANON;
    
    [progessImage.layer addAnimation:animation forKey:nil];
    [subView addSubview:progessImage];
}

- (void)setupLabels
{
    detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, progessImage.bounds.size.height + progessImage.bounds.origin.y + 15, subView.bounds.size.width, subView.bounds.size.height-progessImage.bounds.size.height)];
	detailsLabel.font = [UIFont systemFontOfSize:16.0f];
	detailsLabel.adjustsFontSizeToFitWidth = NO;
	detailsLabel.textAlignment = NSTextAlignmentCenter;
	detailsLabel.opaque = NO;
	detailsLabel.backgroundColor = [UIColor clearColor];
	detailsLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
	detailsLabel.numberOfLines = 0;
	
	[subView addSubview:detailsLabel];
}

- (void)setDetailsLabelText:(NSString *)detailsLabelText
{
    detailsLabel.text = detailsLabelText;
}

- (void)setDetailsLabelFont:(UIFont *)detailsLabelFont
{
    detailsLabel.font = detailsLabelFont;
}

- (id)initWithView:(UIView *)view
{
    return [self initWithFrame:view.bounds];
}

- (id)initWithWindow:(UIWindow *)window
{
   return  [self initWithView:window];
}

- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
