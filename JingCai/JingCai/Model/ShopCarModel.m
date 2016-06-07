//
//  ShopCarModel.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShopCarModel.h"
@implementation ShopCarModel

+(NSString *)getPrimaryKey{
 return @"skuId";
}

+(ShopCarModel *)initWithDict:(NSDictionary *)dic price:(NSString *)price image:(NSString *)image color:(NSString *)color size:(NSString *)size num:(NSInteger)num skuID:(NSInteger)skuId{
    
    ShopCarModel *model = [ShopCarModel mj_objectWithKeyValues:dic];
    model.ssize = size;
    model.simage = image;
    model.scolor = color;
    model.sprice = price;
    model.skuId = skuId;
    model.sid = [NSString stringWithFormat:@"%ld_%@_%@",(long)model.productId,model.ssize,model.scolor];
    model.createTime = [NSDate timeIntervalSinceReferenceDate];
    model.snum = num;

    return model;
    
}
@end
