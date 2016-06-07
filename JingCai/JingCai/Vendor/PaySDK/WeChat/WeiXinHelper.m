//
//  WeiXinHelper.m
//  Gone
//
//  Created by 刘海东 on 16/5/18.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//

#import "WeiXinHelper.h"

#import "payRequsestHandler.h"
//#import "AssetsRequestData.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "payRequsestHandler.h"

@interface WeiXinHelper ()
@end

@implementation WeiXinHelper



/********************************** 微信授权登录  ****************************************/

+(void)login
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

//
//#pragma mark -- 当用户点击了微信登录按钮后的回调
//+(void)authCallBack:(SendAuthResp *)resp
//{
//    //用户同意授权
//    if (resp.errCode == 0) {
//        
//        //向服务端发送个人消息
//        [[AssetsRequestData assetsRequestData] assets_getWeiXinAccessUrlWithCode:resp.code Success:^(NSURLSessionDataTask *operation, id responseObject, Responese *respone) {
//            if ([respone.code intValue] != 9999999) {
//                [SINGLE showMsg:@"获取用户信息失败，请稍候重试"];
//                
//                //获取失败，返回首界面
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"popCurrentViewController" object:nil];
//            }
//        } Failure:^(NSURLSessionDataTask *operation, NSString *error, Responese *respone) {
//            [SINGLE showMsg:@"网络出现问题了，请稍候再试"];
//        }];
//    }else{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"popCurrentViewController" object:nil];
//    }
////        [[AssetsRequestData assetsRequestData] assets_getWeiXinAccessUrlWithSuccess:^(NSURLSessionDataTask *operation, id responseObject, Responese *respone) {
////            if (responseObject) {
////                    //向微信请求个人信息
////                NSString *url = responseObject;
////                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
////                manager.responseSerializer = [AFJSONResponseSerializer serializer];
////                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain", nil];;
////                [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        
////                    NSString *token = responseObject[@"access_token"];
////                    NSString *expires_in = responseObject[@"expires_in"];
////                    NSString *openid = responseObject[@"openid"];
////                    NSString *refresh_token = responseObject[@"refresh_token"];
////                    NSString *scope = responseObject[@"scope"];
////        
//////                    //上传微信个人信息
//////                    [[AssetsRequestData assetsRequestData] assets_uploadInfoWithOpenId:openid Scope:scope accessToken:token refreshToken:refresh_token expires_in:expires_in nickname:@"" Success:^(NSURLSessionDataTask *operation, id responseObject, Responese *respone) {
//////                        if (responseObject[@"accessToken"]) {
//////                            [NSUserDefaults saveKey:@"weixinInfo" value:@YES];
//////                        }
//////        
//////                    } Failure:^(NSURLSessionDataTask *operation, NSString *error, Responese *respone) {
//////            
//////                    }];
////                    
////                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////                    
////                }];
////            }
////        } Failure:^(NSURLSessionDataTask *operation, NSString *error, Responese *respone) {
////            
////        }];
////    }
//    
////        //向微信请求个人信息
////        NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",APP_ID,APP_SECRET,resp.code];
//    
////        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
////        manager.responseSerializer = [AFJSONResponseSerializer serializer];
////        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
////        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////            
////            NSString *token = responseObject[@"access_token"];
////            NSString *expires_in = responseObject[@"expires_in"];
////            NSString *openid = responseObject[@"openid"];
////            NSString *refresh_token = responseObject[@"refresh_token"];
////            NSString *scope = responseObject[@"scope"];
////            
////            //上传微信个人信息
////            [[AssetsRequestData assetsRequestData] assets_uploadInfoWithOpenId:openid Scope:scope accessToken:token refreshToken:refresh_token expires_in:expires_in nickname:@"" Success:^(NSURLSessionDataTask *operation, id responseObject, Responese *respone) {
////                if (responseObject[@"accessToken"]) {
////                    [NSUserDefaults saveKey:@"weixinInfo" value:@YES];
////                }
////                
////            } Failure:^(NSURLSessionDataTask *operation, NSString *error, Responese *respone) {
////    
////            }];
////            
////        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////            
////        }];
////    }else{
////       UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"提现到微信需要获取您的个人相关信息" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
////        [alert show];
////        
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"popCurrentViewController" object:nil];
////    }
//}
//








/********************************** 微信支付  ****************************************/


#pragma mark ------ 微信支付 ------
+(BOOL)weiPay:(NSDictionary *)info
{
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [info objectForKey:@"appid"];
    req.partnerId           = [info objectForKey:@"partnerid"];
    req.prepayId            = [info objectForKey:@"prepayid"];
    req.nonceStr            = [info objectForKey:@"noncestr"];
    req.timeStamp           = [[info objectForKey:@"timestamp"] intValue];
    req.package             = [info objectForKey:@"iospackage"];
    req.sign                = [info objectForKey:@"iossign"];
   return [WXApi sendReq:req];
  
    
    //创建支付签名对象
//    payRequsestHandler *req = [[payRequsestHandler alloc] init];
//
//    NSMutableDictionary *dict = [req sendPay_demoWithOrderInfo:info];
//    
//    if(dict != nil){
//        NSMutableString *retcode = [dict objectForKey:@"retcode"];
//        if (retcode.intValue == 0){
//            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//            
//            //调起微信支付
//            PayReq* req             = [[PayReq alloc] init];
//            req.openID              = [dict objectForKey:@"appid"];
//            req.partnerId           = [dict objectForKey:@"partnerid"];
//            req.prepayId            = [dict objectForKey:@"prepayid"];
//            req.nonceStr            = [dict objectForKey:@"noncestr"];
//            req.timeStamp           = stamp.intValue;
//            req.package             = [dict objectForKey:@"package"];
//            req.sign                = [dict objectForKey:@"sign"];
//            [WXApi sendReq:req];
//            
//        }else{
//            //            [self alert:@"提示信息" msg:[dict objectForKey:@"retmsg"]];
//        }
//    }else{
//        //        [self alert:@"提示信息" msg:@"服务器返回错误，未获取到json对象"];
//    }
}





@end
