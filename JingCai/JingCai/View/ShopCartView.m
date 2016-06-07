//
//  ShopCartView.m
//  JingCai
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShopCartView.h"

@implementation ShopCartView

@synthesize carModel = _carModel;

- (void)setCarModel:(ShopCarModel *)carModel{
    
    _carModel = carModel;
    self.shopImg.frame = CGRectMake(ZERO, ZERO, self.height,self.height);
    self.shopTitle.frame = CGRectMake(self.shopImg.right + 5, ZERO, self.width - self.height - 5, 20);
    self.shopColor.frame = CGRectMake(self.shopImg.right + 5, self.shopTitle.bottom + 10, WidthScaleSize(160), 15);
    self.shopSize.frame = CGRectMake(self.width - 90.0, self.shopTitle.bottom + 10, 90, 15);
    self.shopLeftMoney.frame = CGRectMake(self.shopImg.right + 5, self.height - 10, 10, 10);
    self.shopMoney.frame = CGRectMake(self.shopLeftMoney.right, self.height - 20, 200, 20);
  //  self.shopCount.frame = CGRectMake(self.width - 50, self.height - 20, 50, 20);
  
    
    
    [self.shopImg sd_setImageWithURL:urlNamed(carModel.simage) placeholderImage:defaultLogo];
    self.shopTitle.text = [Common getNULLString:carModel.productName];
    self.shopColor.text = [NSString stringWithFormat:@"颜色分类:%@",[Common getNULLString:carModel.scolor]];
    self.shopSize.text = [NSString stringWithFormat:@"尺码:%@",[Common getNULLString:carModel.ssize]];
    self.shopMoney.text = [Common getNULLString:carModel.sprice];
    self.shopCount.text = [NSString stringWithFormat:@"%ld件",(long)carModel.snum];
}

@end
