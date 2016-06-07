//
//  AppDelegate.h
//  JingCai
//
//  Created by apple on 16/5/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//显示键盘全局
-(void)keyBoardManager;

//隐藏键盘全局
-(void)keyHideBoardManager;

-(void)login;
@end

