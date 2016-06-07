//
//  ConsigneeInfoCell.h
//  JingCai
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface ConsigneeInfoCell : UITableViewCell

@property (nonatomic, strong) AddressModel *addressModel;

-(void)setOrderDetailHide;
@end
