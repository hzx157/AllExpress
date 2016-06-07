//
//  PaymentModel.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PaymentModel.h"

@implementation PaymentModel
+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName
{
    // nickName -> nick_name
    return [propertyName mj_underlineFromCamel];
}
@end
