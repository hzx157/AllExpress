//
//  ShopCell.h
//  JingCai
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShopBtnBlock)(NSString *);

@interface ShopCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, copy) ShopBtnBlock block;
@property (nonatomic, strong) NSMutableArray *data;

@end
