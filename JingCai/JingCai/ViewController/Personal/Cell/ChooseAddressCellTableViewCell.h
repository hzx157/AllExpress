//
//  ChooseAddressCellTableViewCell.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
@interface ChooseAddressCellTableViewCell : UITableViewCell
@property(nonatomic,weak)NSIndexPath *indexPath;
@property(nonatomic,weak)AddressModel *model;
@end
