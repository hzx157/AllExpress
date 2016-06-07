//
//  APIRequestClient.h
//  XWKit
//
//  Created by xiaowuxiaowu on 16/3/26.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "ApiServer.h"
@class JCRespone;
NS_ASSUME_NONNULL_BEGIN
typedef void(^successBlock)(NSURLSessionDataTask *task, id responseObject,JCRespone *respone);
typedef void(^failureBlock)(NSURLSessionDataTask *task, NSError *error,JCRespone *respone);


@interface APIRequestClient : NSObject

@property (nonatomic,strong)NSURLSessionDataTask *dataTask;
@property (nonatomic,strong)NSURLSessionDownloadTask *downLoadTask;
@property (nonatomic,strong)AFHTTPSessionManager *httpManager;
//+(instancetype)sharedClient;



/*  POST 请求
 *  urlString  url
 *  parameters 字典
 *
 */
-(void)POST:(NSString * )urlString parameters:(id)parameters
      progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
     success:(successBlock)success
     failure:(failureBlock)failure;

-(void)other_post:(NSString * )urlString parameters:( id)parameters
         progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
          success:(successBlock)success
          failure:(failureBlock)failure;

/*  下载
 *  urlString  url
 *  filePath 下载路径
 *
 */
- (void)downloadTaskWithUrl:(NSString *)urlString
                   progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
          completionHandler:(void (^)(NSURLResponse *response, NSURL * filePath, NSError *  error))completionHandler;


/*  上传
 *  urlString  url
 *  fileURL 上传路径
 *
 */

- (NSURLSessionUploadTask *)uploadTaskWithUrlString:(NSString *)urlString parameters:( id)parameters  mimeType:(NSString *)mimeType sourceData:(NSData*)sourceData
                                           progress:(void (^)(NSProgress * downloadProgress)) downloadProgressBlock
                                  completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

//-(void)uploadTaskWithStreamedRequest;

@end


@interface JCRespone : NSObject
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSString * msg;
@property (nonatomic, assign) NSInteger secret;
@property (nonatomic, assign) NSInteger time;
@end

NS_ASSUME_NONNULL_END