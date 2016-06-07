
//
//  Single.m
//  JingCai
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Single.h"

@implementation Single

+ (Single *)shareSingle
{
    static Single *single = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[Single alloc] init];
    });
    
    return single;
}
-(BOOL)isLogin{
 
    return [LoginModel shareLogin].userId;
    
}

+(void)updateWithMoneyModel{
    
    [[RequestClient sharedClient]user_account_info_progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        
        MoneyModel *model= [MoneyModel mj_objectWithKeyValues:respone.data];
        [MoneyModel saveToDB:model where:nil];
        SINGLE.moneyModel = model;
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        DLog(@"--->>>>>>>>>获取金额失败");
       // [UIView show_fail_progress:respone.msg];
        SINGLE.moneyModel = [MoneyModel searchSingleWithWhere:@"" orderBy:@""];
    }];
}

@end
