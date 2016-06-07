////
////  CXWebService.h
////  JingCai
////
////  Created by apple on 16/5/5.
////  Copyright © 2016年 apple. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//
//extern NSString * const CXWebServiceAppHost;
//
//extern NSString * const CXWebServiceResponseCodeSuccess;
//
//extern NSString * const CXWebServiceAccessTokenInvalidNotificationName;
//
//@class AFHTTPRequestOperation;
//
//#pragma mark - GOUploadFileInfo
//
//typedef NS_ENUM(NSUInteger,CXUploadFileType)
//{
//    CXUploadFileTypeImage = 1,
//    CXUploadFileTypeVideo = 2,
//    CXUploadFileTypeAudio = 3,
//    CXUploadFileTypeHolder= 4,
//};
//
//
//@interface CXWebService : NSObject
//
//@property (nonatomic,copy) NSString *localPath;
//@property (nonatomic,copy) NSString *fileName;
//@property (nonatomic,copy) NSString *mimeType;
//
//@property (nonatomic,readonly) NSData *data;
//@property (nonatomic,readonly) CXUploadFileType type;
//@property (nonatomic,readonly) NSString *key;
//@property (nonatomic,readonly) NSString *remotePath;
//@property (nonatomic,copy) NSDictionary *extInfo;
//@property (nonatomic,copy) NSString *urlKey;
//
//+ (instancetype)uploadFileWihType:(CXUploadFileType)type data:(NSData *)data key:(NSString *)key;
//
//@end
//
//#pragma mark - GOWebServiceResponse
//
/////接口响应类
//@interface CXWebServiceResponse : MTLModel<MTLJSONSerializing>
//
/////响应代码(code)
//@property (nonatomic,copy) NSString *code;
/////响应数据(data)
//@property (nonatomic,strong) id data;
/////响应消息(msg)
//@property (nonatomic,copy) NSString *msg;
//
/////接口是否正常返回数据
//@property (nonatomic,readonly) BOOL success;
//
//@end
//
//#pragma mark - GCWebService
//
///**
// *  调用接口成功回调
// *
// *  @param operation 请求操作对象
// *  @param response  响应对象
// */
//typedef void(^ GOWebServiceSuccessCallBack)(AFHTTPRequestOperation *operation,CXWebServiceResponse *response);
//
///**
// *  调用接口失败回调
// *
// *  @param operation 请求操作对象
// *  @param error     错误对象
// */
//typedef void(^ GOWebServiceFailureCallBack)(AFHTTPRequestOperation *operation,NSError *error);
//
//
//@interface CXWebService : NSObject
//
//@property (nonatomic,copy) NSString *userAgent;
//
///**
// *  获取接口调用对象单例
// *
// *  @return 接口调用对象单例
// */
//+ (instancetype)service;
//
//- (void)postAction:(NSString *)action
//            params:(NSDictionary *)params
//           success:(GOWebServiceSuccessCallBack)successCallBack
//           failure:(GOWebServiceFailureCallBack)failureCallBack;
//
//- (void)postAction:(NSString *)action
//            params:(NSDictionary *)params
//             files:(NSDictionary *)files
//           success:(GOWebServiceSuccessCallBack)successCallBack
//           failure:(GOWebServiceFailureCallBack)failureCallBack;
//
//- (void)postAction:(NSString *)action
//            params:(NSDictionary *)params
//              file:(CXUploadFile *)file
//           success:(GOWebServiceSuccessCallBack)successCallBack
//           failure:(GOWebServiceFailureCallBack)failureCallBack;
//
//@end
