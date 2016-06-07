//
//  ChooseAddressViewController.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressModel.h"
@interface ChooseAddressViewController : BaseViewController

@property (nonatomic,copy)void (^block)(AddressModel *model); //回调


/**
 *  获取默认地址
 *
 *  @param block  model 不等于nil 代表有值
 */
+(void)getDefaultAddress:(void(^)(AddressModel *model))block;


@end
