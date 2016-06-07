//
//  ShopCarModel.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCarModel : NSObject
@property (nonatomic, copy) NSString * allnum;
@property (nonatomic, assign) NSInteger basePrice;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, copy) NSString * mainImage;
@property (nonatomic, copy) NSString * productDetail;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, copy) NSString * productName;
@property (nonatomic, assign) NSInteger updateTime;

@property (nonatomic, copy) NSString * sprice;
@property (nonatomic, copy) NSString * simage;
@property (nonatomic, copy) NSString * scolor;
@property (nonatomic, copy) NSString * ssize;
@property (nonatomic, assign) NSInteger snum;
@property (nonatomic,assign)NSInteger skuId;
@property(nonatomic,copy)NSString *sid;



+(ShopCarModel *)initWithDict:(NSDictionary *)dic price:(NSString *)price image:(NSString *)image color:(NSString *)color size:(NSString *)size num:(NSInteger)num skuID:(NSInteger)skuId;
@end
