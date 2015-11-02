//
//  EColumn.m
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import "EColumn.h"
#import "EColor.h"

@implementation EColumn
@synthesize barColor = _barColor;
@synthesize eColumnDataModel = _eColumnDataModel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _chartLine              = [CAShapeLayer layer];
        _chartLine.lineCap      = kCALineCapButt;
        _chartLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth    = self.frame.size.width;
        _chartLine.strokeEnd    = 0.0;
//        self.clipsToBounds      = YES;
		[self.layer addSublayer:_chartLine];
    }
    return self;
}



-(void)setGrade:(float)grade
{
	_grade = grade;
	UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    [progressline moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height)];
	[progressline addLineToPoint:CGPointMake(self.frame.size.width/2.0, (1 - grade) * self.frame.size.height)];
	
    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapRound];
	_chartLine.path = progressline.CGPath;
	if (_barColor) {
		_chartLine.strokeColor = [_barColor CGColor];
	}else{
		_chartLine.strokeColor = [EGreen CGColor];
	}
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    _chartLine.strokeEnd = 1.0;
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (1 - grade) * self.frame.size.height - 15, self.frame.size.width, 15)];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.text = [NSString stringWithFormat:@"%.f", _grade * 100];
    [self addSubview:tempLabel];
}

- (void)setBarColor:(UIColor *)barColor
{
    _chartLine.strokeColor = [barColor CGColor];
}

- (UIColor *)barColor
{
    return [UIColor colorWithCGColor:_chartLine.strokeColor];
}

-(void)rollBack{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _chartLine.strokeColor = [UIColor clearColor].CGColor;
    } completion:nil];
    
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	//Draw BG
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
	CGContextFillRect(context, rect);
    
}

@end
