//
//  PayModel.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PayModel.h"
#import "AlipayMethod.h"
#import "WeiXinHelper.h"
#import "ChooseActionSheet.h"
#import <OpenShare/OpenShare.h>
@interface PayModel()
@property(nonatomic,strong)AlipayMethod *alipay;
@property(nonatomic,copy)void (^payBlock)(BOOL isSccuess,NSString *money,NSString*message);
@end
@implementation PayModel
+(instancetype)sharePayModelWithMoney:(NSString *)money toPayModelType:(PayModelType)type block:(void(^)(BOOL isSccuess,NSString *money,NSString*message))block{
    PayModel *model = [[PayModel alloc]init];
       model.payBlock = block;
    if(type == PayModelTypeAlipay)
    [model aliPay:money];
    else{
    [model weChatPay:money];
    }
    return model;
}


#pragma mark ------ 微信支付 ------
-(void)weChatPay:(NSString *)str{
    [[RequestClient sharedClient]user_weChat_addmoney:str extern_token:@"" progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        
        [self recharge_weiPay:respone.data Money:str];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        self.payBlock(NO,str,respone.msg);
    }];
}
-(void)recharge_weiPay:(NSDictionary *)info Money:(NSString *)str
{
    
    [WeiXinHelper weiPay:info];
    [OpenShare setPaySuccessCallback:^(NSDictionary *message) {
        DLog(@"微信回调%@",message);
        if(self.payBlock)
            self.payBlock(YES,str,@"充值成功");
    }];
    [OpenShare setPayFailCallback:^(NSDictionary *message, NSError *error) {
        
         DLog(@"微信回调%@",message);
        if(self.payBlock)
            self.payBlock(NO,str,@"支付失败");
    }];
}


//支付宝支付
-(void)aliPay:(NSString *)str{
    
    [[RequestClient sharedClient]user_alipay_addBooking:str extern_token:@"" progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        
        [self recharge_alipay:respone.data Money:str];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        self.payBlock(NO,str,respone.msg);
    }];
    
}
#pragma mark ------ 支付宝支付 ------
-(void)recharge_alipay:(NSString *)info Money:(NSString *)money {
    
    self.alipay = [[AlipayMethod alloc]init];
    [self.alipay payForSign:info];
    WEAKSELF;
    STRONGSELF;
    self.alipay.backBlock = ^(NSDictionary *resultDic) {
        
        if ([resultDic[@"resultStatus"] integerValue]==9000) {
            
            if(strongSelf.payBlock)
            strongSelf.payBlock(YES,money,@"充值成功");
            
        } else if ( [resultDic[@"resultStatus"] integerValue] ==6001 ){
            
             if(strongSelf.payBlock)
             strongSelf.payBlock(NO,money,@"支付失败");
      
        }
    };
    
}

//选择微信支付或是支付宝支付
+(void)openWeChat_alipayBlock:(chooseActionSheetCallBackBlock )bolck{
 
    ChooseActionSheet *sheet = [[ChooseActionSheet alloc]init];
    [sheet showChooseActionSheetBlock:bolck cancelButtonTitle:@"取消" array:@[@"微信支付",@"支付宝支付"]];

}


@end
