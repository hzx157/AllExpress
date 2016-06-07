//
//  UITableView+iOS7Style.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/6/1.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (iOS7Style)
-(void)applyiOS7SettingsStyleGrouping:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)setEdgeInsetsZero;//让线到头
@end
