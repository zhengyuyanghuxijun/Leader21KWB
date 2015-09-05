//
//  ViewController.m
//  LeaderDiandu
//
//  Created by xijun on 15/8/22.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "ViewController.h"
#import "HBGridView.h"
#import "TextGridItemView.h"

#define CONST_animation_time 0.2
#define CONST_enlarge_proportion 2.0
#define DataSourceCount 75

@interface ViewController () <HBGridViewDelegate>
{
    HBGridView *_gridView;
    NSMutableArray *_dataSource;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _gridView = [[HBGridView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    _gridView.delegate = self;
    [self.view addSubview:_gridView];
    
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger index = 0; index < DataSourceCount; ++index)
    {
        [_dataSource addObject:[NSNumber numberWithInteger:index]];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(60, 60, 60, 60);
    [self.view addSubview:btn];
    [btn setBackgroundImage:[UIImage imageNamed:@"Safari.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(onBtnClickDown:) forControlEvents:UIControlEventTouchDown];
}

- (void)onBtnClick:(id)sender
{
    [self deactivate:sender];
    [_dataSource removeAllObjects];
    for (NSInteger index = 0; index < 80; ++index)
    {
        [_dataSource addObject:[NSNumber numberWithInteger:index]];
    }
    [_gridView reloadData];
}

- (void)onBtnClickDown:(id)sender
{
    [self activate:sender];
}

- (void)activate:(UIView*)view
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:CONST_animation_time];
    
    CABasicAnimation *scalingAnimation = (CABasicAnimation *)[view.layer animationForKey:@"scaling"];
    
    if (!scalingAnimation)
    {
        scalingAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scalingAnimation.repeatCount=1;
        scalingAnimation.duration=CONST_animation_time;
        scalingAnimation.autoreverses=NO;
        scalingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        scalingAnimation.fromValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
        scalingAnimation.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(CONST_enlarge_proportion, CONST_enlarge_proportion, 1.0)];
    }
    
    [view.layer addAnimation:scalingAnimation forKey:@"scaling"];
    view.layer.transform = CATransform3DMakeScale(CONST_enlarge_proportion, CONST_enlarge_proportion, 1.0);
    [UIView commitAnimations];
}

- (void)deactivate:(UIView*)view
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:CONST_animation_time];
    
    CABasicAnimation *scalingAnimation = (CABasicAnimation *)[view.layer animationForKey:@"descaling"];
    if (!scalingAnimation)
    {
        scalingAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scalingAnimation.repeatCount=1;
        scalingAnimation.duration=CONST_animation_time;
        scalingAnimation.autoreverses=NO;
        scalingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        scalingAnimation.fromValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(CONST_enlarge_proportion, CONST_enlarge_proportion, 1.0)];
        scalingAnimation.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    }
    [view.layer addAnimation:scalingAnimation forKey:@"descaling"];
    view.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark HBGridViewDelegate

// 获取单元格的总数
- (NSInteger)gridNumberOfGridView:(HBGridView *)gridView
{
    return [_dataSource count];
}

// 获取gridview每行显示的grid数
- (NSInteger)columnNumberOfGridView:(HBGridView *)gridView
{
    return 4;
}

// 获取单元格的行数
- (NSInteger)rowNumberOfGridView:(HBGridView *)gridView
{
    if ([_dataSource count] % [self columnNumberOfGridView:gridView])
    {
        return [_dataSource count] / [self columnNumberOfGridView:gridView] + 1;
    }
    else
    {
        return [_dataSource count] / [self columnNumberOfGridView:gridView];
    }
}

- (CGFloat)gridView:(HBGridView *)gridView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

// 获取特定位置的单元格视图
- (HBGridItemView *)gridView:(HBGridView *)gridView inGridCell:(HBGridCellView *)gridCell gridItemViewAtGridIndex:(GridIndex *)gridIndex listIndex:(NSInteger)listIndex
{
    NSLog(@"list index:%ld", listIndex);
    TextGridItemView *itemView = (TextGridItemView *)[gridView dequeueReusableGridItemAtGridIndex:gridIndex ofGridCellView:gridCell];
    if (!itemView)
    {
        itemView = [[TextGridItemView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    }
    itemView.backgroundColor = [UIColor redColor];
//    [itemView setText:[NSString stringWithFormat:@"%ld", [[_dataSource objectAtIndex:listIndex] integerValue]]];
    return itemView;
}

- (void)gridView:(HBGridView *)gridView didSelectGridItemAtIndex:(NSInteger)index
{
    HBGridItemView *itemView = [gridView gridItemViewAtIndex:index];
    itemView.backgroundColor = [UIColor redColor];
}

@end
