//
//  RequestClient.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RequestClient.h"
#import "ApiServer.h"
#import "JCRSA.h"
@implementation RequestClient
+(instancetype)sharedClient{
    
    static RequestClient *client;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[RequestClient alloc]init];
    });
    
    return client;
}

//注册
-(void)login_register_loginName :(NSString *)loginName valicode :(NSString *)valicode userPsw :(NSString *)userPsw refereeCode :(NSString *)refereeCode
                        progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                         success:(successBlock)success
                         failure:(failureBlock)failure{
    
    NSDictionary *dict = @{@"loginName":loginName,
                           @"valicode":valicode,
                         //  @"userPsw":userPsw
                           @"refereeCode":[Common getNULLString:refereeCode]};
    
    [self POST:@"user/register" parameters:dict progress:uploadProgress success:success failure:failure];

}

//登录
-(void)login_login_loginName :(NSString *)loginName userPsw :(NSString *)userPsw
                     progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                      success:(successBlock)success
                      failure:(failureBlock)failure{
    
    
     NSDictionary *dict = @{@"a":[Common getNULLString:loginName],@"b":[Common getNULLString:userPsw]};
    
    NSString *enc = [JCRSA encryptString:[dict mj_JSONString] publicKey:@""];
    
    
    
////    NSDictionary *dict = @{@"loginName":[Common getNULLString:loginName],
//                           @"userPsw":[Common getNULLString:userPsw]
//                          };
    
    [self POST:@"user/loginrsa" parameters:@{@"paramList":enc} progress:uploadProgress success:success failure:failure];

}

//获取验证码
-(void)login_sendCode_loginName :(NSString *)loginName
                     progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                      success:(successBlock)success
                      failure:(failureBlock)failure{
    
    NSDictionary *dict = @{@"loginName":[Common getNULLString:loginName],
                           
                           };
    
    [self POST:@"user/sendMessage" parameters:dict progress:uploadProgress success:success failure:failure];
    
}


//找密码
-(void)login_find_loginName :(NSString *)loginName valicode :(NSString *)valicode userPsw :(NSString *)userPsw
                        progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                         success:(successBlock)success
                         failure:(failureBlock)failure{
    
    NSDictionary *dict = @{@"loginName":loginName,
                           @"valicode":valicode,
                           @"userPsw":userPsw
                           };
    
    [self POST:@"user/forgetPsw" parameters:dict progress:uploadProgress success:success failure:failure];
    
}

//更新密码
-(void)login_update_userPsw :(NSString *)userPsw
                    progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                     success:(successBlock)success
                     failure:(failureBlock)failure{
    
    NSDictionary *dict = @{@"oldPsw":[LoginModel shareLogin].pass,
                           @"userPsw":userPsw
                           };
    
    [self POST:@"user/updatePsw" parameters:dict progress:uploadProgress success:success failure:failure];
    
}

//更新昵称
-(void)user_update_nickName :(NSString *)nickName
                    progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                     success:(successBlock)success
                     failure:(failureBlock)failure{
    
    NSDictionary *dict = @{
                           @"nickName":nickName
                           };
    
    [self POST:@"user/updNickName" parameters:dict progress:uploadProgress success:success failure:failure];
    
}
//获取个人信息
-(void)user_get_info_progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                     success:(successBlock)success
                     failure:(failureBlock)failure{
    
    NSDictionary *dict = @{
                        
                           };
    
    [self POST:@"user/info" parameters:dict progress:uploadProgress success:success failure:failure];
    
}
//更新头像
-(void)user_update_image :(NSString *)userImage
                    progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                     success:(successBlock)success
                     failure:(failureBlock)failure{
    
    NSDictionary *dict = @{
                           @"userImage":userImage
                           };
    
    [self POST:@"user/updImage" parameters:dict progress:uploadProgress success:success failure:failure];
    
}

//更新性别
-(void)user_update_sex :(NSString *)sex
               progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                success:(successBlock)success
                failure:(failureBlock)failure{
    NSDictionary *dict = @{
                           @"sex":sex
                           };
    
    [self POST:@"user/updSex" parameters:dict progress:uploadProgress success:success failure:failure];

}


//订单列表
- (void)order_list_pageSize:(NSString *)pageSize pageno:(NSString *)pageno status:(NSString *)status progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                    success:(successBlock)success
                    failure:(failureBlock)failure
{
    if([status isEqualToString:@"01"])
        status = @"";
    if([status isEqualToString:@"99"]){
        status = @"07,09,11,13,14,15";
    }
    
    
    NSDictionary *dict = @{@"pageSize":pageSize,
                           @"pageNo":pageno,
                           @"status":status};
    [self POST:@"booking/orderList" parameters:dict progress:uploadProgress success:success failure:failure];
}




#pragma mark----更新用户地区
//更新用户地区
-(void)user_update_province :(NSString *)province toCity :(NSString *)city toDistrict :(NSString *)district
                    progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                     success:(successBlock)success
                     failure:(failureBlock)failure{

    NSDictionary *dict = @{
                           @"province":[Common getNULLString:province],
                           @"city":[Common getNULLString:city],
                           @"district":[Common getNULLString:district]

                           };
    
    [self POST:@"user/updateUserArea" parameters:dict progress:uploadProgress success:success failure:failure];
    
}

//我的账户详情
-(void)user_account_info_progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                          success:(successBlock)success
                          failure:(failureBlock)failure{
    NSDictionary *dict = @{
                           };
    
    [self POST:@"account/info" parameters:dict progress:uploadProgress success:success failure:failure];
    
}
//添加支付宝支付请求
-(void)user_alipay_addBooking:(NSString *)money extern_token:(NSString *)extern_token
               progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                success:(successBlock)success
                failure:(failureBlock)failure{
    NSDictionary *dict = @{
                           @"money":[Common getNULLString:money],
                           @"extern_token":[Common getNULLString:extern_token]
                           
                           
                           };
    
    [self POST:@"alipay/addBooking" parameters:dict progress:uploadProgress success:success failure:failure];
    
}
#pragma mark---添加微信支付请求
//添加微信支付请求
-(void)user_weChat_addmoney:(NSString *)money extern_token:(NSString *)extern_token
                     progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                      success:(successBlock)success
                      failure:(failureBlock)failure{
    NSDictionary *dict = @{
                           @"money":[Common getNULLString:money],
                           @"remark":[Common getNULLString:extern_token]
                           
                           };
    
    [self POST:@"tenpay/addTenpayBooking" parameters:dict progress:uploadProgress success:success failure:failure];
}

//添加收货地址
-(void)user_add_address_dic :(NSDictionary *)dic update:(BOOL)isUpdate
               progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                success:(successBlock)success
                failure:(failureBlock)failure{
    
    if(isUpdate){
    [self POST:@"address/updAddress" parameters:dic progress:uploadProgress success:success failure:failure];
    }else
    [self POST:@"address/addAddress" parameters:dic progress:uploadProgress success:success failure:failure];
    
}

//删除收货地址
-(void)user_del_address_id :(NSString *)addressId
                    progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                     success:(successBlock)success
                     failure:(failureBlock)failure{
    
      NSDictionary *dict = @{
                           @"addressId":addressId
                           };
        [self POST:@"address/delAddress" parameters:dict progress:uploadProgress success:success failure:failure];
    
}

//设置默认收货地址
-(void)user_default_address_id :(NSString *)addressId
                   progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                    success:(successBlock)success
                    failure:(failureBlock)failure{
    
    NSDictionary *dict = @{
                           @"addressId":addressId
                           };
    [self POST:@"address/updDefAddress" parameters:dict progress:uploadProgress success:success failure:failure];
    
}
//我的地址列表
-(void)user_get_address_info_progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                          success:(successBlock)success
                          failure:(failureBlock)failure{
    NSDictionary *dict = @{
                           };
    
    [self POST:@"address/addressList" parameters:dict progress:uploadProgress success:success failure:failure];
    
}
//我的默认地址
-(void)user_get_address_default_progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                              success:(successBlock)success
                              failure:(failureBlock)failure{
    NSDictionary *dict = @{
                           };
    
    [self POST:@"address/defaultAddress" parameters:dict progress:uploadProgress success:success failure:failure];
    
}
//address/defaultAddress


#pragma mark---收藏列表
//收藏列表
-(void)user_get_favorite_list_pagesize:(NSInteger )pagesize pageno:(NSInteger)pageno progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                               success:(successBlock)success
                               failure:(failureBlock)failure{
    NSDictionary *dict = @{@"pageSize":@(pagesize),
                           @"pageNo":@(pageno)
                           };
    [self POST:@"favorite/list" parameters:dict progress:uploadProgress success:success failure:failure];

}
#pragma mark---添加收藏
//添加收藏
-(void)user_add_favorite_favId:(NSString *)favId type:(NSInteger)type progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                               success:(successBlock)success
                               failure:(failureBlock)failure{
    NSDictionary *dict = @{@"favId":favId,
                           @"type":@(type)};
    [self POST:@"favorite/add" parameters:dict progress:uploadProgress success:success failure:failure];
    
}
#pragma mark---删除收藏
//删除收藏
-(void)user_delete_favorite_favId:(NSString *)favId type:(NSInteger)type progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                       success:(successBlock)success
                       failure:(failureBlock)failure{
    NSDictionary *dict = @{@"favId":[Common getNULLString:favId],
                           @"type":@(type)};
    [self POST:@"favorite/del" parameters:dict progress:uploadProgress success:success failure:failure];
    
}

#pragma mark---我的推荐人信息
//我的推荐人信息
-(void)user_myRefereesInfo_id:(NSString *)favId progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                      success:(successBlock)success
                       failure:(failureBlock)failure{

    
    NSDictionary *dict = @{@"myRefereesInfo":favId};
    
    [self POST:@"user/myRefereesInfo" parameters:favId.length ? dict : @{} progress:uploadProgress success:success failure:failure];
    
}


//我的代理
/**
 *  我的代理
 *
 *  @param type           2： 三级代理 1:二级代理 0：高级代理
 *  @param dict
 *  @param uploadProgress uploadProgress description
 *  @param success        success description
 *  @param failure
 */
-(void)user_myDaili:(NSInteger)type dict:(NSDictionary *)dict  progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
            success:(successBlock)success
            failure:(failureBlock)failure{

    NSString *string = @"user/myThird";
    switch (type) {
        case 0:
            string = @"user/myFirst";
            break;
        case 1:
            string = @"user/mySecond";
            break;
            
        default:
            break;
    }
    
    
     [self POST:string parameters:dict progress:uploadProgress success:success failure:failure];
}

//轮播广告
-(void)index_page_typeprogress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                       success:(successBlock)success
                       failure:(failureBlock)failure{
    NSDictionary *dict = @{@"bannerType":@"index_banner"
                        
                           };
    [self POST:@"product/bannerList" parameters:dict progress:uploadProgress success:success failure:failure];
}
//产品列表
- (void)shop_list_pagesize:(NSInteger)pagesize pageno:(NSInteger)pageno progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                   success:(successBlock)success
                   failure:(failureBlock)failure{
    NSDictionary *dict = @{@"pageSize":@(pagesize),
                           @"pageNo":@(pageno)
                           };
    [self POST:@"product/list" parameters:dict progress:uploadProgress success:success failure:failure];
}

//产品详情页面
- (void)shop_details_prodoctid:(NSString *)prodoctid progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                       success:(successBlock)success
                       failure:(failureBlock)failure{
    NSDictionary *dict = @{@"productId":[Common getNULLString:prodoctid],
                           };
    [self POST:@"product/info" parameters:dict progress:uploadProgress success:success failure:failure];
}
//下单
- (void)order_sure_addressId:(NSString *)addressId orderJson:(NSString *)orderJson progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                     success:(successBlock)success
                     failure:(failureBlock)failure{
    NSDictionary *dict = @{@"addressId":addressId,
                           @"orderJson":orderJson
                           };
    [self POST:@"booking/addBooking" parameters:dict progress:uploadProgress success:success failure:failure];

}

//成为代言人 userType		int	3:代言人  4：代理商
-(void)user_spokesman:(NSInteger)userType  progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
            success:(successBlock)success
            failure:(failureBlock)failure{
    NSDictionary *dict = @{@"userType":@(userType),
                           
                           };
    [self POST:@"user/spokesman" parameters:dict progress:uploadProgress success:success failure:failure];
    
}


//订单付款
- (void)order_Pay_bookId:(NSString *)bookingId toValicode:(NSString *)valicode progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                     success:(successBlock)success
                     failure:(failureBlock)failure{
    NSDictionary *dict = @{@"bookingId":bookingId,
                           @"valicode":valicode
                           };
    [self POST:@"booking/payOrder" parameters:dict progress:uploadProgress success:success failure:failure];
    
}
//换货申请
- (void)order_exchange_expressId:(NSString *)expressId bookingId:(NSString *)bookingId remark:(NSString *)remark progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                     success:(successBlock)success
                     failure:(failureBlock)failure{
    NSDictionary *dict = @{@"bookingId":bookingId,
                           @"expressId":[Common getNULLString:expressId],
                           @"remark":[Common getNULLString:remark]
                           };
    [self POST:@"booking/exchange" parameters:dict progress:uploadProgress success:success failure:failure];
    
}
//订单详情
- (void)order_info_bookId:(NSString *)bookingId progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                 success:(successBlock)success
                 failure:(failureBlock)failure{
    NSDictionary *dict = @{@"bookingId":bookingId};
    [self POST:@"booking/transactionInfo" parameters:dict progress:uploadProgress success:success failure:failure];
    
}
//退款（不退货）尚未发货订单提交退款申请
- (void)order_refund_bookId:(NSString *)bookingId progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                  success:(successBlock)success
                  failure:(failureBlock)failure{
    NSDictionary *dict = @{@"bookingId":bookingId};
    [self POST:@"booking/refund" parameters:dict progress:uploadProgress success:success failure:failure];
    
}
//关闭订单（尚未发货订单）
- (void)order_closeOrder_bookId:(NSString *)bookingId progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                    success:(successBlock)success
                    failure:(failureBlock)failure{
    NSDictionary *dict = @{@"bookingId":bookingId};
    [self POST:@"booking/closeOrder" parameters:dict progress:uploadProgress success:success failure:failure];
    
}
//完成订单
- (void)order_finish_bookId:(NSString *)bookingId progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                        success:(successBlock)success
                        failure:(failureBlock)failure{
    NSDictionary *dict = @{@"bookingId":bookingId};
    [self POST:@"booking/finish" parameters:dict progress:uploadProgress success:success failure:failure];
    
}

//快递查询 1：发货  2：退货
- (void)order_kuaiid_type:(NSInteger)type bookingId:(NSString *)bookingId progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                         success:(successBlock)success
                         failure:(failureBlock)failure{
    NSDictionary *dict = @{@"bookingId":bookingId,
                           @"type":@(type)
                           };
    [self POST:@"booking/kuaidi" parameters:dict progress:uploadProgress success:success failure:failure];
    
}
//交易明细
- (void)user_paymanet_list_pagesize:(NSInteger)pagesize pageno:(NSInteger)pageno progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                   success:(successBlock)success
                   failure:(failureBlock)failure{
    NSDictionary *dict = @{@"pageSize":@(pagesize),
                           @"pageNo":@(pageno)
                           };
    [self POST:@"booking/transactionList" parameters:dict progress:uploadProgress success:success failure:failure];
}
//业绩
- (void)user_yeji_list_pagesize:(NSInteger)pagesize pageno:(NSInteger)pageno progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                            success:(successBlock)success
                            failure:(failureBlock)failure{
    NSDictionary *dict = @{@"pageSize":@(pagesize),
                           @"pageNo":@(pageno)
                           };
    [self POST:@"performance/list" parameters:dict progress:uploadProgress success:success failure:failure];
}

//视频
- (void)user_video_progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                    success:(successBlock)success failure:(failureBlock)failure{

[self POST:@"jingcai/video" parameters:@{} progress:uploadProgress success:success failure:failure];
}

//提现
- (void)user_mony_tix:(NSDictionary *)dic progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                    success:(successBlock)success failure:(failureBlock)failure{
    
    [self POST:@"account/transfers" parameters:dic progress:uploadProgress success:success failure:failure];
}

//换货申请
- (void)order_exchange_remark:(NSString *)remark bookingId:(NSString *)bookingId progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                  success:(successBlock)success
                  failure:(failureBlock)failure{
    NSDictionary *dict = @{@"bookingId":bookingId,
                           @"remark":remark
                           };
    [self POST:@"booking/exchange" parameters:dict progress:uploadProgress success:success failure:failure];
    
}
//填写退货物流
- (void)order_tuiExpress_tuiExpress:(NSString *)tuiExpress bookingId:(NSString *)bookingId progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                      success:(successBlock)success
                      failure:(failureBlock)failure{
    NSDictionary *dict = @{@"bookingId":bookingId,
                           @"tuiExpress":tuiExpress
                           };
    [self POST:@"booking/exchange" parameters:dict progress:uploadProgress success:success failure:failure];
    
}
@end






