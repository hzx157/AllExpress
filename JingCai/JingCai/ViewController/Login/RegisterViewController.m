//
//  RegisterViewController.m
//  JingCai
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RegisterViewController.h"
#import "InputTextView.h"
#import "AutoCodeButton.h"
#import "WebViewController.h"
#import "UITapImageView.h"
#import "ScanQRCodeViewController.h"
@interface RegisterViewController (){
    UIScrollView *mainScrollView;
    UILabel *tisLabel; //
    InputTextView *telInputTV; //手机号
    InputTextView *authcodeInputTV; //验证码
    InputTextView *passwordInputTV; //密码
    InputTextView *surepasswordInputTV; //确认密码
    InputTextView *refereeCodeTV; //邀请码
    ProtocolButton *protocolBtn; //协议按钮
    UIButton *registerBtn; //注册按钮
    
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

#pragma mark -- 界面布局 ---

- (void)setup{
    
    
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
    } else{
        textWidth = IPHONE_WIDTH - 88;
        specWidth = 60;
    }
    
    //昵称
    
    tisLabel = [[UILabel alloc] initWithFrame:CGRectMake((IPHONE_WIDTH - textWidth)/2, 100 + specWidth, textWidth, 50)];
    tisLabel.text = @"用户注册";
    tisLabel.textColor = [UIColor whiteColor];
    tisLabel.textAlignment = NSTextAlignmentCenter;
    [backScrollView addSubview:tisLabel];
    
    if(self.type == RegisterViewTypeFind){
      tisLabel.text=  @"忘记密码";
    }else if (self.type == RegisterViewTypeUpdate){
      tisLabel.text=  @"修改密码";
    }
    self.title = tisLabel.text;
    
    //手机号码
    
    telInputTV = [[InputTextView alloc] initWithFrame:CGRectMake((IPHONE_WIDTH - textWidth)/2, tisLabel.bottom + 20, textWidth, 78/2)];
    telInputTV.leftName.text = @"手机号码:";
    telInputTV.myTextField.delegate = self;
    telInputTV.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    [backScrollView addSubview:telInputTV];
    
    //验证码
    authcodeInputTV = [[InputTextView alloc] initWithFrame:CGRectMake((IPHONE_WIDTH - textWidth)/2, telInputTV.bottom + 20, textWidth, 78/2)];
    authcodeInputTV.leftName.text = @"验证码:";
    authcodeInputTV.myTextField.delegate = self;
    authcodeInputTV.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    [backScrollView addSubview:authcodeInputTV];
    
    //获取验证码按钮
    AutoCodeButton *authCodeBtn = [AutoCodeButton buttonWithType:UIButtonTypeCustom];
    authCodeBtn.textField = telInputTV.myTextField;
    authCodeBtn.isReisgter = YES;
    authCodeBtn.frame = CGRectMake(authcodeInputTV.width - 34/2 - 72, (78/2 - 25)/2, 80, 25);
    [authCodeBtn setTitle:@"获取验证码" forState:0];
    [authCodeBtn setTitleColor:[UIColor grayColor] forState:0];
    authCodeBtn.alpha = 0.6;
    [authcodeInputTV addSubview:authCodeBtn];
    authcodeInputTV.myTextField.frame = CGRectMake(authcodeInputTV.leftName.right + 20, ZERO, authcodeInputTV.frame.size.width - 180, authcodeInputTV.frame.size.height);
    
    
    
    //密码
    
    passwordInputTV = [[InputTextView alloc] initWithFrame:CGRectMake((IPHONE_WIDTH - textWidth)/2, self.type == RegisterViewTypeUpdate ? telInputTV.bottom: authcodeInputTV.bottom, textWidth, 0)];
    passwordInputTV.leftName.text = @"输入密码:";
    passwordInputTV.myTextField.delegate = self;
    passwordInputTV.myTextField.secureTextEntry = YES;
    [backScrollView addSubview:passwordInputTV];
    
    //确定密码
    surepasswordInputTV = [[InputTextView alloc] initWithFrame:CGRectMake((IPHONE_WIDTH - textWidth)/2, passwordInputTV.bottom,textWidth, 0)];
    surepasswordInputTV.leftName.text = @"确定密码:";
    surepasswordInputTV.myTextField.delegate = self;
    surepasswordInputTV.myTextField.secureTextEntry = YES;
    [backScrollView addSubview:surepasswordInputTV];
    
    refereeCodeTV = [[InputTextView alloc] initWithFrame:CGRectMake((IPHONE_WIDTH - textWidth)/2, surepasswordInputTV.bottom + 20,textWidth, 78/2)];
    refereeCodeTV.leftName.text = @"邀请码:";
    refereeCodeTV.myTextField.rightViewMode = UITextFieldViewModeAlways;
    UITapImageView *imageView = [[UITapImageView alloc]initWithImage:imageNamed(@"login_qrcode")];
    WEAKSELF;
    [imageView addTapBlock:^(id obj){
        [weakSelf scan];
    }];
    imageView.frame = CGRectMake(0, 0, 40.0, refereeCodeTV.height);
    refereeCodeTV.myTextField.rightView = imageView;
    
    refereeCodeTV.myTextField.delegate = self;
    refereeCodeTV.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    [backScrollView addSubview:refereeCodeTV];
    
    
    //同意协议按钮
    
    protocolBtn = [ProtocolButton buttonWithType:UIButtonTypeCustom];
    [protocolBtn setImage:imageNamed(@"login_agree_icon") forState:0];
    protocolBtn.tag = 1003;
    protocolBtn.selected = YES;
    [protocolBtn setImage:imageNamed(@"login_agree_icon") forState:UIControlStateSelected];
    [backScrollView addSubview:protocolBtn];
    
    UIButton *protocolContentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [protocolContentBtn setTitle:@"我已阅读并同意《用户协议》" forState:0];
    protocolContentBtn.tag = 1004;
    [protocolContentBtn setTitleColor:ColorWithRGB(65, 135, 250, 1) forState:0];
    protocolContentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [protocolContentBtn addTarget:self action:@selector(protcol:) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:protocolContentBtn];
    
    if(self.type != RegisterViewTypeRegist){
       refereeCodeTV.height = 0.0f;
        refereeCodeTV.top = surepasswordInputTV.bottom;
        refereeCodeTV.hidden = YES;
    }
    
    protocolBtn.frame = CGRectMake(telInputTV.left, refereeCodeTV.bottom, 20, 20);
    protocolContentBtn.frame = CGRectMake(protocolBtn.right+5, protocolBtn.top+12, protocolContentBtn.currentTitle.length * 14 , 20);
    
  
    

    //提交按钮
    registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitle:@"确定" forState:0];
    registerBtn.backgroundColor = [UIColor blackColor];
    registerBtn.frame = CGRectMake((IPHONE_WIDTH - textWidth)/2, protocolBtn.bottom + 40 , textWidth, 78/2);
    registerBtn.tag = 1000;
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 4.0f;
    [registerBtn addTarget:self action:@selector(handleResigter:) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:registerBtn];
    backScrollView.contentSize = CGSizeMake(IPHONE_WIDTH, registerBtn.bottom+20.0);
    
    
    if(self.type == RegisterViewTypeUpdate){ //更新密码
     
        protocolContentBtn.hidden = protocolBtn.hidden = YES;
        authCodeBtn.hidden = authcodeInputTV.hidden = YES;
        
    }else if (self.type == RegisterViewTypeFind){
    
        protocolContentBtn.hidden = protocolBtn.hidden = YES;
        
    }else{
    
        
    }
    
}

-(void)scan{
 
    ScanQRCodeViewController *scan = [ScanQRCodeViewController new];
    [scan setBlock:^(id obj) {
        
        if([obj isKindOfClass:[NSString class]]){
            refereeCodeTV.myTextField.text = obj;
        }else
        refereeCodeTV.myTextField.text = obj[@"value"];
        
    }];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:scan] animated:YES completion:nil];
}
#pragma mark --- 注册 ---

- (void)handleResigter:(UIButton *)sender{
    
    if([self isLogin]){
    
        [self getData];
    }
    
}



#pragma mark --- 协议 ---

- (void)protcol:(UIButton *)sender{
    
    WebViewController *webView = [[WebViewController alloc]init];
    webView.title = sender.titleLabel.text;
    webView.urlstr = @"http://www.coohua.cn/terms.html";
    [self.navigationController pushViewController:webView animated:YES];
//    [WebViewController]
}

- (BOOL)isLogin
{
    if(telInputTV.myTextField.text.length <= 0){
        [UIView show_fail_progress:@"请输入手机号码"];
        return NO;
    }
    /*
    if(passwordInputTV.myTextField.text.length <= 0){
        [UIView show_fail_progress:@"请输入密码"];
        return NO;
    }
    if(![passwordInputTV.myTextField.text isEqualToString:surepasswordInputTV.myTextField.text]){
        [UIView show_fail_progress:@"两次密码输入不同"];
        return NO;
    }
    
    if(self.type == RegisterViewTypeUpdate){
        
        if(![telInputTV.myTextField.text isEqualToString:[LoginModel shareLogin].phone]){
           [UIView show_fail_progress:@"手机号码输入不正确"];
            return NO;
        }
        
        return YES;
    }
    */
    if(authcodeInputTV.myTextField.text.length <= 0){
        [UIView show_fail_progress:@"请输入验证码"];
        return NO;
    }
    
    return YES;
}
-(void)getData{


    
    if(self.type == RegisterViewTypeUpdate){
        [UIView show_loading_progress_HUDMaskType:@"更新中..."];
        [[RequestClient sharedClient]login_update_userPsw :passwordInputTV.myTextField.text  progress:^(NSProgress *uploadProgress) {
            ;
        } success:^(NSURLSessionDataTask *task, id responseObject, JCRespone *respone) {
            
            [UIView show_success_progress:@"更新密码成功"];
            [[NSUserDefaults standardUserDefaults]setObject:telInputTV.myTextField.text forKey:@"tel"];
            [[NSUserDefaults standardUserDefaults]setObject:passwordInputTV.myTextField.text forKey:@"pwd"];
            [self leftBtnAction:nil];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error, JCRespone *respone) {
            [UIView show_success_progress:respone.msg];
        }];
        return;
    }
 
    if(self.type == RegisterViewTypeFind){
           [UIView show_loading_progress_HUDMaskType:@"找回中..."];
        [[RequestClient sharedClient]login_find_loginName:telInputTV.myTextField.text valicode:authcodeInputTV.myTextField.text userPsw:passwordInputTV.myTextField.text progress:^(NSProgress *uploadProgress) {
            ;
        } success:^(NSURLSessionDataTask *task, id responseObject, JCRespone *respone) {
            
            [UIView show_success_progress:@"找回密码成功"];
            [[NSUserDefaults standardUserDefaults]setObject:telInputTV.myTextField.text forKey:@"tel"];
            [[NSUserDefaults standardUserDefaults]setObject:passwordInputTV.myTextField.text forKey:@"pwd"];
            [self leftBtnAction:nil];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error, JCRespone *respone) {
            [UIView show_success_progress:respone.msg];
        }];
        return;
    }
    
    
        [UIView show_loading_progress_HUDMaskType:@"注册中..."];
     [[RequestClient sharedClient]login_register_loginName:telInputTV.myTextField.text valicode:authcodeInputTV.myTextField.text userPsw:passwordInputTV.myTextField.text refereeCode:refereeCodeTV.myTextField.text progress:^(NSProgress *uploadProgress) {
         ;
     } success:^(NSURLSessionDataTask *task, id responseObject, JCRespone *respone) {
         
     
         [UIView show_success_progress:@"注册成功"];
         [[NSUserDefaults standardUserDefaults]setObject:telInputTV.myTextField.text forKey:@"tel"];
         [[NSUserDefaults standardUserDefaults]setObject:passwordInputTV.myTextField.text forKey:@"pwd"];
         if(self.block)
             self.block(authcodeInputTV.myTextField.text);
         [self leftBtnAction:nil];
         
         
     } failure:^(NSURLSessionDataTask *task, NSError *error, JCRespone *respone) {
         [UIView show_success_progress:respone.msg];
     }];
    
    
  

    
}


@end

//协议按钮

@implementation ProtocolButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake((contentRect.size.width - 15)/2, 15, 15, 15);
}


@end
