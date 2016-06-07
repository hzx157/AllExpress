//
//  JCUploadFile.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

NSString *const kQiniuUrl = @"http://o7a0htelu.bkt.clouddn.com";
#import "JCUploadFile.h"

#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "QiniuUploader.h"

#define AK @"gyV9I9t1FmJMlCaSTKH8MTze-JKobQd7OZjqYigB"
#define SK @"GH1J95ptGOFgx1XH0FAjYZEOXgYXG6rwu-6V8spU"
#define KscopeName @"jingcai"
@interface JCUploadFile()

@property (nonatomic,copy)NSString *token;
@end

@implementation JCUploadFile

+(JCUploadFile *)shareUploadFile{

    static JCUploadFile *model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[JCUploadFile alloc]init];
        [model setup];
    });
    return model;
}
-(void)setup{
    
   [QiniuToken registerWithScope:@"jingcai" SecretKey:@"GH1J95ptGOFgx1XH0FAjYZEOXgYXG6rwu-6V8spU" Accesskey:@"gyV9I9t1FmJMlCaSTKH8MTze-JKobQd7OZjqYigB"];

}
+(NSString *)getUrl:(NSString *)key{
  
    return [NSString stringWithFormat:@"%@/%@",kQiniuUrl,key];
}

-(void)putData:(NSData *)data
            key:(NSString *)key
       fileSucceeded:(UploadOneFileSucceededBlock)succeededBlock fileSucceeded:(UploadOneFileFailedBlock)failedBlock uploadOneFileProgressBlock:(UploadOneFileProgressBlock)progressBlock{
  
    
    QiniuFile *file = [[QiniuFile alloc] initWithFileData:data];
    file.key = key;
    
    //startUpload
    QiniuUploader *uploader = [[QiniuUploader alloc] init];
    [uploader addFile:file];
    
     [uploader startUpload];
    [uploader setUploadOneFileSucceeded:succeededBlock];
    
    [uploader setUploadOneFileProgress:progressBlock];
  
    [uploader setUploadOneFileFailed:failedBlock];
    
}

@end


