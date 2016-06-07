//
//  RequestClient.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "APIRequestClient.h"

@interface RequestClient : APIRequestClient

+(instancetype)sharedClient;

#pragma mark----用户


#pragma mark----注册
//注册
-(void)login_register_loginName :(NSString *)loginName valicode :(NSString *)valicode userPsw :(NSString *)userPsw refereeCode :(NSString *)refereeCode
   progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
    success:(successBlock)success
    failure:(failureBlock)failure;


#pragma mark----登录
//登录
-(void)login_login_loginName :(NSString *)loginName userPsw :(NSString *)userPsw
                        progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                         success:(successBlock)success
                         failure:(failureBlock)failure;



#pragma mark---获取验证码
//获取验证码
-(void)login_sendCode_loginName :(NSString *)loginName
                        progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                         success:(successBlock)success
                         failure:(failureBlock)failure;

#pragma mark----找密码
//找密码
-(void)login_find_loginName :(NSString *)loginName valicode :(NSString *)valicode userPsw :(NSString *)userPsw
                    progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                     success:(successBlock)success
                     failure:(failureBlock)failure;

#pragma mark----更新密码
//更新密码
-(void)login_update_userPsw :(NSString *)userPsw
                    progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                     success:(successBlock)success
                     failure:(failureBlock)failure;

#pragma mark----更新昵称
//更新昵称
-(void)user_update_nickName :(NSString *)nickName
                    progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                     success:(successBlock)success
                     failure:(failureBlock)failure;

//获取个人信息
-(void)user_get_info_progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                      success:(successBlock)success
                      failure:(failureBlock)failure;

#pragma mark----更新性别
//更新性别
-(void)user_update_sex :(NSString *)sex
                    progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                     success:(successBlock)success
                     failure:(failureBlock)failure;


#pragma mark----更新头像
//更新头像
-(void)user_update_image :(NSString *)userImage
                 progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                  success:(successBlock)success
                  failure:(failureBlock)failure;

#pragma mark----更新用户地区
//更新用户地区
-(void)user_update_province :(NSString *)province toCity :(NSString *)city toDistrict :(NSString *)district
                    progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                     success:(successBlock)success
                     failure:(failureBlock)failure;


#pragma mark----我的账户详情
//我的账户详情
-(void)user_account_info_progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                  success:(successBlock)success
                  failure:(failureBlock)failure;


#pragma mark---添加支付宝支付请求
//添加支付宝支付请求
-(void)user_alipay_addBooking:(NSString *)money extern_token:(NSString *)extern_token
                     progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                      success:(successBlock)success
                      failure:(failureBlock)failure;

//添加微信支付请求
-(void)user_weChat_addmoney:(NSString *)money extern_token:(NSString *)extern_token
                   progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                    success:(successBlock)success
                    failure:(failureBlock)failure;


#pragma mark---/添加收货地址
//添加收货地址
-(void)user_add_address_dic :(NSDictionary *)dic update:(BOOL)isUpdate
                    progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                     success:(successBlock)success
                     failure:(failureBlock)failure;



#pragma mark---删除收货地址
//删除收货地址
-(void)user_del_address_id :(NSString *)addressId
                   progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                    success:(successBlock)success
                    failure:(failureBlock)failure;

#pragma mark---/设置默认收货地址
//设置默认收货地址
-(void)user_default_address_id :(NSString *)addressId
                       progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                        success:(successBlock)success
                        failure:(failureBlock)failure;



#pragma mark---我的地址列表
//我的地址列表
-(void)user_get_address_info_progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                              success:(successBlock)success
                              failure:(failureBlock)failure;

#pragma mark---我的默认地址
//我的默认地址
-(void)user_get_address_default_progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                                 success:(successBlock)success
                                 failure:(failureBlock)failure;

#pragma mark---收藏列表
//收藏列表
-(void)user_get_favorite_list_pagesize:(NSInteger )pagesize pageno:(NSInteger)pageno progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                               success:(successBlock)success
                               failure:(failureBlock)failure;

#pragma mark---添加收藏
//添加收藏
/// type 1=产品
-(void)user_add_favorite_favId:(NSString *)favId type:(NSInteger)type progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                       success:(successBlock)success
                       failure:(failureBlock)failure;
#pragma mark---删除收藏
//删除收藏
-(void)user_delete_favorite_favId:(NSString *)favId  type:(NSInteger)type progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                          success:(successBlock)success
                          failure:(failureBlock)failure;




#pragma mark---我的推荐人信息
//我的推荐人信息
-(void)user_myRefereesInfo_id:(NSString *)favId progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                          success:(successBlock)success
                      failure:(failureBlock)fail;


#pragma mark---我的代理
/**
 *  我的代理
 *
 *  @param type           0： 三级代理 1:二级代理 2：高级代理
 *  @param dict
 *  @param uploadProgress uploadProgress description
 *  @param success        success description
 *  @param failure
 */
-(void)user_myDaili:(NSInteger)type dict:(NSDictionary *)dict  progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
            success:(successBlock)success
            failure:(failureBlock)failure;


//成为代言人 userType		int	3:代言人  4：代理商
-(void)user_spokesman:(NSInteger)userType  progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
              success:(successBlock)success
              failure:(failureBlock)failure;


//轮播广告
-(void)index_page_typeprogress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                       success:(successBlock)success
                       failure:(failureBlock)failure;
//产品列表
- (void)shop_list_pagesize:(NSInteger)pagesize pageno:(NSInteger)pageno progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                   success:(successBlock)success
                   failure:(failureBlock)failure;

//产品详情页面
- (void)shop_details_prodoctid:(NSString *)prodoctid progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                       success:(successBlock)success
                       failure:(failureBlock)failure;

//订单列表
- (void)order_list_pageSize:(NSString *)pageSize pageno:(NSString *)pageno status:(NSString *)status progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                    success:(successBlock)success
                    failure:(failureBlock)failure;

//提交订单
- (void)order_sure_addressId:(NSString *)addressId orderJson:(NSString *)orderJson progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                    success:(successBlock)success
                    failure:(failureBlock)failure;


//订单付款
- (void)order_Pay_bookId:(NSString *)bookingId toValicode:(NSString *)valicode progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                 success:(successBlock)success
                 failure:(failureBlock)failure;
////换货申请
- (void)order_exchange_expressId:(NSString *)expressId bookingId:(NSString *)bookingId remark:(NSString *)remark progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                         success:(successBlock)success
                         failure:(failureBlock)failure;
//订单详情
- (void)order_info_bookId:(NSString *)bookingId progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                  success:(successBlock)success
                  failure:(failureBlock)failure;
//退款（不退货）尚未发货订单提交退款申请
- (void)order_refund_bookId:(NSString *)bookingId progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                    success:(successBlock)success
                    failure:(failureBlock)failure;
//关闭订单（尚未发货订单）
- (void)order_closeOrder_bookId:(NSString *)bookingId progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                        success:(successBlock)success
                        failure:(failureBlock)failure;
//完成订单
- (void)order_finish_bookId:(NSString *)bookingId progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                    success:(successBlock)success
                    failure:(failureBlock)failure;
//快递查询 1：发货  2：退货
- (void)order_kuaiid_type:(NSInteger)type bookingId:(NSString *)bookingId progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                  success:(successBlock)success
                  failure:(failureBlock)failure;


//交易明细
- (void)user_paymanet_list_pagesize:(NSInteger)pagesize pageno:(NSInteger)pageno progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                            success:(successBlock)success
                            failure:(failureBlock)failure;

//业绩
- (void)user_yeji_list_pagesize:(NSInteger)pagesize pageno:(NSInteger)pageno progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                        success:(successBlock)success
                        failure:(failureBlock)failure;
//视频
- (void)user_video_progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                    success:(successBlock)success failure:(failureBlock)failure;
//提现
- (void)user_mony_tix:(NSDictionary *)dic progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
              success:(successBlock)success failure:(failureBlock)failure;

//换货申请
- (void)order_exchange_remark:(NSString *)remark bookingId:(NSString *)bookingId progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                      success:(successBlock)success
                      failure:(failureBlock)failure;
//填写退货物流
- (void)order_tuiExpress_tuiExpress:(NSString *)tuiExpress bookingId:(NSString *)bookingId progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
                            success:(successBlock)success
                            failure:(failureBlock)failure;

@end
