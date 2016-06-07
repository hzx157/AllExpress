//
//  UIImage+ScreenAdapter.m
//  SinaWeibo
//
//  Created by zouyb on 13-10-20.
//  Copyright (c) 2013年 zouyb. All rights reserved.
//

#import "UIImage+ScreenAdapter.h"


@implementation UIImage (ScreenAdapter)

+ (UIImage *)stretchImageWithName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    CGSize imageSize = image.size;
    image = [image stretchableImageWithLeftCapWidth:imageSize.width * 0.5f topCapHeight:imageSize.height * 0.5f];
    return image;
}

@end
