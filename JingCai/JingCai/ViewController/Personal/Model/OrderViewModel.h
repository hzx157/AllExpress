//
//  OrderViewModel.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"
@interface OrderViewModel : NSObject

+(void)updateStausWithPayBtn:(UIButton *)_payBtn toCancel:(UIButton *)_cancelBtn toStaus:(UILabel *)stausLabel type:(OrderType)type;
//确定订单的操作

+(void)payRequestWithModel:(OrderModel *)model  toViewController:(UIViewController *)viewController success:(successBlock)success
                   failure:(failureBlock)failure;
//取消订单的操作，，删除订单等
+(void)cancelRequestWithModel:(OrderModel *)model  success:(successBlock)success
                      failure:(failureBlock)failure;
@end
