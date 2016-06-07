//
//  LoginModel.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LoginModel.h"
NSString *const kRootClassCityId = @"city";
NSString *const kRootClassCityName = @"cityName";
NSString *const kRootClassDfhNum = @"dfhNum";
NSString *const kRootClassDshNum = @"dshNum";
NSString *const kRootClassDzfNum = @"dzfNum";
NSString *const kRootClassMyimage = @"myimage";
NSString *const kRootClassNickName = @"nickName";
NSString *const kRootClassProviceId = @"provice";
NSString *const kRootClassRefereeCode = @"refereeCode";
NSString *const kRootClassRoleName = @"roleName";
NSString *const kRootClassSex = @"sex";
NSString *const kRootClassTkNum = @"tkNum";
NSString *const kRootClassToken = @"token";
NSString *const kRootClassUserId = @"userId";
NSString *const kRootClassUserImage = @"userImage";
NSString *const kRootClassYshNum = @"yshNum";
NSString *const kRootClassDistrict = @"district";
NSString *const kRootClassRoleId = @"roleId";
NSString *const kRootClassPhone = @"phone";
NSString *const kRootClassPass = @"pass";

@implementation LoginModel
+(LoginModel *)shareLogin{

    static LoginModel *model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[LoginModel alloc]init];
    });
    
    return model;

}
-(NSString *)pass{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
}
-(NSString *)phone{
   return [[NSUserDefaults standardUserDefaults]objectForKey:@"tel"];
}
-(NSString *)token{
    if(!_token)
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    return _token;
}

-(void)getLoginModel{
    
    NSString *json = [[NSUserDefaults standardUserDefaults]objectForKey:@"LoginModel"];
    NSDictionary *dic = [json mj_JSONObject];
    [self initWithDictionary:dic];
//    [LoginModel mj_objectWithKeyValues:dic];
}
-(void)save{
    
     NSDictionary *dict = [self mj_keyValues];
    [[NSUserDefaults standardUserDefaults]setObject:[dict mj_JSONString] forKey:@"LoginModel"];
    [[NSUserDefaults standardUserDefaults]synchronize];

}
-(void)clear{
    self.userId = 0;
    self.pass = @"";
    self.token = @"";
    [self save];
}


-(void)initWithDictionary:(NSDictionary *)dictionary
{
  
    if(![dictionary[kRootClassCityId] isKindOfClass:[NSNull class]]){
        self.city = dictionary[kRootClassCityId];
    }
    
    if(![dictionary[kRootClassCityName] isKindOfClass:[NSNull class]]){
        self.cityName = dictionary[kRootClassCityName];
    }
    if(![dictionary[kRootClassDfhNum] isKindOfClass:[NSNull class]]){
        self.dfhNum = [dictionary[kRootClassDfhNum] integerValue];
    }
    
    if(![dictionary[kRootClassDshNum] isKindOfClass:[NSNull class]]){
        self.dshNum = [dictionary[kRootClassDshNum] integerValue];
    }
    
    if(![dictionary[kRootClassDzfNum] isKindOfClass:[NSNull class]]){
        self.dzfNum = [dictionary[kRootClassDzfNum] integerValue];
    }
    
    if(![dictionary[kRootClassMyimage] isKindOfClass:[NSNull class]]){
        self.myimage = dictionary[kRootClassMyimage];
    }
    if(![dictionary[kRootClassNickName] isKindOfClass:[NSNull class]]){
        self.nickName = dictionary[kRootClassNickName];
    }
    if(![dictionary[kRootClassProviceId] isKindOfClass:[NSNull class]]){
        self.provice = dictionary[kRootClassProviceId];
    }
    
    if(![dictionary[kRootClassRefereeCode] isKindOfClass:[NSNull class]]){
        self.refereeCode = dictionary[kRootClassRefereeCode];
    }
    if(![dictionary[kRootClassRoleName] isKindOfClass:[NSNull class]]){
        self.roleName = dictionary[kRootClassRoleName];
    }
    if(![dictionary[kRootClassSex] isKindOfClass:[NSNull class]]){
        self.sex = [dictionary[kRootClassSex] integerValue];
    }
    
    if(![dictionary[kRootClassTkNum] isKindOfClass:[NSNull class]]){
        self.tkNum = [dictionary[kRootClassTkNum] integerValue];
    }
    
    if(![dictionary[kRootClassToken] isKindOfClass:[NSNull class]]){
        self.token = dictionary[kRootClassToken];
    }
    if(self.token.length>0){
        [[NSUserDefaults standardUserDefaults] setObject:self.token forKey:@"token"];
    }
    if(![dictionary[kRootClassUserId] isKindOfClass:[NSNull class]]){
        self.userId = [dictionary[kRootClassUserId] integerValue];
    }
    
    if(![dictionary[kRootClassUserImage] isKindOfClass:[NSNull class]]){
        self.userImage = dictionary[kRootClassUserImage];
    }	
    if(![dictionary[kRootClassYshNum] isKindOfClass:[NSNull class]]){
        self.yshNum = [dictionary[kRootClassYshNum] integerValue];
    }
    if(![dictionary[kRootClassPass] isKindOfClass:[NSNull class]]){
        self.pass = dictionary[kRootClassPass];
    }
    if(![dictionary[kRootClassPhone] isKindOfClass:[NSNull class]]){
        self.phone = dictionary[kRootClassPhone];
    }
    if(![dictionary[kRootClassDistrict] isKindOfClass:[NSNull class]]){
        self.district = dictionary[kRootClassDistrict];
    }
    
    if(![dictionary[kRootClassRoleId] isKindOfClass:[NSNull class]]){
         self.roleId = [dictionary[kRootClassRoleId] integerValue];
    }
}


+(NSString *)getRoleName{
    
   return [self getRoleName:[LoginModel shareLogin].roleId];
    
}
+(NSString *)getRoleName:(roleType)type{
    switch (type) {
        case roleTypeNormal:
            return @"普通会员";
            break;
        case roleTypeAgent:
            return @"合作商";
            break;
        case roleTypeMannger:
            return @"管理员";
            break;
        case roleTypeSpokesman:
            return @"代言人";
            break;
            
        default:
            break;
    }
    return @"普通会员";
}

@end
