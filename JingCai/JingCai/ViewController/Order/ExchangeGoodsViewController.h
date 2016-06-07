//
//  ExchangeGoodsViewController.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"

#import "OrderModel.h"
@interface ExchangeGoodsViewController : BaseViewController

@property (nonatomic,weak)OrderModel *model;
@property (nonatomic,weak)DetailListModel *listModel;
@property (nonatomic,copy)void (^block)(NSString *text);
@end
