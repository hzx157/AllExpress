//
//  SureOderShopCell.h
//  JingCai
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SureOderShopCell : UITableViewCell

@property (nonatomic, strong) ShopCarModel *carModel;
@property(nonatomic,weak)NSIndexPath *indexPath;

@property(nonatomic,copy)void (^countBlock)(NSIndexPath *indexPath,ShopCarModel *carModel);
@end
