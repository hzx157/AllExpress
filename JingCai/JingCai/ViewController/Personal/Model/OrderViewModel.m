//
//  OrderViewModel.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OrderViewModel.h"
#import "OrderSelectView.h"
#import "OrderModel.h"
#import "JCPayViewController.h"
@implementation OrderViewModel

/**
订单状态status * 02：未付款 * 06：等待发货 * 08：待收货 * 11：退款申请 * 13：同意退款(不退货，完成订单) * 05：确认收货（完成订单） 交易成功 不允许退换货 * 07：换货申请 * 08：同意换货 * 10：关闭订单（尚未付款的订单关闭）
 * )
 */
+(void)updateStausWithPayBtn:(UIButton *)_payBtn toCancel:(UIButton *)_cancelBtn toStaus:(UILabel *)stausLabel type:(OrderType)type{
    
    _payBtn.backgroundColor = kselectColor;
    _payBtn.enabled = YES;
    _cancelBtn.hidden = YES;
    _cancelBtn.enabled = YES;
    _payBtn.alpha = 0.8;
    
    void (^payEnableblock)() =^(){
        _payBtn.alpha = 0.4;
        _payBtn.enabled = NO;
    };
    
    switch (type) {
        case OrderTypeWaitPay:  //
        {
            [_payBtn setTitle:@"付款" forState:UIControlStateNormal];
            _cancelBtn.hidden = NO;
            [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            stausLabel.text = @"等待付款";
        }
            break;
        case OrderTypeWaitSend:  ///
        {
            [_payBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            _cancelBtn.hidden = NO;
            [_cancelBtn setTitle:@"已付款" forState:UIControlStateNormal];
            _cancelBtn.enabled = NO;
             stausLabel.text = @"等待发货";
        }
            break;
        case OrderTypeWaitRecive:  ///
        {
            [_payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            _cancelBtn.hidden = NO;
            [_cancelBtn setTitle:@"查看物流" forState:UIControlStateNormal];
             stausLabel.text = @"等待收货";
        }
            break;
        case OrderTypeOrderSuccess:  ///
        {
            [_payBtn setTitle:@"已完成" forState:UIControlStateNormal];
            _payBtn.enabled = NO;
             stausLabel.text = @"订单完成";
            
        }
            break;
      
        case OrderTypeWaitFail:  ///
        case OrderTypeClose:  ///
        {
            [_payBtn setTitle:@"订单关闭" forState:UIControlStateNormal];
            payEnableblock();
             stausLabel.text = @"订单关闭";
            
            
        }
            break;
        case OrderTypeApplyReturnGoods:{
            [_payBtn setTitle:@"等待换货" forState:UIControlStateNormal];
            payEnableblock();
            stausLabel.text = @"等待同意换货";
        }
            break;
        case OrderTypeApplyGoods:{
            [_payBtn setTitle:@"等待退款" forState:UIControlStateNormal];
             payEnableblock();
              stausLabel.text = @"等待同意退款";
        }
            break;
        case OrderTypeAgreeReturn:{
            [_payBtn setTitle:@"退款成功" forState:UIControlStateNormal];
            payEnableblock();
            stausLabel.text = @"退款成功";
        }
            break;
        case OrderTypeAgreeGoods:{//同意换货
            [_payBtn setTitle:@"换货填写" forState:UIControlStateNormal];
            stausLabel.text = @"商家同意换货";
        }
            break;
        case OrderTypeRefusedGoods:{//拒绝换货
            [_payBtn setTitle:@"拒绝换货" forState:UIControlStateNormal];
             payEnableblock();
            stausLabel.text = @"商家拒绝换货";
        }
            break;
        case OrderTypeRefusedurn:{//拒绝退款
            [_payBtn setTitle:@"拒绝退款" forState:UIControlStateNormal];
            stausLabel.text = @"商家拒绝退款";
             payEnableblock();
        }
            break;
        default:
            break;
    }
}


//确定订单的操作
+(void)payRequestWithModel:(OrderModel *)model  toViewController:(UIViewController *)viewController success:(successBlock)success
                   failure:(failureBlock)failure{
    
 
    
    switch (model.type) {
        case OrderTypeWaitPay:  //
        {
            // [_payBtn setTitle:@"付款" forState:UIControlStateNormal];
            
            JCPayViewController *pay = [JCPayViewController new];
            pay.model = model;
            [viewController.navigationController pushViewController:pay animated:YES];
         
            
        }
            break;
        case OrderTypeWaitSend:  ///
        {
            //   [_payBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            [UIView show_loading_progress_HUDMaskType:@"申请退款中.."];
            [[RequestClient sharedClient]order_refund_bookId:[NSString stringWithFormat:@"%ld",model.bookingId] progress:^(NSProgress *uploadProgress) {
                ;
            } success:success failure:failure];
            
        }
            break;
        case OrderTypeWaitRecive:  ///
        {
            //[_payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [UIView show_loading_progress_HUDMaskType:@"完成中.."];
            [[RequestClient sharedClient]order_finish_bookId:[NSString stringWithFormat:@"%ld",(long)model.bookingId] progress:^(NSProgress *uploadProgress) {
                ;
            } success:success failure:failure];
            
        }
            break;
        case OrderTypeOrderSuccess:  ///
        {
            // [_payBtn setTitle:@"申请退货" forState:UIControlStateNormal];
//            [UIView show_loading_progress_HUDMaskType:@"申请退货中.."];
//            [[RequestClient sharedClient]order_exchange_expressId:@"" bookingId:[NSString stringWithFormat:@"%ld",model.bookingId] progress:^(NSProgress *uploadProgress) {
//                ;
//            } success:success failure:failure];
//            
        }
            break;
      
            
        default:
            break;
    }
}

//取消订单的操作，，删除订单等
+(void)cancelRequestWithModel:(OrderModel *)model  success:(successBlock)success
                      failure:(failureBlock)failure{
    
    switch (model.type) {
        case OrderTypeWaitPay:  //
        {
            
            // [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [UIView show_loading_progress_HUDMaskType:@"取消中.."];
            [[RequestClient sharedClient]order_closeOrder_bookId:[NSString stringWithFormat:@"%ld",model.bookingId] progress:^(NSProgress *uploadProgress) {
                ;
            } success:success failure:failure];
        }
            break;
        case OrderTypeWaitSend:  ///
        {
            
        }
            break;
        case OrderTypeWaitRecive:  ///
        {
            
            //  [_cancelBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        }
            break;
        case OrderTypeOrderSuccess:  ///
        {
            
            
        }
            break;
     
            
        default:
            break;
    }
}

@end
