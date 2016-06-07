//
//  MyOderCell.h
//  JingCai
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderModel.h"
@interface MyOderCell : UITableViewCell
@property (nonatomic ,weak) UIButton *payBtn;
@property (nonatomic ,weak) UIButton *cancelBtn;

@property (nonatomic, weak) OrderModel *model;
@property (nonatomic, weak) NSIndexPath *indexPath;
@property (nonatomic, copy) void(^payBlock)(OrderModel *aModel,NSIndexPath *indexPath);
@property (nonatomic, copy) void(^cancelBlock)(OrderModel *aModel,NSIndexPath *indexPath);


@end
