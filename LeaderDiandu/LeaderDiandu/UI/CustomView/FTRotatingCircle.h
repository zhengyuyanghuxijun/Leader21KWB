//
//  FTRotatingCircle.h
//  Fetion
//
//  Created by apple on 14-3-21.
//  Copyright (c) 2014年 chinasofti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTRotatingCircle : UIView

- (id)initWithFrame:(CGRect)frame imageName:(NSString *)imageName;

-(void)setRotatingImageFrame:(CGRect)frame imageName:(NSString *)imageName;
//@property(nonatomic, assign)CGRect frame;

@end
