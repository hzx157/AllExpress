//
//  ShopInfoView.h
//  JingCai
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 apple. All rights reserved.
//  商品信息展示视图

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShopInfoViewStyle) {
    ShopInfoViewStyleNomal,
    ShopInfoViewStyleOrder
};


@interface ShopInfoView : UIView

@property (nonatomic, strong) UIImageView *shopImg; //商品图片
@property (nonatomic, strong) UILabel *shopTitle; //商品标题
@property (nonatomic, strong) UILabel *shopColor; //商品颜色分类
@property (nonatomic, strong) UILabel *shopSize; //商品尺寸
@property (nonatomic, strong) UILabel *shopLeftMoney; //商品价格符号
@property (nonatomic, strong) UILabel *shopMoney; //商品价格
@property (nonatomic, strong) UILabel *shopCount; //商品数量
@property (nonatomic, strong) UIButton *returnButton; //换货
@property (nonatomic, strong) ShopCarModel *carModel;


@end
