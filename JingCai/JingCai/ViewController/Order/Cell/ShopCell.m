//
//  ShopCell.m
//  JingCai
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 apple. All rights reserved.
//  商品 cell

#import "ShopCell.h"
#import "ShopView.h"

@interface ShopCell (){
    
}

@property (nonatomic, strong) ShopView *leftShopView;
@property (nonatomic, strong) ShopView *rightShopView;

@end

@implementation ShopCell

- (UIView *)leftShopView{
    if(!_leftShopView){
        _leftShopView = [[ShopView alloc] init];
        [_leftShopView.shopBtn addTarget:self action:@selector(handleShop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftShopView;
}

- (ShopView *)rightShopView{
    if(!_rightShopView){
        _rightShopView = [[ShopView alloc] init];
        [_rightShopView.shopBtn addTarget:self action:@selector(handleShop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightShopView;
}

- (id )initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor clearColor];
        [self setup];
    }
    return self;
}

- (void)setup{
    [self.contentView addSubview:self.leftShopView];
    [self.contentView addSubview:self.rightShopView];
}

- (void)layoutSubviews{
    self.leftShopView.frame = CGRectMake(PADDING_LEFTSHOP, ZERO, SIZE_SHOP_WIDTH, SIZE_SHOP_ALLHEIGHT);
    self.rightShopView.frame = CGRectMake(self.leftShopView.right + PADDING_SHOPS, ZERO, SIZE_SHOP_WIDTH, SIZE_SHOP_ALLHEIGHT);
}

- (void)setIndex:(NSIndexPath *)index{
    self.leftShopView.shopDic = [self.data objectAtIndex:index.row];
    self.rightShopView.shopDic = [self.data objectAtIndex:index.row + 1];
    self.leftShopView.shopBtn.tag = index.row;
    self.rightShopView.shopBtn.tag = index.row + 1;
}

#pragma mark --- 商品点击 ---

- (void)handleShop:(UIButton *)sender{
    self.block(self.data[sender.tag][@"productId"]);
}

@end
