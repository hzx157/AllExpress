//

//  ShopView.m
//  JingCai
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShopView.h"

@interface ShopView (){
    
}

@property (nonatomic, strong) UIImageView *shopImg; //商品图片
@property (nonatomic, strong) UILabel *titleLabel; //标题
@property (nonatomic, strong) UILabel *moneyLabel; //钱
@property (nonatomic, strong) UILabel *salesLabel; //销售额
@property (nonatomic, strong) UILabel *moneyLeftLabel;

@end

@implementation ShopView

//商品按钮
- (UIButton *)shopBtn{
    if(!_shopBtn){
        _shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       // _shopBtn.backgroundColor = [UIColor whiteColor];
       // [self addSubview:_shopBtn];
    }
    return _shopBtn;
}

//商品图片
- (UIImageView *)shopImg{
    if(!_shopImg){
        _shopImg = [[UIImageView alloc] init];
        _shopImg.clipsToBounds = YES;
        _shopImg.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_shopImg];
    }
    return _shopImg;
}

//商品标题
- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

//商品左边 元 字符号
- (UILabel *)moneyLeftLabel{
    if(!_moneyLeftLabel){
        _moneyLeftLabel = [[UILabel alloc] init];
        _moneyLeftLabel.font = [UIFont systemFontOfSize:10];
        _moneyLeftLabel.textColor = [UIColor redColor];
        [self addSubview:_moneyLeftLabel];
    }
    return _moneyLeftLabel;
}

//商品价格
- (UILabel *)moneyLabel{
    if(!_moneyLabel){
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfSize:17];
        _moneyLabel.textColor = [UIColor redColor];
        [self addSubview:_moneyLabel];
    }
    return _moneyLabel;
}

//商品销售额
- (UILabel *)salesLabel{
    if(!_salesLabel){
        _salesLabel = [[UILabel alloc] init];
        _salesLabel.font = [UIFont systemFontOfSize:13];
        _salesLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_salesLabel];
    }
    return _salesLabel;
}

- (id)init{
    if(self = [super init]){
    }
    return self;
}

- (void)layoutSubviews{
    
    self.shopBtn.frame = CGRectMake(ZERO, ZERO, self.width, self.height);
    self.shopImg.frame = CGRectMake(ZERO, ZERO, self.shopBtn.width, SIZE_SHOP_HEIGHT);
    self.titleLabel.frame = CGRectMake(5, self.shopImg.bottom + 5, self.shopBtn.width - 10, 15);
    self.moneyLeftLabel.frame = CGRectMake(5, self.titleLabel.bottom + 14, 10, 11);
    self.moneyLabel.frame = CGRectMake(self.moneyLeftLabel.right, self.titleLabel.bottom + 10, self.shopBtn.width/2, 15);
    self.salesLabel.frame = CGRectMake(self.shopBtn.width/2+5, self.titleLabel.bottom + 12, self.shopBtn.width/2-10, 15);
    
}

- (void)setShopDic:(NSDictionary *)shopDic{
    [self.shopImg sd_setImageWithURL:shopDic[@"mainImage"]];
    self.titleLabel.text = shopDic[@"productName"];
    self.moneyLeftLabel.text = @"￥";
    self.moneyLabel.text = [NSString stringWithFormat:@"%@",shopDic[@"basePrice"]];
    self.salesLabel.text = [NSString stringWithFormat:@"销量:%@",shopDic[@"saleNum"]];
}

@end
