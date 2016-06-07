//
//  JCShare.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//




extern NSString *const QQ_key;
extern NSString *const Weixin_key;

typedef NS_ENUM(NSUInteger, JCShareType) {
    JCShareTypeWXFriend,
    JCShareTypeWXZone,
    JCShareTypeQQFriend,
    JCShareTypeQQZone,
};



#import <Foundation/Foundation.h>
#import <OpenShare/OpenShare.h>
@interface JCShare : NSObject

///不说，你都懂
+(void)showTitle:(NSString *)title desc:(NSString *)desc image:(id )image link:(NSString *)link Success:(shareSuccess)success Fail:(shareFail)fail;


/**
 *  注册分享   到AppDelegate中的application:didFinishLaunchingWithOptions:
 */
+(void)registWithShare;

/**
 *  回调   //如果OpenShare能处理这个回调，就调用block中的方法，如果不能处理，就交给其他（比如支付宝）。
 *
 *  @param url
 *
 *  @return YES
 */
+(BOOL)handleOpenURL:(NSURL *)url;
@end
