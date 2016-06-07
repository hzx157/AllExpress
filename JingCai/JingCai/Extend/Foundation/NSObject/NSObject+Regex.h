//
//  NSObject+Regex.h
//  Gone
//
//  Created by gmall on 16/3/8.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//  正则表达

#import <Foundation/Foundation.h>

@interface NSObject (Regex)

//是否是合法的网页链接
+ (BOOL)validateHttpUrlStr: (NSString *)urlStr;

@end
