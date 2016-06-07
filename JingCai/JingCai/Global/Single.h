//
//  Single.h
//  JingCai
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 apple. All rights reserved.
//  单例

#import <Foundation/Foundation.h>
#import "MoneyModel.h"
typedef NS_ENUM(NSInteger, HzxNetworkReachabilityStatus) {
    HzxNetworkReachabilityStatusUnknown          = -1,
    HzxNetworkReachabilityStatusNotReachable     = 0,
    HzxNetworkReachabilityStatusReachableViaWWAN = 1,
    HzxNetworkReachabilityStatusReachableViaWiFi = 2,
};


@interface Single : NSObject

@property (nonatomic, assign) BOOL isLogin; //判断是否登录
@property (nonatomic,assign)HzxNetworkReachabilityStatus networkStatus;
@property (nonatomic,strong)MoneyModel *moneyModel;
+ (Single *)shareSingle;


//更新钱数
+(void)updateWithMoneyModel;
@end
