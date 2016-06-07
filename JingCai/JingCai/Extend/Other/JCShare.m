//
//  JCShare.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//


 NSString *const QQ_key = @"1105346925";
 NSString *const Weixin_key = @"wx8b126a1b01ca7295";

#import "JCShare.h"
#import <OpenShare/OpenShare+QQ.h>
#import <OpenShare/OpenShare+Weixin.h>
#import "WXApi.h"
@implementation JCShare



+(void)showTitle:(NSString *)title desc:(NSString *)desc image:(id )image link:(NSString *)link Success:(shareSuccess)success Fail:(shareFail)fail{


    
    OSMessage *message = [[OSMessage alloc]init];
    message.title = title;
    message.link = [Common getNULLString:link];
    message.desc = [Common getNULLString:desc];
    
    if(message.desc.length<=0){
     
         message.desc = @"来自晶彩形象";
    }
    if(message.title.length<=0){
      message.title = @"来自晶彩形象的分享";
    }
    if(message.link.length<=0){
       message.link = @"https://www.pgyer.com/jingcai";
    }
    
    NSData *data;
    if(!image){
        image = imageNamed(@"Icon");
    }
    
    if([image isKindOfClass:[UIImage class]]){
        data = UIImageJPEGRepresentation(image, 0.7);
    }else if([image isKindOfClass:[NSString class]]){
        data = [NSData dataWithContentsOfURL:urlNamed([image stringByAppendingString:@"?imageView2/1/w/200/h/200"])];
    }
    message.image = data;
    message.multimediaType = OSMultimediaTypeNews;
    
    
    
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"分享" message:@"选择分享平台" preferredStyle:UIAlertControllerStyleActionSheet];
    [[Common shareAppDelegate].window.rootViewController presentViewController:alertView animated:YES completion:nil];
    UIAlertAction *wx_friend = [UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self actionPush:message type:JCShareTypeWXFriend Success:success Fail:fail];
    }];
    UIAlertAction *wx_Zone = [UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self actionPush:message type:JCShareTypeWXZone Success:success Fail:fail];

    }];
   
    UIAlertAction *qq_friend = [UIAlertAction actionWithTitle:@"QQ好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self actionPush:message type:JCShareTypeQQFriend Success:success Fail:fail];

    }];
    UIAlertAction *qq_zone = [UIAlertAction actionWithTitle:@"QQ空间" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self actionPush:message type:JCShareTypeQQZone Success:success Fail:fail];

    }];
    UIAlertAction *canel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //[alertView dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    
    [alertView addAction:wx_friend];
    [alertView addAction:wx_Zone];
    [alertView addAction:qq_friend];
    [alertView addAction:qq_zone];
    [alertView addAction:canel];
    
}
+(void)actionPush:(OSMessage *)message type:(JCShareType)type Success:(shareSuccess)success Fail:(shareFail)fail{
   
    switch (type) {
        case JCShareTypeWXFriend:
        {
            [OpenShare shareToWeixinSession:message Success:success Fail:fail];
        
        }
            break;
        case JCShareTypeWXZone:
        {
            
            [OpenShare shareToWeixinTimeline:message Success:success Fail:fail];
            
            
        }
            break;
        case JCShareTypeQQFriend:
        {
            [OpenShare shareToQQFriends:message Success:success Fail:fail];
            
        }
            break;
        case JCShareTypeQQZone:
        {
            [OpenShare shareToQQZone:message Success:success Fail:fail];
            
        }
            break;
            
        default:
            break;
    }
    
  
}



+(void)registWithShare{
    [OpenShare connectQQWithAppId:QQ_key];
    [OpenShare connectWeixinWithAppId:Weixin_key];
    //向微信注册wxd930ea5d5a258f4f
    [WXApi registerApp:@"wx8b126a1b01ca7295" withDescription:@"jingcai"];

}
+(BOOL)handleOpenURL:(NSURL *)url{
 
    return [OpenShare handleOpenURL:url];
    
}
@end
