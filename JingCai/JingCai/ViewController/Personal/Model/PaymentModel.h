//
//  PaymentModel.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentModel : NSObject
@property (nonatomic, strong) NSString * addressDetail;
@property (nonatomic, strong) NSObject * attachData;
@property (nonatomic, assign) NSInteger bookingId;
@property (nonatomic, strong) NSString * bookingName;
@property (nonatomic, strong) NSString * bookingType;
@property (nonatomic, assign) NSInteger buyNum;
@property (nonatomic, strong) NSString * contact;
@property (nonatomic, assign) CGFloat countMoney;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, strong) NSObject * express;
@property (nonatomic, assign) NSInteger finishTime;
@property (nonatomic, assign) NSInteger fundType;
@property (nonatomic, strong) NSObject * glideBuyer;
@property (nonatomic, strong) NSString * glideDetail;
@property (nonatomic, strong) NSObject * glideId;
@property (nonatomic, copy) NSString * glideName;
@property (nonatomic, strong) NSObject * glideSign;
@property (nonatomic, assign) NSInteger itemsPerPage;
@property (nonatomic, strong) NSObject * keywords;
@property (nonatomic, strong) NSObject * markPrice;
@property (nonatomic, assign) CGFloat money;
@property (nonatomic, strong) NSString * outTradeNo;
@property (nonatomic, assign) NSInteger payTime;
@property (nonatomic, assign) NSInteger payWay;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, assign) NSInteger receiptTime;
@property (nonatomic, assign) NSInteger recipientId;
@property (nonatomic, strong) NSObject * remark;
@property (nonatomic, assign) NSInteger sponsorId;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * tuiExpress;
@property (nonatomic, assign) NSInteger updateTime;
@property (nonatomic, strong) NSString * zipcode;


@end
