//
//  NSObject+Height.h
//  Gone
//
//  Created by Happy on 16/1/30.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Height)
/**
 *  根据字符串、font、和 with 计算高度
 *
 *  @param str  NSString
 *  @param font UIFont 类型
 *  @param with 传入宽度
 *
 *  @return 返回高度
 */

+ (CGFloat)heightWithStr:(NSString *)str font:(UIFont *)font with:(CGFloat)with;

/**
 *  根据字符串、with 计算高度
 *
 *  @param str  NSSAttributedString 类型
 *  @param with 传入宽度
 *
 *  @return 返回高度
 */
+ (CGFloat)heightWithAttributedStr:(NSAttributedString *)str  with:(CGFloat)with;

/**
 *  获取lable的高度
 *
 *  @param label <#label description#>
 *
 *  @return <#return value description#>
 */
+ (CGFloat)heightOfStringWithLabel:(UILabel *)label;


/**
 *  label size
 *
 *  @param label <#label description#>
 *
 *  @return <#return value description#>
 */
+ (CGSize)sizeOfStringWithLabel:(UILabel *)label;

@end

