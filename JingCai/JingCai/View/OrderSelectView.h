//
//  OrderSelectView.h
//  JingCai
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#define  kselectColor ColorWithRGB(219.0, 40.0, 59.0, 1.0)
#define  knormalColor [UIColor whiteColor]

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,OrderType) {
    
    OrderTypeAll = 1,
    OrderTypeWaitPay ,//等待付款2
    OrderTypeWaitFail,//失败 3
    OrderTypeApplyMoney,//提现申请4
    OrderTypeSuccess,//确认收货（完成订单） 交易成功 不允许退换货
    OrderTypeWaitSend,//等待发货6
    OrderTypeApplyReturnGoods,//换货申请
    OrderTypeWaitRecive,//等待收货 8
    OrderTypeApplyGoods,//退款申请
    OrderTypeClose,//订单关闭10
    OrderTypeAgreeReturn,//11:同意退款(不退货，完成订单)
    OrderTypeOrderSuccess,//确认收货（完成订单） 交易成功 不允许退换货
     OrderTypeAgreeGoods,//13:同意换货
    OrderTypeRefusedGoods,//14:拒绝换货
    OrderTypeRefusedurn,//15：拒绝退款
     OrderTypeAllBack = 99//退款集合
};

@interface OrderSelectView : UIView

@property (nonatomic, copy) void(^OrderSelectViewBlock)(OrderType index);

- (void)setSelectIndicateAtType:(OrderType)type;

@end
