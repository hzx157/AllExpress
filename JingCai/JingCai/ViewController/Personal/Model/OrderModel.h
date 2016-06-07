//
//  OrderModel.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderSelectView.h"
#import "PayModel.h"
@interface OrderModel : NSObject
@property (nonatomic, copy) NSString * addressDetail;
@property (nonatomic, assign) NSInteger bookingId;
@property (nonatomic, copy) NSString * bookingName;
@property (nonatomic, assign) NSInteger buyNum; //总数量
@property (nonatomic, copy) NSString * contact;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, strong) NSArray * detailList;
@property (nonatomic, assign) NSInteger finishTime;
@property (nonatomic, copy) NSString * glideId;
@property (nonatomic, assign) CGFloat money; //总额
@property (nonatomic, assign) NSInteger payTime;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * zipcode;
@property (nonatomic, copy) NSString * outTradeNo;//订单号
@property (nonatomic, assign)OrderType type;
@property (nonatomic, assign) NSInteger sponsorId;
@property (nonatomic, assign) NSInteger receiptTime;
@property (nonatomic, assign) NSInteger recipientId;
@property (nonatomic, assign) NSInteger tuiExpress;
@property (nonatomic, copy) NSString * express;
//判断余额是不是有够钱。有就有余额，没有就支付宝
/**
 *
 *
 *  @param bookId  订单号
 *  @param money   金额
 *  @param type    支付状态
 *  @param isYu    是否使用余额
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)payBookId:(NSString *)bookId money:(NSString *)money toPayModelType:(PayModelType)type toYu:(BOOL)isYu success:(successBlock)success
         failure:(failureBlock)failure;

/**
 *  成为代言人等
 *
 *  @param money     钱
 *  @param type      微信支付或支付宝支付
 *  @param _roleType 成为的角色
 *  @param isYu      是否是使用余额
 *  @param success   成功回到
 *  @param failure   失败回调
 */
+(void)payRoleMoney:(NSString *)money toPayModelType:(PayModelType)type roleType:(roleType)_roleType  toYu:(BOOL)isYu success:(successBlock)success
            failure:(failureBlock)failure;

+(void)setValicode:(NSString *)valicode;//输入验证码

@end


@interface DetailListModel : NSObject

@property (nonatomic, copy) NSString * attachData;
@property (nonatomic, assign) NSInteger bookDetailId;
@property (nonatomic, assign) long bookingId;
@property (nonatomic, assign) NSInteger buyNum;
@property (nonatomic, copy) NSString * colorValue;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger itemsPerPage;
@property (nonatomic, copy) NSString * keywords;
@property (nonatomic, copy) NSString * mainImage;
@property (nonatomic, assign) CGFloat money;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, strong) NSString * productName;
@property (nonatomic, strong) NSString * sizeValue;
@property (nonatomic, assign) NSInteger skuId;
@property (nonatomic, assign) CGFloat skuPrice;
@property (nonatomic, assign) NSInteger updateTime;

@end