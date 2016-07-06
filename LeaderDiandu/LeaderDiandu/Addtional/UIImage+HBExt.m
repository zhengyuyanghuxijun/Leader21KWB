//
//  UIImage+HBExt.m
//  LediKWB
//
//  Created by ChunGuo on 15/12/11.
//  Copyright © 2016年 huxijun. All rights reserved.
//

#import "UIImage+HBExt.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark - CIFilter
@implementation UIImage (CIFilter)

+ (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    @autoreleasepool {
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
        
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        [filter setValue:@(blur) forKey:@"inputRadius"];
        
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGImageRef outImage = [context createCGImage:result fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        UIImage *blurImage = [UIImage imageWithCGImage:outImage];
        CGImageRelease(outImage);
        
        return blurImage;
    }
}

+ (UIImage *)generateQRCode:(NSString *)str
{
    @autoreleasepool {
        
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [filter setDefaults];
        
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [filter setValue:data forKey:@"inputMessage"];
        
        CIImage *outputImage = [filter outputImage];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
        
        UIImage *image = [UIImage imageWithCGImage:cgImage
                                             scale:1.0
                                       orientation:UIImageOrientationUp];
        
        CGImageRelease(cgImage);
        
        //Resize without interpolating
        CGFloat width = image.size.width * 5.0;
        CGFloat height = image.size.height * 5.0;
        
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        CGContextRef cgcontext = UIGraphicsGetCurrentContext();
        CGContextSetInterpolationQuality(cgcontext, kCGInterpolationNone);
        [image drawInRect:CGRectMake(0, 0, width, height)];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return resizedImage;
    }
}

@end



#pragma mark - 根据color获得纯色image
@implementation UIImage (UIColor)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end



#pragma mark - //对当前控件进行截图
@implementation UIView (Snapshot)

- (UIImage *)snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

@end



#pragma mark - //压缩图片
@implementation UIImage (ScaledToSize)

- (UIImage *)scaledToSize:(CGSize)newSize
{
    if (self.size.width <= newSize.width && self.size.height <= newSize.height) {
        return self;
    }
    CGSize thumbSize;
    if (self.size.width / self.size.height > newSize.width / newSize.height) {
        thumbSize.width = newSize.width;
        thumbSize.height = newSize.width / self.size.width * self.size.height;
    }
    else {
        thumbSize.height = newSize.height;
        thumbSize.width = newSize.height / self.size.height * self.size.width;
    }
    
    UIGraphicsBeginImageContext(thumbSize);
    [self drawInRect:CGRectMake(0, 0, thumbSize.width, thumbSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end



#pragma mark - //根据url获得image
@implementation UIImage (UrlString)

+ (UIImage *)imageWithUrl:(NSString *)url
{
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
}

@end


@implementation UIImage (UIImageExtra)

+ (UIImage *)retina4ImageNamed:(NSString *)name;
{
    if (isIPhone5) {
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
