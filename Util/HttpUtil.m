//
//  HttpUtil.m
//  IOS
//
//  Created by xialeistudio on 15/11/30.
//  Copyright © 2015年 Group Friend Information. All rights reserved.
//

#import "HttpUtil.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "NSString+Compatibility.h"

@implementation HttpUtil

/**
 * 单例
 */
+ (instancetype)sharedInstance {
    static HttpUtil *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    });
    return instance;
}

- (AFNetworkReachabilityStatus)getNetworkStatus {
    __block AFNetworkReachabilityStatus status;
    [self listenNetwork:^(AFNetworkReachabilityStatus status1) {
        status = status1;
    }];
    return status;
}

- (void)listenNetwork:(void (^)(AFNetworkReachabilityStatus))callback {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:callback];
    [manager startMonitoring];
}


/**
 * Http请求
 */
- (AFHTTPRequestOperationManager *)getDefaultHttpManager {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //超时设置
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = _timeout;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager.requestSerializer setValue:_userAgent forHTTPHeaderField:@"User-Agent"];
    return manager;
}

/**
 * GET请求
 */
- (void)getRequest:(NSString *)url withParams:(NSDictionary *)params successCallback:(void (^)(AFHTTPRequestOperation *, id))successCallback errorCallback:(void (^)(AFHTTPRequestOperation *, NSError *))errorCallback withManager:(AFHTTPRequestOperationManager *)manager {
    if (![url containsStringCompatibility:@"http://"]) {
        url = [_api stringByAppendingString:url];
    }
    AFHTTPRequestOperationManager *_manager = manager == nil ? [self getDefaultHttpManager] : manager;
    [[_manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = data;
            if ([dic[@"errcode"] longValue] != 0) {
                if (errorCallback) {
                    errorCallback(operation, [NSError errorWithDomain:@"com.vikaa.qunyou" code:-1 userInfo:@{NSLocalizedDescriptionKey : dic[@"errmsg"]}]);
                }
                return;
            }
            successCallback(operation, data);
            return;
        }
        successCallback(operation, data);
    }      failure:errorCallback] start];
}

/**
 * POST请求
 */
- (void)postRequest:(NSString *)url withParams:(NSDictionary *)params successCallback:(void (^)(AFHTTPRequestOperation *, id))successCallback errorCallback:(void (^)(AFHTTPRequestOperation *, NSError *))errorCallback withManager:(AFHTTPRequestOperationManager *)manager {
    if (![url containsStringCompatibility:@"http://"]) {
        url = [_api stringByAppendingString:url];
    }
    AFHTTPRequestOperationManager *_manager = manager == nil ? [self getDefaultHttpManager] : manager;
    [[_manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = data;
            if ([dic[@"errcode"] longValue] != 0) {
                if (errorCallback) {
                    errorCallback(operation, [NSError errorWithDomain:@"com.vikaa.qunyou" code:-1 userInfo:@{NSLocalizedDescriptionKey : dic[@"errmsg"]}]);
                }
                return;
            }
            successCallback(operation, data);
            return;
        }
        successCallback(operation, data);
    }       failure:errorCallback] start];
}

/**
 * 上传请求
 */
- (void)uploadRequest:(NSString *)url withParams:(NSDictionary *)params withFieldName:(NSString *)fileName withFilePath:(NSString *)filePath successCallback:(void (^)(AFHTTPRequestOperation *, id))successCallback errorCallback:(void (^)(AFHTTPRequestOperation *, NSError *))errorCallback progressCallback:(void (^)(long, long))progressCallback withManager:(AFHTTPRequestOperationManager *)manager {
    if (![url containsStringCompatibility:@"http://"]) {
        url = [_api stringByAppendingString:url];
    }
    AFHTTPRequestOperationManager *_manager = manager == nil ? [self getDefaultHttpManager] : manager;
    AFHTTPRequestOperation *operation = [_manager POST:url parameters:params constructingBodyWithBlock:^(id <AFMultipartFormData> _Nonnull formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:fileName error:nil];
    }                                          success:successCallback failure:errorCallback];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if (progressCallback) {
            progressCallback((long) totalBytesWritten, (long) totalBytesExpectedToWrite);
        }
    }];
    [operation start];
}

/**
 * 下载请求
 */
- (void)downloadRequest:(NSString *)url withParams:(NSDictionary *)params withLocalPath:(NSString *)filePath successCallback:(void (^)(AFHTTPRequestOperation *, id))successCallback errorCallback:(void (^)(AFHTTPRequestOperation *, NSError *))errorCallback progressCallback:(void (^)(long, long))progressCallback {
    if (![url containsStringCompatibility:@"http://"]) {
        url = [_api stringByAppendingString:url];
    }
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [serializer requestWithMethod:@"GET" URLString:url parameters:params error:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:filePath append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (progressCallback) {
            progressCallback((long) totalBytesRead, (long) totalBytesExpectedToRead);
        }
    }];
    [operation setCompletionBlockWithSuccess:successCallback failure:errorCallback];
    [operation start];
}

/**
 * 保存Cookies
 */
- (void)storeCookies {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:_api]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"app.cookies"];
}

/**
 * 加载Cookies
 */
- (void)loadCookies {
    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"app.cookies"];
    if ([data length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
}

- (void)cleanCookies {
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [NSArray arrayWithArray:[cookieJar cookies]];
    for (NSHTTPCookie *cookie in cookies) {
        [cookieJar deleteCookie:cookie];
    }
    //删除cookies
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"sessionCookies"];
    [defaults synchronize];
}


@end
