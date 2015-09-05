//
//  UIImage+Extra.h
//  
//
//  Created by shenjianguo on 10-8-3.
//  Copyright 2010 roosher. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (UIImageExtra)


+ (UIImage *)retina4ImageNamed:(NSString *)name;

+ (UIImage*)resizebleImageNamed:(NSString*)name;

+ (UIImage*)imageWithName:(NSString*)name size:(CGSize)size;

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;

+ (UIImage*)imageWithView:(UIView*)view;

+ (UIImage*)circleImageWithName:(NSString*)name;
+ (UIImage*)circelImageWithImage:(UIImage*)image;

+ (UIImage*)imageNamedNoCache:(NSString *)name;
@end
