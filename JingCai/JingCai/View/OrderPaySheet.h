//
//  OrderPaySheet.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^backBlock)(BOOL isSccuess);
@interface OrderPaySheet : UIView

-(void)show:(NSString *)money block:(backBlock)block;
@end
