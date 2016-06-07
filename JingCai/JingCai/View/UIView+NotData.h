//
//  UIView+NotData.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, NotDataType) {
    NotDataTypeCard,//购物车
    NotDataTypeOrder, //订单
    NotDataTypeFaovi, //收藏
};


@interface UIView (NotData)

-(void)addNotMsg:(NSString *)message type:(NotDataType)type;
-(void)hideNotMsg;
@end
