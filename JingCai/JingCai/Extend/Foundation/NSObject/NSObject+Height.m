//
//  NSObject+Height.m
//  Gone
//
//  Created by Happy on 16/1/30.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//

#import "NSObject+Height.h"


@implementation NSObject (Height)
/**
 *  根据字符串、font、和 with 计算高度
 *
 *  @param str  NSString
 *  @param font UIFont 类型
 *  @param with 传入宽度
 *
 *  @return 返回高度
 */

+ (CGFloat)heightWithStr:(NSString *)str font:(UIFont *)font with:(CGFloat)with {
    
    CGSize size = CGSizeMake(with, MAXFLOAT);
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize contentSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    return contentSize.height + 2;
}


/**
 *  根据字符串、font、和 with 计算高度
 *
 *  @param str  NSSAttributedString 类型
 *  @param font UIFont 类型
 *  @param with 传入宽度
 *
 *  @return 返回高度
 */
+ (CGFloat)heightWithAttributedStr:(NSAttributedString *)str with:(CGFloat)with {
    CGSize size = CGSizeMake(with, MAXFLOAT);
    CGSize contentSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
    
    return contentSize.height + 2;

    
}
/**
 *  获取lable的高度
 *
 *  @param label <#label description#>
 *
 *  @return <#return value description#>
 */
+ (CGFloat)heightOfStringWithLabel:(UILabel *)label {
    
    CGSize size = CGSizeMake(label.width, MAXFLOAT);
    NSDictionary *dict = @{NSFontAttributeName:label.font};
    CGSize contentSize = [label.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    return contentSize.height;
}

+ (CGSize)sizeOfStringWithLabel:(UILabel *)label {
    
    CGSize size = CGSizeMake(label.width, MAXFLOAT);
    NSDictionary *dict = @{NSFontAttributeName:label.font};
    CGSize contentSize = [label.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    return contentSize;
}

@end
