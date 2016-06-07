//
//  APIRequestClient.m
//  XWKit
//
//  Created by xiaowuxiaowu on 16/3/26.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//




#import "APIRequestClient.h"
#import <MJExtension/MJExtension.h>
#import "ApiServer.h"
#import "LoginViewController.h"
@implementation APIRequestClient

-(NSString *)baseUrl{
  return apiUrl;
}
//+(instancetype)sharedClient{
//
//    static APIRequestClient *client;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        client = [[APIRequestClient alloc]init];
//    });
//    
//    return client;
//}
+(AFHTTPSessionManager *)shareManager{
   static AFHTTPSessionManager *manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@""]];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
      //  manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFCompoundResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 20.0;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",@"text/json", @"text/javascript", nil];
    });
    return manager;
}

-(void)POST:(NSString * )urlString parameters:( id)parameters
          progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
           success:(successBlock)success
           failure:(failureBlock)failure{

    AFHTTPSessionManager *_manager = [APIRequestClient shareManager];
    
    if([LoginModel shareLogin].token.length >0)
    [_manager.requestSerializer setValue:[LoginModel shareLogin].token forHTTPHeaderField:@"token"];
    
    
    [_manager.requestSerializer setValue:@"1.0" forHTTPHeaderField:@"version"];
    [_manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"client"];
    DLog(@"-token=%@------------------请求连接--------------------------\n %@ \n传入字典 = %@",[LoginModel shareLogin].token,[[self baseUrl] stringByAppendingString:[NSString stringWithFormat:@"%@.json",urlString]],parameters);
    
  __block  JCRespone *respone = [[JCRespone alloc]init];
   self.dataTask = [_manager POST:[[self baseUrl] stringByAppendingString:[NSString stringWithFormat:@"%@.json",urlString]] parameters:parameters progress:uploadProgress success:^(NSURLSessionDataTask *  task, id  responseObject) {
       
       respone = [JCRespone mj_objectWithKeyValues:[responseObject mj_JSONObject]];
        DLog(@"%@",[[responseObject mj_JSONObject] mj_JSONString]);
       if([respone.code isEqualToString:@"9999999"])
          success(task,[responseObject mj_JSONObject],respone);
       else{
           if([respone.code isEqualToString:@"0000091"]){
               [Common shareAppDelegate].window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
               
           }
           
         failure(task,nil,respone);
       
       }
       
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        respone.msg = @"服务器请求超时";
         failure(task,error,respone);
        DLog(@"error = %@",error);
    }];
    
}
-(void)other_post:(NSString * )urlString parameters:( id)parameters
   progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
    success:(successBlock)success
    failure:(failureBlock)failure{
  

    AFHTTPSessionManager *_manager = [APIRequestClient shareManager];
   
    DLog(@"-------------------请求连接--------------------------\n %@ \n传入字典 = %@",urlString,parameters);
    
    
    self.dataTask = [_manager POST:urlString parameters:parameters progress:uploadProgress success:^(NSURLSessionDataTask *  task, id  responseObject) {
        
        
            success(task,[responseObject mj_JSONObject],[JCRespone new]);
       
        
        
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        
        failure(task,error,[JCRespone new]);
        DLog(@"error = %@",error);
    }];


}
- (void)downloadTaskWithUrl:(NSString *)urlString
                       progress:(void (^)(NSProgress * downloadProgress)) downloadProgressBlock
                    destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
              completionHandler:(void (^)(NSURLResponse *response, NSURL * filePath, NSError *  error))completionHandler{
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];

    NSURL *URL = [NSURL URLWithString:[[self baseUrl] stringByAppendingString:urlString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    self.downLoadTask = [manager downloadTaskWithRequest:request progress:downloadProgressBlock destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        destination(targetPath,response);
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:completionHandler];
    [_downLoadTask resume];
    

}

- (NSURLSessionUploadTask *)uploadTaskWithUrlString:(NSString *)urlString parameters:( id)parameters  mimeType:(NSString *)mimeType sourceData:(NSData*)sourceData
                   progress:(void (^)(NSProgress * downloadProgress)) downloadProgressBlock
                  completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler{
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    

    
    NSMutableURLRequest *request = [manager.requestSerializer
                                    multipartFormRequestWithMethod:@"POST"
                                    URLString:urlString
                                    parameters:parameters
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                        [formData appendPartWithFileData:sourceData name:@"file" fileName:@"file" mimeType:mimeType];
                                    } error:nil];
    
   NSURLSessionUploadTask *tak = [manager uploadTaskWithStreamedRequest:request progress:downloadProgressBlock completionHandler:completionHandler];
    [tak resume];
    
    return tak;
}

/*
-(void)uploadTaskWithUrlString:(NSString *)urlString
                    fromFile:(NSString *)fileURL
                    progress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgressBlock
           completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError  * _Nullable error,id model))completionHandler{
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:[[APIRequestClient baseUrl] stringByAppendingString:urlString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURL *filePath = [NSURL fileURLWithPath:fileURL];
    self.dataTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:uploadProgressBlock completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
        completionHandler(response,responseObject,error,responseObject);
        
    }];
    [_dataTask resume];

}
 */


@end


@implementation JCRespone


@end
