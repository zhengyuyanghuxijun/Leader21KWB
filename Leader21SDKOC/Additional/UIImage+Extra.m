//
//  UIImage+Extra.m
//  
//
//  Created by shenjianguo on 10-8-3.
//  Copyright 2010 roosher. All rights reserved.
//

#import "UIImage+Extra.h"

@implementation UIImage (UIImageExtra)
+ (UIImage *)retina4ImageNamed:(NSString *)name;
{
    if ([[UIDevice currentDevice] isIphone5]) {
        NSMutableString *imageNameMutable = [name mutableCopy];
        NSRange retinaAtSymbol = [name rangeOfString:@"@"];
        if (retinaAtSymbol.location != NSNotFound) {
            [imageNameMutable insertString:@"-568h" atIndex:retinaAtSymbol.location];
        } else {
            NSRange dot = [name rangeOfString:@"."];
            if (dot.location != NSNotFound) {
                [imageNameMutable insertString:@"-568h" atIndex:dot.location];
            } else {
                [imageNameMutable appendString:@"-568h"];
            }
        }
        UIImage *result = [UIImage imageNamed:imageNameMutable];
        if (result) {
            return result;
        }
    }
    return [UIImage imageNamed:name];
}


+ (UIImage*)resizebleImageNamed:(NSString*)name
{
    UIImage* result = nil;
    UIImage* image = [UIImage imageNamed:name];
    if (image != nil) {
        CGSize s = image.size;
        UIEdgeInsets inset = UIEdgeInsetsMake(s.height/2.0f-1, s.width/2.0f-1, s.height/2.0+1, s.width/2.0+1);
        result = [image resizableImageWithCapInsets:inset];
    }
    
    return result;
}

+ (UIImage*)imageWithName:(NSString*)name size:(CGSize)size
{
    UIImage* result = nil;
    UIImage* image = [UIImage imageNamed:name];
    if (image != nil) {
        CGSize s = image.size;
        UIEdgeInsets inset = UIEdgeInsetsMake(s.height/2.0f-1, s.width/2.0f-1, s.height/2.0+1, s.width/2.0+1);
        result = [image resizableImageWithCapInsets:inset];
        CGRect rc = CGRectZero;
        rc.size = size;
        if (rc.size.width < 0.5f) {
            rc.size.width = s.width;
        }
        if (rc.size.height < 0.5f) {
            rc.size.height = s.height;
        }
        UIImageView* view = [[UIImageView alloc] initWithFrame:rc];
        view.image = result;
        
        result = [self imageWithView:view];
    }
    
    return result;
}

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size
{
    CGRect frame = CGRectZero;
    
    BOOL resizeable = NO;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(5.0f, 5.0f);
        resizeable = YES;
    }
    
    frame.size = size;
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (resizeable) {
        UIEdgeInsets inset = UIEdgeInsetsMake(size.height/2.0f-1, size.width/2.0f-1, size.height/2.0+1, size.width/2.0+1);
        UIImage* result = [image resizableImageWithCapInsets:inset];
        return result;
    }
    else {
        return image;
    }
}

+ (UIImage*)imageWithView:(UIView*)view
{
    CGSize s = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*)circleImageWithName:(NSString*)name
{
    UIImage* img = [UIImage imageNamed:name];
    return [UIImage circelImageWithImage:img];
}

+ (UIImage*)circelImageWithImage:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *imgNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgNew;
}

+ (UIImage*)imageNamedNoCache:(NSString *)name
{
    if (!name) {
        return nil;
    }
    BOOL bRetina = NO;
    NSString* finalName = [NSString stringWithString:name];
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES)
    {
        if ([[UIScreen mainScreen] scale] == 2.00) {
            bRetina = YES;
        }
    }
    if (bRetina) {
        finalName = [NSString stringWithFormat:@"%@@2x",name];
    }
    
    //retina 寻找文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:finalName ofType:@"png"];
    if (!filePath) {
        filePath = [[NSBundle mainBundle] pathForResource:finalName ofType:@"jpg"];
    }
    //如果没有 那寻找正常文件
    if (!filePath) {
        filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
        if (!filePath) {
            filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
        }
    }
    return [UIImage imageWithContentsOfFile:filePath];
}
@end
