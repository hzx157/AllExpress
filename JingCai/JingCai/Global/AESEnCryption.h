//
//  AESEnCryption.h
//  XSContact
//
//  Created by Martin on 14-11-12.
//  Copyright (c) 2014年 Seeds. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSData *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSData *)key;   //解密
- (NSString *)AnewStringInBase64FromData;            //追加64编码
+ (NSString*)Abase64encode:(NSString*)str;           //同上64编码

@end