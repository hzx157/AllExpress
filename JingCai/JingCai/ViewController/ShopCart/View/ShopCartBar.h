//
//  ShopCartBar.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCartBar : UIView
@property (nonatomic,copy)void (^actionBlock)(UIButton *button);
@property (nonatomic,copy)void (^chooseBlock)(UIButton *button);

@property(nonatomic,assign)BOOL isDelete;
-(void)setPri:(CGFloat)pri num:(NSInteger)num;
@end
