//
//  ReadBookOrientationButton.m
//  magicEnglish
//
//  Created by 振超 王 on 14-4-17.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import "ReadBookOrientationButton.h"

@implementation ReadBookOrientationButton

- (id)initOriButton
{
    self = [super initWithFrame:CGRectMake(0, 0, 40, 35)];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"big_button3"] forState:UIControlStateNormal];
        [self setOriType:ORI_LANDSCAPE];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setOriType:(OrientationType)oriType
{
    _oriType = oriType;
    if (_oriType == ORI_LANDSCAPE) {
        [self setImage:[UIImage imageNamed:@"orientation_land"] forState:UIControlStateNormal];
    }
    else if(_oriType == ORI_PORTRAIT)
    {
        [self setImage:[UIImage imageNamed:@"orientation_port"] forState:UIControlStateNormal];
    }else
    {
        [self setImage:[UIImage imageNamed:@"fnc_exit"] forState:UIControlStateNormal];
    }
}

@end
