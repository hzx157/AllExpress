//
//  ShopCartCell.h
//  JingCai
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCartView.h"

@interface ShopCartCell : UITableViewCell

@property (nonatomic, strong) UIButton *chooseBtn; //选中按钮
@property (nonatomic, strong) ShopCartView *shopCartView;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, strong) ShopCarModel *model;

@end
