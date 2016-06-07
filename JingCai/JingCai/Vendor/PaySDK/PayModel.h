//
//  PayModel.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/25.
//  Copyright © 2016年 apple. All rights reserved.
//


typedef NS_ENUM(NSInteger,PayModelType) {
    PayModelTypeWeChat = 0,
    PayModelTypeAlipay
 
    
};

#import <Foundation/Foundation.h>
#import "ChooseActionSheet.h"
@interface PayModel : NSObject


//选择微信支付或是支付宝支付
+(void)openWeChat_alipayBlock:(chooseActionSheetCallBackBlock )bolck;
+(instancetype)sharePayModelWithMoney:(NSString *)money toPayModelType:(PayModelType)type block:(void(^)(BOOL isSccuess,NSString *money,NSString*message))block;
@end
