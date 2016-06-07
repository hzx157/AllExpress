//
//  UIImageView+JC.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (JC)
- (void)jc_setWebImageWithURLString:(NSString *)url;

- (void)jc_setWebImageWithURLString:(NSString *)url holderSize:(CGSize)size;


@end


@interface UIImage (GO)

/**
 *  通过颜色和尺寸生成图片
 *
 *  @param color 颜色
 *  @param size  尺寸
 *
 *  @return 图片对象
 */
+ (UIImage *)jc_imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)jc_placeHolderImageForSize:(CGSize)size;

+ (UIImage *)jc_roundPlaceHolderImageForSize:(CGSize)size;

- (UIImage *)jc_roundImageWithSize:(CGSize)size radius:(CGFloat)radius;

- (UIImage *)jc_fixOrientationImage;

+ (UIImage *)jc_imageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius;


@end