//
//  UIImage+HBExt.h
//  LediKWB
//
//  Created by ChunGuo on 15/12/11.
//  Copyright © 2016年 huxijun. All rights reserved.
//

@interface UIImage (CIFilter)

//滤镜高斯模糊
+ (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

//生成二维码
+ (UIImage *)generateQRCode:(NSString *)str;

@end



//根据color获得纯色image
@interface UIImage (UIColor)

/**
 *  @param color          颜色值
 *  @return UIImage       纯色图片size{1,1}
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end



//对当前控件进行截图
@interface UIView (Snapshot)

- (UIImage *)snapshot;

@end



//压缩图片
@interface UIImage (ScaledToSize)

- (UIImage *)scaledToSize:(CGSize)newSize;

@end



//根据url获得image
@interface UIImage (UrlString)

+ (UIImage *)imageWithUrl:(NSString *)url;

@end


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
