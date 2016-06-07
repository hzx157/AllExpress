//
//  JCPayViewController.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/6/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"
@interface JCPayViewController : BaseViewController
@property (nonatomic,strong)OrderModel *model;

@property (nonatomic,assign)CGFloat money;
@property (nonatomic,assign)roleType type;
@end
