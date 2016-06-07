//
//  AlipayMethod.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AlipayMethod.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation AlipayMethod
-(void)payForSign:(NSString *)sign
{
    NSString *appScheme = @"JingCai";
    [[AlipaySDK defaultService] payOrder:sign fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        if(self.backBlock)
        self.backBlock(resultDic);
    }];
}


@end
