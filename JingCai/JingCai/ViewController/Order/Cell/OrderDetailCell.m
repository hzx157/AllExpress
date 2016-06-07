//
//  OrderDetailCell.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OrderDetailCell.h"
#import "ShopInfoView.h"

@interface OrderDetailCell()
@property (nonatomic,weak)ShopInfoView *shopInfoView ;

@end
@implementation OrderDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews
{
    ShopInfoView *shopInfoView = [[ShopInfoView alloc] initWithFrame:CGRectMake(10, 5, IPHONE_WIDTH - 20, 80)];
    shopInfoView.carModel = nil;
    _shopInfoView = shopInfoView;
    [self addSubview:shopInfoView];
    [shopInfoView.returnButton addTarget:self action:@selector(serialized:) forControlEvents:UIControlEventTouchUpInside];
   
}
-(void)serialized:(UIButton *)button{
  
    self.block(_model);
}
- (void)setModel:(DetailListModel *)model
{
    _model = model;
    

    [_shopInfoView.shopImg sd_setImageWithURL:[NSURL URLWithString:model.mainImage] placeholderImage:defaultLogo];
    _shopInfoView.shopTitle.text = model.productName;
    _shopInfoView.shopColor.text = [NSString stringWithFormat:@"颜色分类：%@",model.colorValue];
    _shopInfoView.shopSize.text = [NSString stringWithFormat:@"尺码：%@",model.sizeValue];
    _shopInfoView.shopMoney.text = [NSString stringWithFormat:@"%.2f",model.money];
    _shopInfoView.shopCount.text = [NSString stringWithFormat:@"%ld件",(long)model.buyNum];
    [_shopInfoView.shopMoney sizeToFit];
    _shopInfoView.returnButton.left = _shopInfoView.shopMoney.right +10.0;
    _shopInfoView.returnButton.top = _shopInfoView.shopMoney.top - 2;
    [_shopInfoView.returnButton setTitle:@"换货" forState:UIControlStateNormal];
   
    
    
}
-(void)setAModel:(OrderModel *)aModel{
 
    _aModel = aModel;
     _shopInfoView.returnButton.hidden = aModel.type != OrderTypeWaitRecive;
}
@end
