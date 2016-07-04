//
//  EColumnChart.m
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import "EColumnChart.h"
#import "EColor.h"
#import "EColumnChartLabel.h"
//#import "EFloatBox.h"
#define BOTTOM_LINE_HEIGHT 2
#define HORIZONTAL_LINE_HEIGHT 0.5
#define Y_COORDINATE_LABEL_WIDTH 30

@interface EColumnChart()

@property (strong, nonatomic) NSMutableDictionary *eColumns;
@property (strong, nonatomic) NSMutableDictionary *eLabels;

@end

@implementation EColumnChart
@synthesize eColumns = _eColumns;
@synthesize eLabels = _eLabels;
@synthesize dataSource = _dataSource;

- (void)setDataSource:(id<EColumnChartDataSource>)dataSource
{
    if (_dataSource != dataSource)
    {
        _dataSource = dataSource;

        NSInteger highestValueEColumnChart = 100;
        for (int i = 0; i < 5; i++)
        {
            NSInteger heightGap = self.frame.size.height / 4;
            NSInteger valueGap = highestValueEColumnChart / 4;
            UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, heightGap * i, self.frame.size.width, HORIZONTAL_LINE_HEIGHT)];
            horizontalLine.backgroundColor = ELightGrey;
            [self addSubview:horizontalLine];
            
            EColumnChartLabel *eColumnChartLabel = [[EColumnChartLabel alloc] initWithFrame:CGRectMake(-1 * Y_COORDINATE_LABEL_WIDTH, -heightGap / 2.0 + heightGap * i, Y_COORDINATE_LABEL_WIDTH, heightGap)];
            [eColumnChartLabel setTextAlignment:NSTextAlignmentCenter];
            eColumnChartLabel.text = [NSString stringWithFormat:@"%ld", valueGap * (4 - i)];
            
            [self addSubview:eColumnChartLabel];
        }
        
        [self reloadData];
    }
}

- (void)reloadData
{
    if (nil == _dataSource)
    {
        NSLog(@"Important!! DataSource Not Set!");
        return;
    }
    
    NSInteger totalColumnsRequired = [_dataSource numberOfColumnsPresentedEveryTime:self];
    float highestValueEColumnChart = 1.0;//[_dataSource highestValueEColumnChart:self].value * 1.0;
    //modify by hxj
    NSInteger columNum = 4;//totalColumnsRequired
    float widthOfTheColumnShouldBe = self.frame.size.width / (float)(columNum + (columNum + 1) * 0.5);
    
    for (int i = 0; i < totalColumnsRequired; i++)
    {
        NSInteger currentIndex = i;
        EColumnDataModel *eColumnDataModel = [_dataSource eColumnChart:self valueForIndex:currentIndex];
        if (eColumnDataModel == nil)
            eColumnDataModel = [[EColumnDataModel alloc] init];
        
        /** Construct Columns*/
        EColumn *eColumn = [_eColumns objectForKey: [NSNumber numberWithInteger:currentIndex ]];
        if (nil == eColumn)
        {
            eColumn = [[EColumn alloc] initWithFrame:CGRectMake(widthOfTheColumnShouldBe * 0.5 + (i * widthOfTheColumnShouldBe * 1.5), 0, widthOfTheColumnShouldBe, self.frame.size.height)];
            eColumn.barColor = [UIColor purpleColor];
            eColumn.backgroundColor = [UIColor clearColor];
            if (0 == highestValueEColumnChart) {
                eColumn.grade = 0;
            }else{
                eColumn.grade = eColumnDataModel.value / highestValueEColumnChart;
            }
            eColumn.eColumnDataModel = eColumnDataModel;
            [self addSubview:eColumn];
            [_eColumns setObject:eColumn forKey:[NSNumber numberWithInteger:currentIndex]];
        }
        if (0 == i) {
            eColumn.barColor = [UIColor purpleColor];
        }else if (1 == i){
            eColumn.barColor = [UIColor orangeColor];
        }else if (2 == i){
            eColumn.barColor = [UIColor yellowColor];
        }else if (3 == i){
            eColumn.barColor = [UIColor greenColor];
        }else if (4 == i){
            eColumn.barColor = [UIColor blueColor];
        }
        
        
        /** Construct labels for corresponding columns */
        EColumnChartLabel *eColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:(currentIndex)]];
        if (nil == eColumnChartLabel)
        {
            eColumnChartLabel = [[EColumnChartLabel alloc] initWithFrame:CGRectMake(widthOfTheColumnShouldBe * 0.5 + (i * widthOfTheColumnShouldBe * 1.5), self.frame.size.height, widthOfTheColumnShouldBe, 20)];
            [eColumnChartLabel setTextAlignment:NSTextAlignmentCenter];
            eColumnChartLabel.text = eColumnDataModel.label;
            [self addSubview:eColumnChartLabel];
            [_eLabels setObject:eColumnChartLabel forKey:[NSNumber numberWithInteger:(currentIndex)]];
        }
    }

//    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^
//     {
         UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, 0, BOTTOM_LINE_HEIGHT)];
         bottomLine.backgroundColor = [UIColor blackColor];
         bottomLine.layer.cornerRadius = 2.0;
         [self addSubview:bottomLine];
         [bottomLine setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, BOTTOM_LINE_HEIGHT)];
         
//     } completion:nil];

}

#pragma -mark- Custom Methed
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        /** Should i release these two objects before self have been destroyed*/
        _eLabels = [NSMutableDictionary dictionary];
        _eColumns = [NSMutableDictionary dictionary];
    }
    return self;
}

@end
