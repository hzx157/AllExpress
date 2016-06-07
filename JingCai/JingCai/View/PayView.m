//
//  PayView.m
//  JingCai
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PayView.h"

@interface PayView(){
    
}
@property (nonatomic, strong) UIButton *allChooseBtn; //全选按钮
@property (nonatomic, strong) UIButton *payBtn; //结算按钮
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *money; //钱
@property (nonatomic, strong) UILabel *shopCount; //产品数量

@end

@implementation PayView

//全选按钮
- (UIButton *)allChooseBtn{
    if(!_allChooseBtn){
        _allChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allChooseBtn setTitle:@"全选" forState:0];
        [self addSubview:_allChooseBtn];
    }
    return _allChooseBtn;
}

//合计
- (UILabel *)moneyLabel{
    if(!_moneyLabel){
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor darkGrayColor];
        _moneyLabel.font = [UIFont systemFontOfSize:13];
        _moneyLabel.text = @"合计:";
        [self addSubview:_moneyLabel];
    }
    return _moneyLabel;
}

//钱
- (UILabel *)money{
    if(!_money){
        _money = [[UILabel alloc] init];
        _money.textColor = [UIColor redColor];
        _money.font = [UIFont systemFontOfSize:13];
        [self addSubview:_money];
    }
    return _money;
}

//产品数量
- (UILabel *)shopCount{
    if(!_shopCount){
        _shopCount = [[UILabel alloc] init];
        _shopCount.textColor = [UIColor darkGrayColor];
        _shopCount.font = [UIFont systemFontOfSize:13];
        [self addSubview:_shopCount];
    }
    return _shopCount;
}

//结算按钮
- (UIButton *)payBtn{
    if(!_payBtn){
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn setTitle:@"结算" forState:0];
        _payBtn.backgroundColor = [UIColor redColor];
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_payBtn];
    }
    return _payBtn;
}

- (id)init{
    if(self = [super init]){
        
    }
    return self;
}

- (void)layoutSubviews{
    
}

- (void)setDic:(NSDictionary *)dic{
    
}

@end
