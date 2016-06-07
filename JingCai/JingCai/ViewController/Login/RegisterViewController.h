//
//  RegisterViewController.h
//  JingCai
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//  注册界面

typedef NS_ENUM(NSInteger,RegisterViewType){

    RegisterViewTypeRegist = 0,
     RegisterViewTypeFind,
     RegisterViewTypeUpdate
};



#import "BaseViewController.h"
@interface RegisterViewController : BaseViewController<UITextFieldDelegate>
@property (nonatomic,assign)RegisterViewType type;
@property (nonatomic,copy)void (^block)(NSString *code);
@end

@interface ProtocolButton : UIButton

@end