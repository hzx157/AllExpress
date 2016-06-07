//
//  AlipayMethod.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void (^callBackBlock)(NSDictionary *callBackDic);

@interface AlipayMethod : NSObject

@property (weak, nonatomic) UITableView *productTableView;
@property(nonatomic, strong)NSMutableArray *productList;
@property(nonatomic,strong)callBackBlock backBlock;

/*
 @================== 支付 =================@
 @param product 订单信息
 */

-(void)payForSign:(NSString *)sign;

@end