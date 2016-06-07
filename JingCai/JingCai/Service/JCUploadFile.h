//
//  JCUploadFile.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QiniuUploader.h"

extern NSString *const kQiniuUrl;

@interface JCUploadFile : NSObject


+(JCUploadFile *)shareUploadFile;

+(NSString *)getUrl:(NSString *)key;
-(void)putData:(NSData *)data
           key:(NSString *)key
 fileSucceeded:(UploadOneFileSucceededBlock)succeededBlock fileSucceeded:(UploadOneFileFailedBlock)failedBlock uploadOneFileProgressBlock:(UploadOneFileProgressBlock)progressBlock;

@end


