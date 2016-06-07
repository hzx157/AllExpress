//
//  PersonalView.h
//  JingCai
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalView : UIView

@property (nonatomic, strong) UIImageView *headImg; //头像
@property (nonatomic, strong) UILabel *nick; //昵称
@property (nonatomic, strong) UILabel *member; //会员

@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, copy)void (^imageBlock)();
@property (nonatomic, copy)void (^buttonBlock)(UIButton *button);
@end
