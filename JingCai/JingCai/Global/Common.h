//
//  Common.h
//  WuFamily
//
//  Created by xiaowuxiaowu on 15/6/17.
//  Copyright (c) 2015年 xiaowuxiaowu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Common : NSObject

//验证邮箱的合法性
+(BOOL)isValidateEmail:(NSString *)email;
+(BOOL)validateEmail:(NSString*)email;

//身份证
-(BOOL)chk18PaperId:(NSString *) sPaperId;

-(NSString *)getStringWithRange:(NSString *)str Value1:(int )value1 Value2:(NSInteger )value2;


+(AppDelegate*)shareAppDelegate;
//检查是否为空
+(NSString*)getParseString:(NSObject*)obj;
+(NSString*)getNULLString:(NSObject*)obj;

//创建文件并返回文件路径





+(NSString*)writeDocumentCreatePath:(NSString*)dir fileName:(NSString*)name;
+(NSString*)getDocumentPath:(NSString*)dir :(NSString*)name;
+(NSString*)getTempPath:(NSString*)dir :(NSString*)name;

//获取Documents文件目录
+(NSString*)GetDocumentFilePath:(NSString*)_documentName;
//获取Documents文件目录
+(NSString*)GetDocumentFilePath;

//检查文件是否存在, 然后删除文件
+(void)DocumentFileExistsAtPathDeletFile:(NSString *)_path;

//判断路径或者文件是否存在
+(BOOL)isExistWithPath:(NSString *)path;
//获取本定下载的视频文件
+(NSMutableArray *)getDocumentAllVideoFile;
//获取本地视频的缩略图
+(UIImage *)getImage:(NSString *)videoURL;
+(BOOL)isLogin;


+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label;

//获取不同高度
+(float)heightForText:(NSString *)value width:(float)width fontHeight:(float)height;
+(float)heightForText:(NSString *)value width:(float)width font:(UIFont *)font;
+(CGSize)heightForText:(NSString *)value size:(CGSize )width font:(UIFont *)font;
+(time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue;
/*****
 2011.09.15
 创建： shen
 MD5 加密
 *****/
+(NSString *)compareCurrentTime:(NSDate*) compareDate;
+(NSString *) md5: (NSString *) inPutText ;
+ (NSString *)encrypt:(NSString *)sText key:(NSString *)key;// DES加密 ：用CCCrypt函数加密一下，然后用base64编码



+(NSMutableArray *)getDocumentAllMusicFile;//获取本定下载的音频文件
+(UIImage *)getDocumentImageFormPath:(NSString*)_path;//获取本地的图片。

+ (UIColor *)getColor:(NSString *)hexColor;

+ (void)printfRect:(CGRect)rect;
+(void)ShowDialogInfo:(NSString*)title info:(NSString*)info delegate:(id)delegate;// 删除沙盒里的文件
+(void)deleteFile:(NSString*)fileName;


//电话
+(BOOL)isMobileNumber:(NSString *)mobileNum;


//模糊效果
+(UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

#pragma mark - 将View 转image
+ (UIImage *)imageFromView:(UIView *)theView;

+(void)getPhoneNuber:(NSString *)phone view:(UIView *)view;
//获取星期
+(NSString *)getWeekday;



@end
