//
//  ShopInfoView.m
//  JingCai
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShopInfoView.h"

@implementation ShopInfoView

- (UIImageView *)shopImg{
    if(!_shopImg){
        _shopImg = [[UIImageView alloc] init];
        _shopImg.contentMode = UIViewContentModeScaleAspectFit;
        _shopImg.clipsToBounds = YES;
        [self addSubview:_shopImg];
    }
    return _shopImg;
}

- (UILabel *)shopTitle{
    if(!_shopTitle){
        _shopTitle = [[UILabel alloc] init];
        _shopTitle.font = [UIFont systemFontOfSize:15];
        _shopTitle.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:_shopTitle];
    }
    return _shopTitle;
}

- (UILabel *)shopColor{
    if(!_shopColor){
        _shopColor = [[UILabel alloc] init];
        _shopColor.font = [UIFont systemFontOfSize:13];
        [self addSubview:_shopColor];
    }
    return _shopColor;
}

- (UILabel *)shopSize{
    if(!_shopSize){
        _shopSize = [[UILabel alloc] init];
//        _shopSize.textAlignment = NSTextAlignmentRight;
        _shopSize.font = [UIFont systemFontOfSize:13];
        [self addSubview:_shopSize];
    }
    return _shopSize;
}

- (UILabel *)shopLeftMoney{
    if(!_shopLeftMoney){
        _shopLeftMoney = [[UILabel alloc] init];
        _shopLeftMoney.font = [UIFont systemFontOfSize:10];
        _shopLeftMoney.textColor = [UIColor redColor];
        _shopLeftMoney.text = @"￥";
        [self addSubview:_shopLeftMoney];
    }
    return _shopLeftMoney;
}

- (UILabel *)shopMoney{
    if(!_shopMoney){
        _shopMoney = [[UILabel alloc] init];
        _shopMoney.textColor = [UIColor redColor];
        [self addSubview:_shopMoney];
    }
    return _shopMoney;
}

- (UILabel *)shopCount{
    if(!_shopCount){
        _shopCount = [[UILabel alloc] init];
        _shopCount.textColor = [UIColor darkGrayColor];
        _shopCount.textAlignment = NSTextAlignmentRight;
        _shopCount.font = [UIFont systemFontOfSize:13];
        [self addSubview:_shopCount];
        [self.shopCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20.0f);
            make.width.mas_equalTo(140.0f);
            make.height.mas_equalTo(20.0f);
            make.bottom.mas_equalTo(-2.0);
        }];
    }
    return _shopCount;
}
- (UIButton *)returnButton{
    if(!_returnButton){
        _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _returnButton.frame = CGRectMake(0, 0, 70, 25);
        [_returnButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _returnButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _returnButton.layer.masksToBounds = YES;
        _returnButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _returnButton.layer.borderWidth = 1.0f;
        _returnButton.hidden = YES;
        [self addSubview:_returnButton];
//        [_returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-7.0f);
//            make.width.mas_equalTo(70.0f);
//            make.top.mas_equalTo(2.0);
//            make.height.mas_equalTo(25.0f);
//            
//        }];
    }
    return _returnButton;
}

- (id)init{
    if(self = [super init]){
        
    }
    return self;
}

- (void)setCarModel:(ShopCarModel *)carModel{
    _carModel = carModel;
    self.shopImg.frame = CGRectMake(ZERO, ZERO, self.height,self.height);
    self.shopTitle.frame = CGRectMake(self.shopImg.right + 5, ZERO, self.width - self.height - 5, 20);
    self.shopColor.frame = CGRectMake(self.shopImg.right + 5, self.shopTitle.bottom + 10, 180, 15);
    self.shopSize.frame = CGRectMake(self.width - 90, self.shopTitle.bottom + 10, 90, 15);
    self.shopLeftMoney.frame = CGRectMake(self.shopImg.right + 5, self.height - 10, 10, 10);
    self.shopMoney.frame = CGRectMake(self.shopLeftMoney.right, self.height - 20, 200, 20);
//   self.shopCount.frame = CGRectMake(self.width - 90, self.height - 20, 90, 20);
    [self layoutIfNeeded];
   
  
}


@end
