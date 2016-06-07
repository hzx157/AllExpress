//
//  UIImage+Capture.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Capture)

+ (UIImage *)captureWithView:(UIView *)view;

///截图（未测试是否可行）
+ (UIImage *)getImageWithSize:(CGRect)myImageRect FromImage:(UIImage *)bigImage;


/**
 *  生成二维码
 *
 *  @param qrStr 生成字符串
 *
 *  @return 二维码图片
 */

+ (UIImage *)createRRcode:(NSString *)qrStr;
/**
 *  改变二维码大小
 *
 *  @param image CIImage
 *  @param size  size
 *
 *  @return 放大后的图片
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;
@end
