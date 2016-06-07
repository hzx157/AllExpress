//
//  OrderDetailViewController.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderDetailViewController : BaseViewController
@property (nonatomic,copy) void (^block)(id obj);
@property (nonatomic, assign)NSInteger sid;
@end
