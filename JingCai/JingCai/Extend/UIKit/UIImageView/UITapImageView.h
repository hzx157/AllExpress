//
//  UITapImageView.h
//  BusinessWorld
//
//  Created by XiaoWu on 14/12/26.
//  Copyright (c) 2014年 HuangZhenXiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITapImageView : UIImageView

@property (nonatomic, copy) void(^tapAction)(id);
- (void)addTapBlock:(void(^)(id obj))tapAction;

-(void)setImageWithUrl:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage tapBlock:(void(^)(id obj))tapAction;
@end
