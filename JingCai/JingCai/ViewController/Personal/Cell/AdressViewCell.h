//
//  AdressViewCell.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
@interface AdressViewCell : UITableViewCell
@property(nonatomic,weak)NSIndexPath *indexPath;
@property(nonatomic,weak)AddressModel *model;

@property (nonatomic,copy)void (^block)(NSInteger tag,NSIndexPath *indexPath,AddressModel *model);

@end
