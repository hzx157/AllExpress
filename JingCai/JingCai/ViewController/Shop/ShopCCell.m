//
//  ShopCCell.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShopCCell.h"
#import "ShopView.h"
@interface ShopCCell()
@property (nonatomic, strong) ShopView *leftShopView;
@end
@implementation ShopCCell

-(instancetype)init{
 
    if(self = [super init ]){
     
       
    }
    return self;
}
-(ShopView *)leftShopView{
 
    if(!_leftShopView){
      _leftShopView = [[ShopView alloc]initWithFrame:self.bounds];
      [self.contentView addSubview:_leftShopView];
        _leftShopView.backgroundColor = [UIColor whiteColor];
        _leftShopView.userInteractionEnabled = NO;
        _leftShopView.layer.cornerRadius = 3.0f;
        _leftShopView.layer.masksToBounds = YES;
    }
    return _leftShopView;
}
-(void)setDict:(NSDictionary *)dict{

    _dict = dict;
    self.leftShopView.shopDic = dict;
 }
@end
