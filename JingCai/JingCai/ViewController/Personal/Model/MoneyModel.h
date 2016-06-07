//
//  MoneyModel.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyModel : NSObject
@property (nonatomic, assign) NSInteger accountId;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) CGFloat iceMoney;
@property (nonatomic, assign) CGFloat inMoney;
@property (nonatomic, assign) CGFloat outMoney;
@property (nonatomic, assign) CGFloat salesMoney;
@property (nonatomic, assign) NSInteger updateTime;
@property (nonatomic, assign) CGFloat useMoney;

//

@end
