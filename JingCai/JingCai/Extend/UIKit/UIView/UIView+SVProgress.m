//
//  UIView+SVProgress.m
//  Gone
//
//  Created by Happy on 15/7/29.
//  Copyright (c) 2015年 xiaowuxiaowu. All rights reserved.
//

#import "UIView+SVProgress.h"

@implementation UIView (SVProgress)

+(UIImage *)imageOfHud:(NSString *)string {
    

    UIImage* infoImage = [UIImage imageNamed:[@"MJRefresh.bundle" stringByAppendingPathComponent:string]];
    return infoImage;
}

+ (void)show_success_progress:(NSString *)success
{
    [self setupSVP];
    [SVProgressHUD setErrorImage:[self imageOfHud:@"success.png"]];
     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showSuccessWithStatus:success];
}
+ (void)show_loading_progress_HUDMaskType:(NSString *)loading
{
    [self setupSVP];
    [SVProgressHUD showWithStatus:loading];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
//    [SVProgressHUD showWithStatus:loading maskType:SVProgressHUDMaskTypeGradient];

}
+ (void)show_loading_progress:(NSString *)loading
{
[self setupSVP];
     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:loading];
}

+ (void)show_fail_progress:(NSString *)fail
{
    [self setupSVP];
    //[SVProgressHUD setErrorImage:[self imageOfHud:@"error.png"]];
     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showErrorWithStatus:fail];
}
+(void)setupSVP{
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setCornerRadius:2.0f];
    
}


+ (void)dismiss_progress
{
    [SVProgressHUD dismiss];
}

+ (void)show_networking_status:(NSString *)str
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"网络异常，请检查当前网络！"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
    
    [alertView show];
}

@end
