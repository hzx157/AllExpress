//
//  AddressModel.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
@property (nonatomic, assign) NSInteger address_id;

@property (nonatomic, copy) NSString  *city;

@property (nonatomic, copy) NSString * contact;

@property (nonatomic, assign) NSInteger createTime;

@property (nonatomic, copy) NSString * detail_address;

@property (nonatomic, copy)NSString *district;

@property (nonatomic, copy) NSString * phone;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, assign) NSInteger updateTime;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString * zipcode;

@property (nonatomic,assign)BOOL isdefalt;

@property (nonatomic,copy)NSString *addressDetail;
@end
