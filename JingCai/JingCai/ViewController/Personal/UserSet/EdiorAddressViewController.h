//
//  EdiorAddressViewController.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressModel.h"
@interface EdiorAddressViewController : BaseViewController

@property (nonatomic,strong)AddressModel *model;
@property (nonatomic,copy)void (^block)(AddressModel *model);
@end
