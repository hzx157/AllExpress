//
//  JCRSA.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCRSA : NSObject
// return base64 encoded string
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
// return raw data
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;
// TODO:
//+ (NSString *)encryptString:(NSString *)str privateKey:(NSString *)privKey;
//+ (NSData *)encryptData:(NSData *)data privateKey:(NSString *)privKey;

// decrypt base64 encoded string, convert result to string(not base64 encoded)
+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;
// TODO:
//+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
//+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;

#pragma mark ----------------------- 为内容进行加密 ----------------------------
+(NSDictionary *)aes:(NSDictionary *)dic;
#pragma mark ----------------------- 为内容进行解密 ----------------------------
+(NSDictionary *)unAes:(NSString *)paramStr;

@end
