//
//  FindPasswordViewController.m
//  JingCai
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "InputTextView.h"
#import "AutoCodeButton.h"


@interface FindPasswordViewController (){
    InputTextView *telInputTV; //手机号
    InputTextView *authcodeInputTV; //验证码
    InputTextView *passwordInputTV; //输入新密码
    InputTextView *surepasswordInputTV; //确认新密码
    UIButton *submitBtn; //提交按钮
    UIButton *goBackBtn; //返回
}
@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"忘记密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //背景图片
    
    UIImageView *backImgView = [[UIImageView alloc] initWithImage:imageNamed(@"Login_bj")];
    backImgView.frame = CGRectMake(ZERO, ZERO, IPHONE_WIDTH, IPHONE_HEIGHT);
    [self.view addSubview:backImgView];
    
    UIScrollView *backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(ZERO, ZERO, IPHONE_WIDTH, IPHONE_HEIGHT)];
    [self.view addSubview:backScrollView];
    
    CGFloat textWidth = 0;
    CGFloat specWidth = 0;
    
    if(iPhone5){
        textWidth = IPHONE_WIDTH - 44;
        specWidth = 40;
    }
    else{
        textWidth = IPHONE_WIDTH - 88;
        specWidth = 60;
    }
    
    //手机号码
    
    telInputTV = [[InputTextView alloc] initWithFrame:CGRectMake((IPHONE_WIDTH - textWidth)/2, 100 + 116/2, textWidth, 78/2)];
    telInputTV.leftName.text = @"手机号码";
    telInputTV.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    telInputTV.myTextField.delegate = self;
    [backScrollView addSubview:telInputTV];
    
//    SINGLE.autoInputView = telInputTV.myTextField;
    
    //验证码
    
    authcodeInputTV = [[InputTextView alloc] initWithFrame:CGRectMake((IPHONE_WIDTH - textWidth)/2, telInputTV.bottom + 20, textWidth, 78/2)];
    authcodeInputTV.leftName.text = @"验证码";
    authcodeInputTV.myTextField.delegate = self;
    authcodeInputTV.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    [backScrollView addSubview:authcodeInputTV];
    
    //获取验证码按钮
    
    AutoCodeButton *authCodeBtn = [AutoCodeButton buttonWithType:UIButtonTypeCustom];
    authCodeBtn.isReisgter = NO;
    authCodeBtn.frame = CGRectMake(authcodeInputTV.width - 34/2 - 72, (78/2 - 25)/2, 80, 25);
    [authCodeBtn setTitle:@"获取验证码" forState:0];
    authCodeBtn.alpha = 0.6;
    
    [authCodeBtn setBackgroundImage:imageNamed(@"login_getauthcode") forState:0];
    [authcodeInputTV addSubview:authCodeBtn];
    
    authcodeInputTV.myTextField.frame = CGRectMake(authcodeInputTV.leftName.right + 20, ZERO, authcodeInputTV.frame.size.width - 180, authcodeInputTV.frame.size.height);
    
    
    //密码
    
    passwordInputTV = [[InputTextView alloc] initWithFrame:CGRectMake((IPHONE_WIDTH - textWidth)/2, authcodeInputTV.bottom + 20, textWidth, 78/2)];
    passwordInputTV.leftName.text = @"输入密码";
    passwordInputTV.myTextField.delegate = self;
    passwordInputTV.myTextField.secureTextEntry = YES;
    [backScrollView addSubview:passwordInputTV];
    
    //确定密码
    
    surepasswordInputTV = [[InputTextView alloc] initWithFrame:CGRectMake((IPHONE_WIDTH - textWidth)/2, passwordInputTV.bottom + 20,textWidth, 78/2)];
    surepasswordInputTV.leftName.text = @"确定密码";
    surepasswordInputTV.myTextField.delegate = self;
    surepasswordInputTV.myTextField.secureTextEntry = YES;
    [backScrollView addSubview:surepasswordInputTV];
    
    //提交按钮
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提交" forState:0];
    submitBtn.backgroundColor = [UIColor blackColor];
    submitBtn.frame = CGRectMake((IPHONE_WIDTH - textWidth)/2, surepasswordInputTV.bottom + 98/2, textWidth, 78/2);
    submitBtn.tag = 1000;
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:submitBtn];
    
    backScrollView.contentSize = CGSizeMake(IPHONE_WIDTH, goBackBtn.bottom+20.0);

}

#pragma mark --- 确认方法 ---

- (void)submit:(UIButton *)sender{
    
}



@end
