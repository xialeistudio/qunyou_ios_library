//
//  HttpUtil.h
//  IOS
//
//  Created by xialeistudio on 15/11/30.
//  Copyright © 2015年 Group Friend Information. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class AFHTTPRequestOperationManager;
@class AFHTTPRequestOperation;

@interface HttpUtil : NSObject
@property(nonatomic, assign) NSString *api;
@property(nonatomic, assign) float timeout;

/**
 * 单例
 */
+ (instancetype)sharedInstance;

/**
 * 获取网络状态
 */
-(AFNetworkReachabilityStatus)getNetworkStatus;
/**
 * 监听网络状况
 */
-(void)listenNetwork:(void(^)(AFNetworkReachabilityStatus))callback;
/**
 * 获取默认manager
 */
- (AFHTTPRequestOperationManager *)getDefaultHttpManager;

/**
 * GET请求
 */
- (void)getRequest:(NSString *)url
        withParams:(NSDictionary *)params
   successCallback:(void (^)(AFHTTPRequestOperation *, id))successCallback
     errorCallback:(void (^)(AFHTTPRequestOperation *, NSError *))errorCallback
        withManager:(AFHTTPRequestOperationManager *)manager;

/**
 * POST请求
 */
- (void)postRequest:(NSString *)url
         withParams:(NSDictionary *)params
    successCallback:(void (^)(AFHTTPRequestOperation *, id))successCallback
      errorCallback:(void (^)(AFHTTPRequestOperation *, NSError *))errorCallback
        withManager:(AFHTTPRequestOperationManager *)manager;

/**
 * 上传请求
 * @param fileName 上传文件域名称
 * @param filePath 本地文件路径
 */
- (void)uploadRequest:(NSString *)url
           withParams:(NSDictionary *)params
        withFieldName:(NSString *)fileName
         withFilePath:(NSString *)filePath
      successCallback:(void (^)(AFHTTPRequestOperation *, id))successCallback
        errorCallback:(void (^)(AFHTTPRequestOperation *, NSError *))errorCallback
     progressCallback:(void (^)(long, long))progressCallback
          withManager:(AFHTTPRequestOperationManager *)manager;

/**
 * 下载请求
 * @param filePath 本地文件路径
 */
- (void)downloadRequest:(NSString *)url
             withParams:(NSDictionary *)params
          withLocalPath:(NSString *)filePath
        successCallback:(void (^)(AFHTTPRequestOperation *, id))successCallback
          errorCallback:(void (^)(AFHTTPRequestOperation *, NSError *))errorCallback
       progressCallback:(void (^)(long, long))progressCallback;

/**
 * 保存Cookies
 */
- (void)storeCookies;

/**
 * 加载Cookies
 */
- (void)loadCookies;

/**
 * 清空cookies
 */
-(void)cleanCookies;
@end
