//
//  TimeLineCell.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineCell : UITableViewCell
@property (nonatomic,weak)NSIndexPath *indexPath;
@property (nonatomic,copy)void (^playBlock)(UIButton *button, id model);
@property (nonatomic,weak)id model;
+(CGFloat)getHeight;
@end
