//
//  WeiXinHelper.h
//  Gone
//
//  Created by 刘海东 on 16/5/18.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"


typedef void(^SucceBack)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
typedef void(^FailureBack)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);
@interface WeiXinHelper : NSObject


+(void)login;
+(void)authCallBack:(SendAuthResp * _Nonnull)resp;
+(BOOL)weiPay:(NSDictionary * _Nonnull)info;
@end
