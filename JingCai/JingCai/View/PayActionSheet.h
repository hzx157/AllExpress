//
//  PayActionSheet.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^returnBlock)(BOOL isSccuess);

@interface PayActionSheet : UIView

-(void)show:(NSString *)title type:(NSInteger)userType toBlock:(returnBlock)block;
@end
