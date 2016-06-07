//
//  SureOrderViewController.h
//  JingCai
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//  确认订单页面

#import "BaseViewController.h"

@interface SureOrderViewController : BaseViewController

@property (nonatomic,copy)void(^successBlock)(NSMutableArray *array); //提交订单成功之后应该返回删除购物车的商品
//已经改成基类数组
//@property (nonatomic,strong)NSArray *array;

@end
