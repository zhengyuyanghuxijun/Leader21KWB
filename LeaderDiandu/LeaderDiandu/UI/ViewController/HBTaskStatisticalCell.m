//
//  HBTaskStatisticalCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/23.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBTaskStatisticalCell.h"
#import "EColumnDataModel.h"
#import "EColumnChartLabel.h"
//#import "EFloatBox.h"
#import "EColor.h"
#import "EColumnChart.h"
#import "HBExamKnowledgeEntity.h"
#import "HBExamAbilityEntity.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface HBTaskStatisticalCell ()<EColumnChartDataSource>

@property (nonatomic, strong) NSArray *data;
@property (strong, nonatomic) EColumnChart *eColumnChart;

@end

@implementation HBTaskStatisticalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (void) initUI
{
//    _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(40, 40, ScreenWidth - 40 - 10, 200)];
//    
//    [self addSubview:_eColumnChart];
}

-(void)updateFormData:(NSArray *)arr isKnowledge:(BOOL)knowledge
{
    if (_eColumnChart) {
        [_eColumnChart removeFromSuperview];
    }
    
    _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(40, 40, ScreenWidth - 40 - 10, 200)];
    
    [self addSubview:_eColumnChart];
    
    if (knowledge) {
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 0; i < arr.count; i++)
        {
            HBExamKnowledgeEntity *entity = arr[i];
            float value = (float)entity.correct/entity.total;
            EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:entity.tag value:value index:i];
            [temp addObject:eColumnDataModel];
        }
        _data = [NSArray arrayWithArray:temp];
    }else{
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 0; i < arr.count; i++)
        {
            HBExamAbilityEntity *entity = arr[i];
            float value = (float)entity.correct/entity.total;
            EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:entity.tag value:value index:i];
            [temp addObject:eColumnDataModel];
        }
        _data = [NSArray arrayWithArray:temp];
    }
    
    [_eColumnChart setDataSource:self];
}


#pragma -mark- EColumnChartDataSource

- (NSInteger)numberOfColumnsInEColumnChart:(EColumnChart *)eColumnChart
{
    return [_data count];
}

- (NSInteger)numberOfColumnsPresentedEveryTime:(EColumnChart *)eColumnChart
{
    return [_data count];
}

- (EColumnDataModel *)highestValueEColumnChart:(EColumnChart *)eColumnChart
{
    EColumnDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    for (EColumnDataModel *dataModel in _data)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
            maxDataModel = dataModel;
        }
    }
    
    return maxDataModel;
}

- (EColumnDataModel *)eColumnChart:(EColumnChart *)eColumnChart valueForIndex:(NSInteger)index
{
    if (index >= [_data count] || index < 0) return nil;
    return [_data objectAtIndex:index];
}
@end
