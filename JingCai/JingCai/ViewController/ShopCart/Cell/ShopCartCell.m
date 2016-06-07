//
//  ShopCartCell.m
//  JingCai
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShopCartCell.h"

@implementation ShopCartCell

- (ShopCartView *)shopCartView{
    if(!_shopCartView){
        _shopCartView = [[ShopCartView alloc] init];
    }
    return _shopCartView;
}

- (UIButton *)chooseBtn{
    if(!_chooseBtn){
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseBtn setImage:imageNamed(@"adresssChoose_select_icon") forState:UIControlStateSelected];
        [_chooseBtn setImage:imageNamed(@"adresssChoose_normal_icon") forState:UIControlStateNormal];
    }
    return _chooseBtn;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setup];
    }
    return self;
}

- (void)setup{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.shopCartView];
    [self.contentView addSubview:self.chooseBtn];
}

- (void)setIndex:(NSIndexPath *)index{
    self.shopCartView.frame = CGRectMake(50, (CELL_SHOPCART_HEIGHT - SIZE_SHOPCART_IMG_HEIGHT)/2, IPHONE_WIDTH - 60, SIZE_SHOPCART_IMG_HEIGHT);
    self.chooseBtn.frame = CGRectMake((50 - 15)/2, (CELL_SHOPCART_HEIGHT - 15)/2, 15, 15);
    self.chooseBtn.tag = index.row;
    self.shopCartView.carModel = self.model;
}

@end
