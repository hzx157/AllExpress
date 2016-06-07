//
//  OrderDetailCell.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface OrderDetailCell : UITableViewCell
@property (nonatomic,weak)NSIndexPath *indexPath;
@property (nonatomic,weak)DetailListModel *model;
@property (nonatomic,weak)OrderModel *aModel;
@property (nonatomic,copy)void (^block)(DetailListModel *model);
@end
