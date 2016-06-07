//
//  UIView+SVProgress.h
//  Gone
//
//  Created by Happy on 15/7/29.
//  Copyright (c) 2015年 xiaowuxiaowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SVProgress)

+ (void)show_success_progress:(NSString *)success;

+ (void)show_loading_progress:(NSString *)loading;

+ (void)show_fail_progress:(NSString *)fail;

+ (void)dismiss_progress;

+ (void)show_networking_status:(NSString *)str;

+ (void)show_loading_progress_HUDMaskType:(NSString *)loading;
@end
