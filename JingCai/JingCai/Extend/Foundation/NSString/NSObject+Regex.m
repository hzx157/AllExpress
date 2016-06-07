//
//  NSObject+Regex.m
//  Gone
//
//  Created by gmall on 16/3/8.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//

#import "NSObject+Regex.h"

@implementation NSObject (Regex)
+ (BOOL)validateHttpUrlStr: (NSString *)urlStr
{
    BOOL flag;
    if (urlStr.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:urlStr];
}
@end
