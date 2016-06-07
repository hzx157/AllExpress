//
//  DrawalViewController.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "MoneyModel.h"

@interface DrawalViewController : BaseViewController
@property (nonatomic,copy)void  (^block)(NSString *mony);
@end
