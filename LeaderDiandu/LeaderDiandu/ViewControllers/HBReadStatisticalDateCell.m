//
//  HBReadStatisticalDateCell.m
//  LeaderDiandu
//
//  Created by 郑玉洋 on 15/10/18.
//  Copyright (c) 2015年 hxj. All rights reserved.
//

#import "HBReadStatisticalDateCell.h"
#import "FTMenu.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation HBReadStatisticalDateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    //左箭头
    self.leftButton = [[UIButton alloc] init];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"Statistics-btn-last"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton.frame = CGRectMake(10, (50 - 30)/2, 30, 30);
    [self addSubview:self.leftButton];
    
    //右箭头
    self.rightButton = [[UIButton alloc] init];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"Statistics-btn-next"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.frame = CGRectMake(150, (50 - 30)/2, 30, 30);
    [self addSubview:self.rightButton];
    
    //日期label
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.frame = CGRectMake(40, 0, 110, 50);
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.dateLabel];
    
    //本周button
    self.thisWeekButton = [[UIButton alloc] init];
    self.thisWeekButton.frame = CGRectMake(200, 0, 60, 50);
    [self.thisWeekButton setTitle:@"本周" forState:UIControlStateNormal];
//    self.thisWeekButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [self.thisWeekButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.thisWeekButton addTarget:self action:@selector(thisWeekButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.thisWeekButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self addSubview:self.thisWeekButton];
    
    //套餐按钮
    self.bookSetButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 8 - 44, (50 - 35)/2, 35, 35)];
    [self.bookSetButton setBackgroundImage:[UIImage imageNamed:@"bookshelf-btn-class"] forState:UIControlStateNormal];
    [self.bookSetButton addTarget:self action:@selector(bookSetButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.bookSetButton setTitle:@"1" forState:UIControlStateNormal];
    [self.bookSetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:self.bookSetButton];
    
    UILabel *seperatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    seperatorLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:seperatorLine];
}

-(void)leftButtonPressed
{
    [self.delegate leftButtonPressed];
}

-(void)rightButtonPressed
{
    [self.delegate rightButtonPressed];
}

-(void)thisWeekButtonPressed
{
    [self.delegate thisWeekButtonPressed];
}

-(void)bookSetButtonPressed
{
    [self showPullView];
}

-(void)showPullView
{
    NSMutableArray *menuItems = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (NSInteger index = 1; index <= 9; index++) {
        NSString * bookIdStr = [NSString stringWithFormat:@"%ld", index];
        KxMenuItem *item = [KxMenuItem
                            menuItem:bookIdStr
                            image:nil
                            target:self
                            action:@selector(pushMenuItem:)];
        [menuItems addObject:item];
    }
    
    CGRect menuFrame = CGRectMake(ScreenWidth - 75, 165, 60, 50 * 9);
    
    [FTMenu showMenuWithFrame:menuFrame inView:self.superview menuItems:menuItems currentID:0];
}

- (void) pushMenuItem:(KxMenuItem *)sender
{
    [self.bookSetButton setTitle:sender.title forState:UIControlStateNormal];
    [self.delegate pushMenuItem:[sender.title integerValue]];
}


@end
