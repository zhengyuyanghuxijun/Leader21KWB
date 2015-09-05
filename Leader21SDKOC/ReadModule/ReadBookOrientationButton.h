//
//  ReadBookOrientationButton.h
//  magicEnglish
//
//  Created by 振超 王 on 14-4-17.
//  Copyright (c) 2014年 ilovedev.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OrientationType){
    ORI_LANDSCAPE = 0,
    ORI_PORTRAIT,
    FNC_EXIT
};

@interface ReadBookOrientationButton : UIButton

- (id)initOriButton;

@property (nonatomic, assign) OrientationType oriType;

@end
