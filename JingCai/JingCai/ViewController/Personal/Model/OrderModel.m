//
//  OrderModel.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OrderModel.h"
#import "PayModel.h"
@implementation OrderModel
-(OrderType)type{
    return [self.status integerValue];
}



//判断余额是不是有够钱。有就有余额，没有就支付宝
+(void)payBookId:(NSString *)bookId money:(NSString *)money toPayModelType:(PayModelType)type toYu:(BOOL)isYu success:(successBlock)success
         failure:(failureBlock)failure{
    
    //有钱够，那就直接支付
    if(SINGLE.moneyModel.useMoney >= [money floatValue] && isYu){
        [self mitsubBookID:bookId isAliPay:NO money:money success:success failure:failure] ;
        return;
        
    }
    
    CGFloat balance = [money floatValue] - (isYu ? SINGLE.moneyModel.useMoney : 0.0); //余额
    
       
       //支付宝充值到余额在支付
       [PayModel sharePayModelWithMoney:[NSString stringWithFormat:@"%.2f",balance] toPayModelType:type block:^(BOOL isSccuess, NSString *money, NSString *message) {
           if(isSccuess){
               
               SINGLE.moneyModel.useMoney += balance;
               [self mitsubBookID:bookId isAliPay:YES money:money  success:success failure:failure];
               
           }else{
               
               [UIView show_fail_progress:message];
           }
       }];
       

    
    
}


static char const kvalicode = '\0';

+(void)setValicode:(NSString *)valicode{
    objc_setAssociatedObject(self, &kvalicode, valicode, OBJC_ASSOCIATION_COPY);
}
+(NSString *)getValicode{
    return objc_getAssociatedObject(self, &kvalicode);
}
+(void)mitsubBookID:(NSString *)bookId isAliPay:(BOOL)aliPay money:(NSString *)money  success:(successBlock)success
            failure:(failureBlock)failure{
    
    
    [[RequestClient sharedClient]order_Pay_bookId:bookId toValicode:[self getValicode] progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        
        if(aliPay)
            SINGLE.moneyModel.useMoney = 0.0f;
        
        success(task,responseObject,respone);
       
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        
         failure(task,error,respone);
        if(aliPay){
            
            [[[UIAlertView alloc] initWithTitle:@"订单交易失败" message:@"金额已经放入账号余额，可去查看" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            
        }else{
            [UIView show_fail_progress:respone.msg];
        }
        
    }];
    
}


//判断余额是不是有够钱。有就有余额，没有就支付宝
+(void)payRoleMoney:(NSString *)money toPayModelType:(PayModelType)type roleType:(roleType)_roleType  toYu:(BOOL)isYu success:(successBlock)success
            failure:(failureBlock)failure{
    
    //有钱够，那就直接支付
    if(SINGLE.moneyModel.useMoney >= [money floatValue] && isYu){
        [self pay:_roleType toAlipay:NO success:success failure:failure] ;
        return;
        
    }
    
    CGFloat balance = [money floatValue] - (isYu ? SINGLE.moneyModel.useMoney : 0.0); //余额
    
    
    //支付宝充值到余额在支付
    [PayModel sharePayModelWithMoney:[NSString stringWithFormat:@"%.2f",balance] toPayModelType:type block:^(BOOL isSccuess, NSString *money, NSString *message) {
        if(isSccuess){
            
            SINGLE.moneyModel.useMoney += balance;
             [self pay:_roleType toAlipay:YES success:success failure:failure] ;
            
        }else{
            
            [UIView show_fail_progress:message];
        }
    }];
    
    
    
}
+(void)pay:(roleType)type toAlipay:(BOOL)isAlipay success:(successBlock)success
   failure:(failureBlock)failure{
    
    [[RequestClient sharedClient]user_spokesman:type progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        if(isAlipay)
            SINGLE.moneyModel.useMoney = 0.0f;
        
        if(type == roleTypeAgent){
            [LoginModel shareLogin].roleId = roleTypeAgent;
        }else{
            [LoginModel shareLogin].roleId = roleTypeSpokesman;
        }
        [[Common shareAppDelegate]login];
     
        
        [UIView show_success_progress:respone.msg];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        
        [UIView show_fail_progress:respone.msg];
    }];
}


@end

@implementation DetailListModel



@end