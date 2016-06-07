//
//  LoginViewController.m
//  JingCai
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "InputTextView.h"
#import "RegisterViewController.h"
#import "FindPasswordViewController.h"
#import "ViewController.h"
#import "AutoCodeButton.h"
#import "UIAlertView+Block.h"
@interface LoginViewController (){
    InputTextView *telInputTV; //手机号
    InputTextView *passwordInputTV; //密码
    UIButton *registerBtn; //注册按钮
    UIButton *findPassworBtn; //找回密码
    UIButton *loginBtn; //登录
    UIButton *goBackBtn; //返回
    UIScrollView *backScrollView;
    id tempObject;
}
@end

@implementation LoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = COLOR_background_f1f1f1;
    [LoginModel shareLogin].token = @"";
    [self setup];
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = YES;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"tel"]){
        telInputTV.myTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"tel"];
       // passwordInputTV.myTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
 
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)setup{
    
    //背景图片
    
    
    UIImageView *backImgView = [[UIImageView alloc] initWithImage:imageNamed(@"Login_bj")];
    backImgView.frame = CGRectMake(ZERO, ZERO, IPHONE_WIDTH, IPHONE_HEIGHT);
    [self.view addSubview:backImgView];
    
    backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(ZERO, ZERO, IPHONE_WIDTH, IPHONE_HEIGHT)];
    backScrollView.userInteractionEnabled = YES;
    backScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backScrollView];
    
    CGFloat textWidth = 0;
    CGFloat specWidth = 0;
    
    if(iPhone5){
        textWidth = IPHONE_WIDTH - 44;
        specWidth = 40;
    }
    else{
        if(iPhone6){
        }
        textWidth = IPHONE_WIDTH - 88;
        specWidth = 60;
    }
    
    
    //昵称
    
    UILabel*tisLabel = [[UILabel alloc] initWithFrame:CGRectMake((IPHONE_WIDTH - textWidth)/2, 80 + specWidth, textWidth, 50)];
    tisLabel.text = @"用户登录";
    tisLabel.textColor = [UIColor whiteColor];
    tisLabel.textAlignment = NSTextAlignmentCenter;
    [backScrollView addSubview:tisLabel];
    
    
    //手机号码
    telInputTV = [[InputTextView alloc] initWithFrame:CGRectMake((IPHONE_WIDTH - textWidth)/2, 200, textWidth, 78/2)];
    telInputTV.leftName.text = @"手机号码:";
    telInputTV.myTextField.delegate = self;
    telInputTV.myTextField.keyboardType = UIKeyboardTypePhonePad;
    [backScrollView addSubview:telInputTV];
    
    //密码
    passwordInputTV = [[InputTextView alloc] initWithFrame:CGRectMake((IPHONE_WIDTH - textWidth)/2, telInputTV.bottom + 20,textWidth, 78/2)];
    passwordInputTV.leftName.text = @"验证码:";
    passwordInputTV.myTextField.delegate = self;
    passwordInputTV.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    passwordInputTV.myTextField.rightViewMode = UITextFieldViewModeAlways;
    [backScrollView addSubview:passwordInputTV];

    AutoCodeButton *authCodeBtn = [AutoCodeButton buttonWithType:UIButtonTypeCustom];
    authCodeBtn.textField = telInputTV.myTextField;
    authCodeBtn.isReisgter = YES;
    authCodeBtn.frame = CGRectMake(0, 0, 80, passwordInputTV.height);
    [authCodeBtn setTitle:@"获取验证码" forState:0];
    [authCodeBtn setTitleColor:[UIColor grayColor] forState:0];
    authCodeBtn.alpha = 0.6;
    passwordInputTV.myTextField.rightView = authCodeBtn;
    
    
    //注册
    
    registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(passwordInputTV.left + 5, passwordInputTV.bottom, 13*3, 44);
    [registerBtn setTitle:@"注册   " forState:0];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    registerBtn.alpha = 0.6;
    [registerBtn addTarget:self action:@selector(handleRegister:) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setTitleColor:COLOR_blue_00B4FF forState:0];
    [backScrollView addSubview:registerBtn];
    
    //忘记密码
    
    findPassworBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [findPassworBtn setTitle:@"找回登录手机" forState:0];
    [findPassworBtn addTarget:self action:@selector(findPassword:) forControlEvents:UIControlEventTouchUpInside];
    findPassworBtn.alpha = 0.6;
    findPassworBtn.frame = CGRectMake(passwordInputTV.right - 13*6 - 5, registerBtn.top, 13*6, 44);
    findPassworBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [findPassworBtn setTitleColor:COLOR_blue_00B4FF forState:0];
    [backScrollView addSubview:findPassworBtn];
    
    //提交按钮
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录" forState:0];
    loginBtn.frame = CGRectMake((IPHONE_WIDTH - textWidth)/2, passwordInputTV.bottom + 120/2, textWidth, 78/2);
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:0];
    loginBtn.backgroundColor = [UIColor blackColor];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 4.0f;
    [backScrollView addSubview:loginBtn];
    
  
    
}

#pragma mark --- 登录 ---

- (void)login:(UIButton *)sender{
    
    if([self isLogin])
    [self loginData];
}

#pragma mark --- 注册 ---

- (void)handleRegister:(UIButton *)sender{
    RegisterViewController*view =  [RegisterViewController new];
    view.type = RegisterViewTypeRegist;
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark --- 找回密码 ---

- (void)findPassword:(UIButton *)sender{
    
    [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        
        if(buttonIndex == 0)
            return ;
        
        [Common getPhoneNuber:@"02037033050" view:self.view];
        
        
    } title:@"确定要联系客服吗" message:nil cancelButtonName:@"取消" otherButtonTitles:@"确定", nil];
    
    return;
    
    RegisterViewController*view =  [RegisterViewController new];
    view.type = RegisterViewTypeFind;
    [view setBlock:^(NSString *code) {
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"tel"]){
            telInputTV.myTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"tel"];
            // passwordInputTV.myTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
        }
        passwordInputTV.myTextField.text = code;
        [self loginData];
        
    }];
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark --- 判断是否是可以登录 ---

- (BOOL)isLogin
{
    if(telInputTV.myTextField.text.length <= 0){
        [UIView show_fail_progress:@"请输入手机号码"];
        return NO;
    }
    if(passwordInputTV.myTextField.text.length <= 0){
        [UIView show_fail_progress:@"请输入密码"];
        return NO;
    }
    return YES;
}
-(void)loginData{
    
 
    [self.view endEditing:YES];
    self.view.userInteractionEnabled = NO;
    [loginBtn showActivityInView:CGPointMake(loginBtn.width/2 - 30, loginBtn.height/2)];
    
     [[RequestClient sharedClient]login_login_loginName:telInputTV.myTextField.text userPsw:passwordInputTV.myTextField.text progress:^(NSProgress *uploadProgress) {
         ;
     } success:^(NSURLSessionDataTask *task, id responseObject, JCRespone *respone) {
  
         [loginBtn hiddenActivityInView];
         self.view.userInteractionEnabled = YES;
         
         
         [[NSUserDefaults standardUserDefaults]setObject:telInputTV.myTextField.text forKey:@"tel"];
         [[NSUserDefaults standardUserDefaults]setObject:passwordInputTV.myTextField.text forKey:@"pwd"];
         
         
         LoginModel *model = [LoginModel mj_objectWithKeyValues:respone.data];
         model.phone = telInputTV.myTextField.text;
         model.pass = passwordInputTV.myTextField.text;
         [model save];
         [[LoginModel shareLogin]getLoginModel];
         SINGLE.isLogin = YES;
         [UIView show_success_progress:@"登录成功!"];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             
             UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             [Common shareAppDelegate].window.rootViewController = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
         });
        
         
     } failure:^(NSURLSessionDataTask *task, NSError *error, JCRespone *respone) {
         
         [UIView show_fail_progress:respone.msg];
         [loginBtn hiddenActivityInView];
         self.view.userInteractionEnabled = YES;
     }];
    

}
@end
