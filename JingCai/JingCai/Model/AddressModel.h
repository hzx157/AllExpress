//
//  AddressModel.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
@property (nonatomic, assign) NSInteger addressId;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, strong) NSString * cityName;
@property (nonatomic, strong) NSString * contact;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, strong) NSString * detailAddress;
@property (nonatomic, strong) NSString * disName;
@property (nonatomic, assign) NSInteger districtId;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * proName;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) NSInteger updateTime;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString * zipcode;
@end
