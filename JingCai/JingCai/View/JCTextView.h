//
//  JCTextView.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCTextView : UITextView
@property(nonatomic, strong) NSString *placeholder;

@property (nonatomic, strong) UIColor *realTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *placeholderColor UI_APPEARANCE_SELECTOR;
@end
