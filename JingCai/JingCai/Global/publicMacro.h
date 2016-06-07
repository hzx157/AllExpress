//
//  publicMacro.h
//  WuFamily
//
//  Created by xiaowuxiaowu on 15/6/17.
//  Copyright (c) 2015年 xiaowuxiaowu. All rights reserved.
//
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)  //iPhone5
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)  //iPhone6
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)  //iPhone6Plus

#define IOS7_TOP_Y ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 64 :0)//判断是IOS7 系统对应的视图起点
#define IOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) // 判断是否是IOS6的系统
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) // 判断是否是IOS7的系统
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) // 判断是否是IOS8的系统
#define IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) // 判断是否是IOS8的系统


//宽度固定为200px，高度等比缩小，生成200x133缩略图：
#define UrlNamed_qiuniu_image2(url,w_h,size)  [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/%@/%d",url,w_h,size]]//?imageView2/2/w/200

//裁剪正中部分，等比缩小生成200x200缩略图：
#define UrlNamed_qiuniu_image1(url,w,h)  [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/%d/h/%d",url,w,h]]//?imageView2/2/w/200
#define imageNamed(image) [UIImage imageNamed:image]
#define urlNamed(url)    [NSURL URLWithString:url]
#define defaultLogo imageNamed(@"ic_normal_loading")
#define defaultUrl urlNamed(@"http://p2.so.qhimg.com/t01d46ca16274f485b2.jpg")

#define WEAKSELF typeof(self) __weak weakSelf = self

#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf

#define hzx_STRETCH_IMAGE(image, edgeInsets) ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0 ? [image stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top] : [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch])  //对图片拉伸处理

#define TabBarHeight 49

#define IPHONE_HEIGHT [UIScreen mainScreen].bounds.size.height //动态获取设备高度
#define IPHONE_WIDTH [UIScreen mainScreen].bounds.size.width //动态获取设备宽度

#define ZERO 0

#define HeightScaleSize(x) ((IPHONE_HEIGHT/480.0)*x)  //按高度比例缩放  以4为准
#define WidthScaleSize(x) (((x)/320.0)*MIN(IPHONE_WIDTH, IPHONE_HEIGHT))  //按宽带比例缩放 4为准


#define SizeScale_Height(x) ((x/667.0)*IPHONE_HEIGHT) //高度比例 以6为准
#define SizeScale_Width(x)  ((x/375.0)*IPHONE_WIDTH) //宽度比例 以6为准

#define SINGLE [Single shareSingle] //单例

// log

#define APP_Log(...) NSLog(__VA_ARGS__)


//动态Get方法
#define categoryPropertyGet(property)  objc_getAssociatedObject(self,@#property);
//动态Set方法
#define categoryPropertySet(property) objc_setAssociatedObject(self,@#property, property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

#define IS_IPHONE_6P ( IPHONE_WIDTH == 414.0?1:0)

#define plusSize(x) x*1.1
#define fontBlodSystemOfSize(size)  [UIFont boldSystemFontOfSize:iPhone6Plus ? plusSize(size) : size]
#define systemOfSize(size1)  iPhone6Plus ? plusSize(size1) : size1

#define fontSystemOfSize(size)  [UIFont systemFontOfSize:iPhone6Plus ? plusSize(size) : size]


#define PostMoneyNumberChanged [[NSNotificationCenter defaultCenter]postNotificationName:MoneyNumberChanged object:nil];


#ifdef DEBUG
#    define DLog(g,...) NSLog(@"<%d> %s \n" g, __LINE__, __FUNCTION__, ##__VA_ARGS__)
#else
#    define DLog(g,...) /* */
#endif
