//
//  LoginModel.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

//1:管理员   2：普通会员  3：代言人   4：代理商
typedef NS_ENUM(NSInteger, roleType) {

    roleTypeMannger = 1,
    roleTypeNormal,
    roleTypeSpokesman,
    roleTypeAgent,
};

@interface LoginModel : NSObject

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString * cityName;

@property (nonatomic, assign) NSInteger dfhNum;

@property (nonatomic, assign) NSInteger dshNum;

@property (nonatomic, assign) NSInteger dzfNum;

@property (nonatomic, copy) NSString * myimage;

@property (nonatomic, copy) NSString * nickName;

@property (nonatomic, copy) NSString *provice;

@property (nonatomic, strong) NSString * refereeCode;

@property (nonatomic, strong) NSString * roleName;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, assign) NSInteger tkNum;

@property (nonatomic, strong) NSString * token;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, strong) NSString * userImage;

@property (nonatomic, assign) NSInteger yshNum;

@property (nonatomic, assign) roleType roleId;

@property (nonatomic, copy)NSString *district;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *pass;

+(LoginModel *)shareLogin;
-(void)getLoginModel;
-(void)save;
-(void)clear;

+(NSString *)getRoleName;
+(NSString *)getRoleName:(roleType)type;
@end
