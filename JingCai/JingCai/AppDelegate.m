//
//  AppDelegate.m
//  JingCai
//
//  Created by apple on 16/5/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "JCShare.h"
#import "LoginViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UIAlertView+Block.h"
#import "WeiXinHelper.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setupNav];
    //启动键盘管理
    [self keyBoardManager];
    [JCShare registWithShare];
    [self login];
    [self netWork];
    [self update];
    

  
    return YES;
}
-(void)setupNav{
    [[UINavigationBar appearance] setBackgroundImage:imageNamed(@"nav_backcolor") forBarMetrics:UIBarMetricsDefault];
    CGRect rect = CGRectMake(0, 0, IPHONE_WIDTH, 0.5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,RGB(201, 201, 202).CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [UINavigationBar appearance].shadowImage= img;
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}
-(void)update{
    
    NSString *currentVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    
    [[RequestClient sharedClient]other_post:@"http://www.pgyer.com/apiv1/app/getAppKeyByShortcut" parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"jingcai",@"shortcut",@"2fe362f8d39bc2d770899ae00598470a",@"_api_key", nil] progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        
      
        if (![currentVersion isEqualToString:[responseObject[@"data"] objectForKey:@"appVersion"]]) {
            
            [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=https://www.pgyer.com/app/plist/%@",responseObject[@"data"][@"appKey"]]]];
            } title:@"提示" message:@"检测有新版本更新" cancelButtonName:@"确定" otherButtonTitles:nil, nil];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        ;
    }];
    
    /*
    NSDictionary *duct = @{@"aKey":@"974a7664abb2cd55241b930b52e33bb5",
                           @"uKey":@"a1a43f7dd92d1fb80efb4f04dfc7bae2",
                           @"_api_key":@"2fe362f8d39bc2d770899ae00598470a"};
   [[RequestClient sharedClient]other_post:@"http://www.pgyer.com/apiv1/app/view" parameters:duct progress:^(NSProgress * _Nonnull uploadProgress) {
       ;
   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
       
       
       DLog(@"2fe362f8d39bc2d770899ae00598470a = %@",responseObject);
    
       if([responseObject[@"data"][@"appIsLastest"] length] > 0)
       if([responseObject[@"data"][@"appIsLastest"] integerValue] == 1){
           
           [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://www.pgyer.com/app/plist/974a7664abb2cd55241b930b52e33bb5"]];
           } title:@"提示" message:@"检测有新版本更新" cancelButtonName:@"确定" otherButtonTitles:nil, nil];
           //itms-services://?action=download-manifest&url=https%3A%2F%2Fwww.pgyer.com%2Fapiv1%2Fapp%2Fplist%3FaId%3D13eff2095fa31dfffe8e272677e49fea%26_api_key%3D2fe362f8d39bc2d770899ae00598470a
     
       }
       
       
   } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
       ;
   }];
     */
}
-(void)login{
    
    //获取本地数据
    [[LoginModel shareLogin] getLoginModel];
     SINGLE.moneyModel = [MoneyModel searchSingleWithWhere:@"" orderBy:@""];
    if([LoginModel shareLogin].userId == 0){
        
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
      
        
    }else{
        [[RequestClient sharedClient]user_get_info_progress:/*login_login_loginName:[LoginModel shareLogin].phone userPsw:[LoginModel shareLogin].pass */^(NSProgress *uploadProgress) {
            ;
        } success:^(NSURLSessionDataTask *task, id responseObject, JCRespone *respone) {
            
            LoginModel *model = [LoginModel mj_objectWithKeyValues:respone.data];
            [model save];
            [[LoginModel shareLogin]getLoginModel];
            SINGLE.isLogin = YES;
            //更新余额
            [Single updateWithMoneyModel];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error, JCRespone *respone) {
            
            
            [UIView show_fail_progress:respone.msg];
           
        }];
        
    }
    
  
    
    
}
-(void)netWork{

    //监听网络状态
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        SINGLE.networkStatus = (HzxNetworkReachabilityStatus)status;
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
           
                
            }
                break;
            case   AFNetworkReachabilityStatusNotReachable: {
                
                [[[UIAlertView alloc]initWithTitle:@"网络不稳定,请检查" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
                break;
            default:
               
                
                break;
                
        }
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
//  return [JCShare handleOpenURL:url];
//}


-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
   
    return [JCShare handleOpenURL:url];
}


#ifdef __IPHONE_9_0
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      DLog(@"result = %@",resultDic);
                                                      [UIView dismiss_progress];
                                                  }]; }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            DLog(@"result = %@",resultDic);
             [UIView dismiss_progress];
        }];
    }
    
    
    
    
    return [JCShare handleOpenURL:url];
}
#else
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    

    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      DLog(@"result = %@",resultDic);
                                                       [UIView dismiss_progress];
                                                  }]; }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            DLog(@"result = %@",resultDic);
             [UIView dismiss_progress];
        }];
    }
    

    
    return [JCShare handleOpenURL:url];
    
}
#endif

//键盘管理

-(void)keyBoardManager{
    
    //启用键盘
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
    
    //启用autoToolbar行为。如果它被设置为NO。你必须手动创建UIToolbar键盘。
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    //设置工具栏IQAutoToolbarBySubviews行为。将其设置为IQAutoToolbarByTag管理上一页/下一页根据UITextField标签属性增加订单。
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    //给权限修改TextView的框架
    [[IQKeyboardManager sharedManager] setCanAdjustTextView:YES];
}

-(void)keyHideBoardManager
{
    //启用键盘
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    //Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    //给权限修改TextView的框架
    [[IQKeyboardManager sharedManager] setCanAdjustTextView:NO];
}

@end
