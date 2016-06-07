//
//  NickNameViewController.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"


@interface NickNameViewController : BaseViewController
@property (nonatomic,copy)void (^block)(NSString *name);
@end
