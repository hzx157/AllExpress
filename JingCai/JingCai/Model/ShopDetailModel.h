//
//  ShopDetailModel.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopDetailModel : NSObject

@property (nonatomic, copy) NSString * allnum;
@property (nonatomic, assign) NSInteger basePrice;
@property (nonatomic, strong) NSArray * colorList;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, strong) NSArray * imagelist;
@property (nonatomic, assign) BOOL isfav;
@property (nonatomic, copy) NSString * mainImage;
@property (nonatomic, copy) NSString * productDetail;
@property (nonatomic, copy) NSString * detail;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, copy) NSString * productName;
@property (nonatomic, assign) NSInteger saleNum;
@property (nonatomic, strong) NSArray * sizeList;
@property (nonatomic, strong) NSArray * skulist;
@property (nonatomic, assign) NSInteger updateTime;

@end



@interface SkulistModel : NSObject

@property (nonatomic, copy) NSString * colorValue;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, copy) NSString * imageUrl;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, copy) NSString * sizeValue;
@property (nonatomic, assign) NSInteger skuId;
@property (nonatomic, assign) NSInteger skuNum;
@property (nonatomic, assign) NSInteger skuPrice;
@property (nonatomic, copy) NSString * skuTitle;
@property (nonatomic, assign) NSInteger updateTime;

@end

@interface ImagelistModel : NSObject
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger imageId;
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, strong) NSString * imageUrl;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger updateTime;
@end