//
//  hzxActionSheet.h
//  Social
//
//  Created by XiaoWu on 15/4/21.
//  Copyright (c) 2015年 HuangZhenXiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol actionSheetDelegate;
@interface HzxActionSheet : NSObject

@property (strong,nonatomic) UIWindow *mainWindow;
@property (strong,nonatomic) UIWindow *myWindow;
@property (strong,nonatomic) NSString *myTitle;
@property (strong,nonatomic) UIView *backView;
@property (weak,nonatomic) UIView *myView;
@property (weak) id<actionSheetDelegate> delegate;
-(void)dismissHzxActionSheet;
-(void)showHzxActionsheetWithView:(UIView*)view;
@end

@protocol actionSheetDelegate <NSObject>

@optional
-(void)willDismissHzxActionSheet:(HzxActionSheet*)sheet;
-(void)didDismissHzxActionSheet:(HzxActionSheet*)sheet;
-(void)commitAction:(HzxActionSheet*)sheet withMyView:(UIView*)myView;
@end
