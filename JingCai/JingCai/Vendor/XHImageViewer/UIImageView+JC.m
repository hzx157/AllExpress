//
//  UIImageView+JC.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIImageView+JC.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIView+WebCacheOperation.h>

void GOCGContextAddRoundedRect(CGContextRef c, CGRect rect, CGFloat radius)
{
    int minX = rect.origin.x  ,
    maxX = minX + rect.size.width,
    midX = minX + rect.size.width / 2,
    
    minY = rect.origin.y ,
    maxY = minY + rect.size.height,
    midY = minY + rect.size.height / 2;
    
    CGContextMoveToPoint(c, minX, midY);
    CGContextAddArcToPoint(c, minX, minY, midX, minY, radius);
    CGContextAddArcToPoint(c, maxX, minY, maxX, midY, radius);
    CGContextAddArcToPoint(c, maxX, maxY, midX, maxY, radius);
    CGContextAddArcToPoint(c, minX, maxY, minX, midY, radius);
    CGContextClosePath(c);
}

@implementation UIImageView (JC)

- (void)jc_setWebImageWithURLString:(NSString *)url
{
    NSURL *u;
    if((NSNull *)url != [NSNull null] && url.length > 0)
    {
        u = [NSURL URLWithString:url];
    }
    UIImage *holderImage = [UIImage jc_placeHolderImageForSize:self.bounds.size];
    [self sd_setImageWithURL:u placeholderImage:holderImage];
}

- (void)jc_setWebImageWithURLString:(NSString *)url holderSize:(CGSize)size;
{
    NSURL *u;
    if((NSNull *)url != [NSNull null] && url.length > 0)
    {
        u = [NSURL URLWithString:url];
    }
    UIImage *holderImage = [UIImage jc_placeHolderImageForSize:size];
    [self sd_setImageWithURL:u placeholderImage:holderImage];
}





@end


@implementation UIImage (GO)

+ (UIImage *)jc_imageWithColor:(UIColor *)color size:(CGSize)size
{
    if(CGSizeEqualToSize(size, CGSizeZero)) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context,  (CGRect){CGPointZero, size});
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)jc_imageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius
{
    if(CGSizeEqualToSize(size, CGSizeZero)) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    GOCGContextAddRoundedRect(context,  (CGRect){CGPointZero, size} , radius);
    CGContextClip(context);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context,  (CGRect){CGPointZero, size});
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)jc_fixOrientationImage
{
    // No-op if the orientation is already correct.
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context.
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

- (UIImage *)jc_roundImageWithSize:(CGSize)size radius:(CGFloat)radius
{
    @autoreleasepool
    {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat scale = [UIScreen mainScreen].scale;
        
        size_t width  = size.width * scale;
        size_t height = size.height * scale;
        
        CGSize is = self.size;
        if(is.width > is.height)
        {
            is.width = size.height * is.width / is.height;
            is.height = size.height;
        }
        else
        {
            is.height = size.width * is.height / is.width;
            is.width = size.width;
        }
        CGRect rect;
        rect.size = is;
        rect.origin.x = (size.width - is.width) / 2.0;
        rect.origin.y = (size.height - is.height) / 2.0;
        
        CGContextRef ctx = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 8,
                                                 width * 4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
        CGColorSpaceRelease(colorSpace);
        //缩放
        CGContextScaleCTM(ctx, scale, scale);
        GOCGContextAddRoundedRect(ctx,  (CGRect){CGPointZero, size} , radius);
        CGContextClosePath(ctx);
        CGContextClip(ctx);
        CGContextDrawImage(ctx, rect, self.CGImage);
        CGImageRef img = CGBitmapContextCreateImage(ctx);
        UIImage *image = [UIImage imageWithCGImage:img scale:scale orientation:UIImageOrientationUp];
        
        CGImageRelease(img);
        CGContextRelease(ctx);
        
        return image;
    }
}

+ (UIImage *)jc_roundPlaceHolderImageForSize:(CGSize)size
{
    NSString *url = [NSString stringWithFormat:@"http://baidu.com/placeholder.png?width=%lu&height=%lu",(unsigned long)size.width,(unsigned long)size.height];
    
    SDImageCache *cache = [SDImageCache sharedImageCache];
    UIImage *image = [cache imageFromMemoryCacheForKey:url];
    if(image) return image;
    
    @autoreleasepool
    {
        NSString *pkey;
        
        CGFloat w = size.width * 0.3;
        if(w <= 100)
        {
            pkey = @"avtor_icon";
        }
        else if(w > 100 && w <= 200)
        {
            pkey = @"avtor_icon";
        }
        else
        {
            pkey = @"avtor_icon";
        }
        UIImage *gImage = [UIImage imageNamed:pkey];
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat scale = [UIScreen mainScreen].scale;
        
        size_t width  = size.width * scale;
        size_t height = size.height * scale;
        
        CGContextRef ctx = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 8,
                                                 width * 4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
        CGColorSpaceRelease(colorSpace);
        //缩放
        CGContextScaleCTM(ctx, scale, scale);
        GOCGContextAddRoundedRect(ctx,  (CGRect){CGPointZero, size} , size.width/2.0);
        CGContextClosePath(ctx);
        CGContextClip(ctx);
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithHex:0xdcdcdc].CGColor);
        CGContextFillRect(ctx, CGRectMake(0, 0, width, height));
        CGContextDrawImage(ctx, CGRectInset(CGRectMake(0, 0, size.width, size.height), (size.width - w)/2.0, (size.height - w)/2.0), gImage.CGImage);;
        
        CGImageRef img = CGBitmapContextCreateImage(ctx);
        image = [UIImage imageWithCGImage:img scale:scale orientation:UIImageOrientationUp];
        
        CGImageRelease(img);
        CGContextRelease(ctx);
        
        [cache storeImage:image forKey:url toDisk:NO];
        
        return image;
    }
}

+ (UIImage *)jc_placeHolderImageForSize:(CGSize)size
{
    if(CGSizeEqualToSize(size,CGSizeZero))
    {
        return nil;
    }
    static NSCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSCache alloc] init];
    });
    
    NSString *key = NSStringFromCGSize(size);
    UIImage *image = [cache objectForKey:key];
    if(!image)
    {
        CGRect rect = (CGRect){CGPointZero,size};
        
        NSString *pkey;
        
        CGFloat w = size.width * 0.3;
        if(w <= 100)
        {
            pkey = @"avtor_icon";
        }
        else if(w > 100 && w <= 200)
        {
            pkey = @"avtor_icon";
        }
        else
        {
            pkey = @"avtor_icon";
        }
        UIImage *gImage = [cache objectForKey:pkey];
        if(!gImage)
        {
            gImage = [UIImage imageNamed:pkey];
            [cache setObject:pkey forKey:gImage];
        }
        
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor colorWithHex:0xdcdcdc].CGColor);
        CGContextFillRect(context,  (CGRect){CGPointZero, size});
        
        [gImage drawInRect:CGRectInset(rect, (CGRectGetWidth(rect)-w)/2.0, (CGRectGetHeight(rect)-w)/2.0)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if(image)
        {
            [cache setObject:image forKey:key];
        }
    }
    
    return image;
}

@end

